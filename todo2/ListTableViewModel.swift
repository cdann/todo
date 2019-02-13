//
//  ListTableViewModel.swift
//  todo2
//
//  Created by celine dann on 05/02/2019.
//  Copyright © 2019 celine dann. All rights reserved.
//

import UIKit

typealias Settings = (displayDone:Bool, displayByList:Bool)
typealias Section = (title: String?, tasks: [Task])

class ListTableViewModel {
    var lists: [List]
    var settings: Settings = (displayDone: true, displayByList: true)
    var sections: [Section] = []
    private var onSectionsChange: (() -> ())?
    private let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    init(onSectionsChange: @escaping (() -> ())) {
        let context = appDelegate.persistentContainer.viewContext
        let requestedLists : [List]? = try? context.fetch(List.fetchRequest())
        lists =  requestedLists ?? []
        self.onSectionsChange = onSectionsChange
        updateSections()
    }

    init() {
        self.lists = []
    }
    
    // MARK: private functions
    
    private func updateSections() {
        if (self.settings.displayByList) {
            self.sections = lists.map({ list -> Section in
                let tasks = sortOrHideDoneTasks(tasks: list.tasks?.allObjects as! [Task])
                return (title: list.title, tasks: tasks)
            })
        } else {
            let tasks = lists.reduce([]) { tasks, list -> [Task] in
                var allTasks = tasks
                allTasks.append(contentsOf: list.tasks?.allObjects as! [Task])
                return allTasks
            }
            self.sections = [(title:"Main List", tasks: tasks)]
        }
        self.onSectionsChange?()
    }
    
    // MARK: getters
    
    func numberOfSections() -> Int {
        return self.sections.count
    }
    
    func numberOfRows(section index : Int) -> Int {
        return self.sections[index].tasks.count
    }
    
    func getSectionTitle(section index : Int) -> String? {
        return self.sections[index].title
    }
    
    func getRowTask(section : Int, row index : Int) -> Task {
        return self.sections[section].tasks[index]
    }
    
    func getAllLists() -> [List] {
        return lists
    }
    
    // MARK: create or change list
    
    private func createList(listTitle : String) -> List {
        let context = appDelegate.persistentContainer.viewContext
        let newList = List(context: context)
        newList.title = listTitle
        lists.append(newList)
        appDelegate.saveContext()
        return newList
    }
    
    private func putTaskInList(list : List, task : Task) {
        if let formerList = task.list, formerList !== list {
            formerList.removeFromTasks(task)
        }
        if task.list == nil {
            list.addToTasks(task)
        }
        appDelegate.saveContext()
    }
    
    func editTaskInList(editTask: Task?, editList: List?, taskName: String, newListTitle: String?) {
        let task = editTask ?? Task(context: appDelegate.persistentContainer.viewContext)
        task.title = taskName
        let list = editList ?? self.createList(listTitle: newListTitle ?? "")
        putTaskInList(list: list, task: task)
        appDelegate.saveContext()
        updateSections()
        onSectionsChange?()
    }
    
    // MARK: settings and sections
    
    func sortOrHideDoneTasks(tasks: [Task]) -> [Task] {
        if settings.displayDone {
            return tasks.sorted(by: { return !$0.done && $1.done })
        } else {
            return tasks.filter({ return !$0.done })
        }
    }
    
    func sortOrHideDoneInSections() {
        self.sections = self.sections.map { (section) -> Section in
            return (title: section.title, tasks: sortOrHideDoneTasks(tasks: section.tasks))
        }
        onSectionsChange?()
    }
    
    func changeSettings(settings:Settings) {
        self.settings = settings
        self.updateSections()
    }
}

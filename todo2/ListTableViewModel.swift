//
//  ListTableViewModel.swift
//  todo2
//
//  Created by celine dann on 05/02/2019.
//  Copyright © 2019 celine dann. All rights reserved.
//

import Foundation

typealias Settings = (displayDone:Bool, displayByList:Bool)
typealias Section = (title: String?, tasks: [Task])

class ListTableViewModel {
    var lists: [String : List]
    var settings: Settings = (displayDone: true, displayByList: true)
    private var onSectionsChange: (() -> ())?
    var sections: [Section] = []
    
    init(lists: [List], onSectionsChange: (() -> ())?) {
        self.lists = lists.reduce([:], { (indexedLists, list) -> [String : List] in
            var newList = indexedLists
            newList[list.uuid] = list
            return newList
        })
        self.onSectionsChange = onSectionsChange
        updateSections()
    }
    
    init() {
        self.lists = [:]
    }
    
    // MARK: private functions
    
    private func updateSections() {
        let listsArray = Array(lists.values)
        if (self.settings.displayByList) {
            self.sections = listsArray.map({ (list:List) -> Section in
                let tasks = sortOrHideDoneTasks(tasks: Array(list.tasks.values))
                return (title: list.title, tasks: tasks)
            })
            
        }
        else {
            let tasks = listsArray.reduce([], {
                (tasks:[Task], item:List) -> [Task] in
                var allTasks = tasks
                allTasks.append(contentsOf: Array(item.tasks.values))
                return allTasks
            })
            self.sections = [(title:"Ma liste", tasks: sortOrHideDoneTasks(tasks: tasks))]
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
        return Array(self.lists.values)
    }
    
    // MARK: create or change list
    
    func createList(listTitle : String, newTask title : String? = nil) -> List {
        let newList = List(title: listTitle, tasksTitle: title == nil ? [] : [title!])
        lists[newList.uuid] = newList
        updateSections()
        return newList
    }
    
    func putTaskInList(list : List, task : Task) {
        if task.listUuid != list.uuid, let formerList = self.lists[task.listUuid] {
            formerList.tasks.removeValue(forKey: task.uuid)
        }
        list.tasks[task.uuid] = task
        task.listUuid = list.uuid
        updateSections()
        print(task.listUuid)
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

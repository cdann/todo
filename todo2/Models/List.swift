//
//  List.swift
//  todo2
//
//  Created by celine dann on 01/02/2019.
//  Copyright © 2019 celine dann. All rights reserved.
//

import Foundation

class List {
    var title: String?
    var tasks: [String : Task]
    let uuid: String = UUID().uuidString
    
    init(title:String?) {
        self.title = title
        self.tasks = [:]
    }
    
    init(title:String?, tasksTitle: [String] = []) {
        self.title = title
        let uuid = self.uuid
        self.tasks = tasksTitle.reduce([:], { (prevTasks, title) -> [String : Task] in
            var tasks = prevTasks
            let task = Task(title: title, listUuid: uuid)
            tasks[task.uuid] = task
            return tasks
        })
        
    }
    
    init(title:String?, tasks: [Task] = []) {
        self.title = title
        self.tasks = tasks.reduce([:], { (prevTasks, task) -> [String : Task] in
            var tasks = prevTasks
            tasks[task.uuid] = task
            return tasks
        })
        
    }
    
    func switchTaskComplete(uuid: String) {
        guard let task = self.tasks[uuid] else {
            return
        }
        task.done = !task.done
    }
    

    
    static var lists:[List] = []
    
    static func sampleList() -> [List]{
        return ([
            List(title: "list1", tasksTitle:["task1.1", "task1.2"]),
            List(title: "list2", tasksTitle:["task2.1", "task2.2"]),
            ])
    }
    
}

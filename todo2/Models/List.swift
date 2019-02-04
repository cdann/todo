//
//  List.swift
//  todo2
//
//  Created by celine dann on 01/02/2019.
//  Copyright © 2019 celine dann. All rights reserved.
//

import Foundation

class List {
    var title: String
    var tasks: [Task]
    let uuid: String
    
    init(title:String, tasks:[Task] = []) {
        self.title = title
        self.tasks = tasks
        self.uuid = UUID().uuidString
    }
    
    func switchTaskComplete(index: Int) {
        self.tasks[index].done = !self.tasks[index].done
    }
    
    func getUndone() -> [Task]{
        return tasks.filter { return !$0.done}
    }
    
    func getDone() -> [Task] {
        return tasks.filter { return $0.done}
    }
    
    func sortByDone() {
        self.tasks.sort { (task1, task2) -> Bool in
            print("\(task1.title) \(task2.title) \(!task1.done || task2.done)")
            return !task1.done && task2.done
        }
    }
    

    
    static var lists:[List] = []
    
    static func sampleList() -> [List]{
        return ([
            List(title: "list1", tasks:[Task(title:"task1.1"), Task(title:"task1.2", done:true)]),
            List(title: "list2", tasks:[Task(title:"task2.1"), Task(title:"task2.2")]),
            ])
    }
    
}

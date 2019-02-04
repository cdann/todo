//
//  Task.swift
//  todo2
//
//  Created by celine dann on 01/02/2019.
//  Copyright © 2019 celine dann. All rights reserved.
//

import Foundation

class Task {
    var title:String
    var done:Bool = false
    
    init(title:String, done:Bool = false) {
        self.title = title
        self.done = done
    }
}

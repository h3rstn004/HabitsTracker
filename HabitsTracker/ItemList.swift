//
//  Item.swift
//  HabitsTracker
//
//  Created by Héctor Beristain on 28/06/26.
//

import Foundation
import SwiftData

@Model
final class ItemList {
    var timestamp: Date
    var title: String
    var taskhead: TaskItem?
    var tasktail: TaskItem?
    
    init(timestamp: Date, title: String) {
        self.timestamp = timestamp
        self.title = ""
        self.taskhead = nil
        self.tasktail = nil
    }
    
    public func addTaskToChain(_ title: String) {
        let newTask = TaskItem(title: title)
        if let tail = tasktail {
            newTask.previousTask = tail
            tail.nextTask = newTask
        } else {
            taskhead = newTask
            tasktail = newTask
        }
    }

    public func progressPercentage() -> Double {
        var totalTask: Double = 0
        var progress: Double = 0
        var percentage: Double = 0
        var currentTask: TaskItem? = tasktail
        while let task = currentTask {
            if task.finished {
                progress += task.finished ? 1 : 0
                totalTask += 1
            }
            currentTask = task.nextTask
        }
        percentage = progress / totalTask
        return percentage
    }
}

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
    var tasklist: TaskItem?
    
    init(timestamp: Date, title: String) {
        self.timestamp = timestamp
        self.title = ""
        self.tasklist = nil
    }
    
    public func addTaskToChain(_ newTask: TaskItem) {
        if self.tasklist == nil {
            self.tasklist = newTask
        } else {
            addTaskRecursive(self.tasklist, newTask)
        }
    }

    private func addTaskRecursive(_ current: TaskItem?, _ newTask: TaskItem) {
        if let currentTask = current {
            if currentTask.nextTask == nil {
                currentTask.nextTask = newTask
            } else {
                addTaskRecursive(currentTask.nextTask, newTask)
            }
        }
    }
}

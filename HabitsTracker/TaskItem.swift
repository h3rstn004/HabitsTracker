//
//  Task.swift
//  HabitsTracker
//
//  Created by Héctor Beristain on 28/06/26.
//

import Foundation
import SwiftData

@Model
final class TaskItem {
    var title: String
    var finished: Bool
    var nextTask: TaskItem?
    
    init() {
        self.title = ""
        self.finished = false
        self.nextTask = nil
    }

    public func setState() {
        self.finished.toggle()
    }
    
    public func getState() -> Bool {
        return self.finished
    }
    
    public func getNextTask() -> String?{
        return self.nextTask?.title
    }
}

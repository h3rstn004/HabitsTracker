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
    var task: SubTask?
    
    init(timestamp: Date, title: String) {
        self.timestamp = timestamp
        self.title = title
        self.task = nil
    }
    
    public func editName(newName: String) {
        self.title = newName
    }
    
    public func addTask(task: SubTask) {
        self.task = SubTask
    }
}

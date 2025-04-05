//
//  ToDoListItem+CoreDataProperties.swift
//  ToDoList
//
//  Created by Иван Семенов on 05.04.2025.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var isDone: Bool
    @NSManaged public var id: Int64
    @NSManaged public var taskDescription: String?

}

extension ToDoListItem : Identifiable {

}

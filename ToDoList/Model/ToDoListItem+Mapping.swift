//
//  ToDoListItem+Mapping.swift
//  ToDoList
//
//  Created by Иван Семенов on 06.04.2025.
//

import Foundation
import CoreData

extension ToDoListItem {
    static func from(dto: TodoDTO, context: NSManagedObjectContext) -> ToDoListItem {
        let item = ToDoListItem(context: context)
        item.id = Int64(dto.id)
        item.name = dto.todo
        item.isDone = dto.completed
        item.createdAt = Date()
        return item
    }
}

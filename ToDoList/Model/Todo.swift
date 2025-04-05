//
//  Todo.swift
//  ToDoList
//
//  Created by Иван Семенов on 05.04.2025.
//

import Foundation
import CoreData

struct TodoDTO: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

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

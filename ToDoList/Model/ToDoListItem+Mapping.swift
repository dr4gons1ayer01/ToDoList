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
        
        if item.taskDescription?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            item.taskDescription = Self.generateRandomDescription()
        }
        
        return item
    }
    //mock data
    static func generateRandomDescription() -> String {
        let descriptions = [
            "Не забыть проверить, что уже есть в холодильнике.",
            "Составить список необходимых продуктов для ужина.",
            "Сфокусироваться на выполнении важных задач.",
            "Записать мысли и идеи в блокнот.",
            "Найти время для отдыха и восстановления."
        ]
        return descriptions.randomElement() ?? "Задача без описания"
    }
}

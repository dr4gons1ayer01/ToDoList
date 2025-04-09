//
//  DataManager.swift
//  ToDoList
//
//  Created by Иван Семенов on 06.04.2025.
//

import UIKit

class DataManager {
    
    static let shared = DataManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getAllItems() -> [ToDoListItem] {
        do {
            return try context.fetch(ToDoListItem.fetchRequest())
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func createItem(name: String, description: String) {
        let newItem = ToDoListItem(context: context)
        newItem.id = Int64(Date().timeIntervalSince1970)
        newItem.name = name
        newItem.taskDescription = description
        newItem.createdAt = Date()
        saveContext()
    }
    
    func deleteItem(item: ToDoListItem) {
        context.delete(item)
        saveContext()
    }
    
    func updateItem(item: ToDoListItem, newName: String, newDescription: String) {
        item.name = newName
        item.taskDescription = newDescription
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Save error: \(error)")
        }
    }
}

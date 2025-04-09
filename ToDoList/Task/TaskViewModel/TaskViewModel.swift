//
//  TaskViewModel.swift
//  ToDoList
//
//  Created by Иван Семенов on 05.04.2025.
//

import UIKit

final class TaskViewModel {
    
    private(set) var items = [ToDoListItem]()
    private(set) var filteredItems = [ToDoListItem]()
    var onUpdate: (() -> Void)?
    
    let dataManager = DataManager.shared
    let networkManager: NetworkManager = NetworkManager(with: .default)
    
    //Network
    func fetchAndSaveFromAPI() {
        let hasLoaded = UserDefaults.standard.bool(forKey: "hasLoadedTodos")
        guard !hasLoaded else {
            getAllItems()
            return
        }
        
        networkManager.obtainTodos { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let todos):
                    UserDefaults.standard.set(true, forKey: "hasLoadedTodos")
                    
                    print("Получено задач: \(todos.count)")
                    todos.forEach { dto in
                        guard let self else { return }
                        // защита от дублей
                        if !self.items.contains(where: { $0.id == dto.id }) {
                            _ = ToDoListItem.from(dto: dto, context: self.dataManager.context)
                        }
                    }
                    self?.dataManager.saveContext()
                    self?.getAllItems()
                case .failure(let error):
                    print("Ошибка загрузки: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func filterItems(with text: String) {
        if text.isEmpty {
            filteredItems = items
        } else {
            filteredItems = items.filter {
                $0.name?.lowercased().contains(text.lowercased()) == true
            }
        }
        onUpdate?()
    }
    
    //CoreData
    func getAllItems() {
        items = dataManager.getAllItems()
        filteredItems = items
        onUpdate?()
    }
    
    func createItem(name: String, description: String) {
        dataManager.createItem(name: name, description: description)
        getAllItems()
    }
    
    func deleteItem(item: ToDoListItem) {
        dataManager.deleteItem(item: item)
        getAllItems()
    }
    
    func updateItem(item: ToDoListItem, newName: String, newDescription: String) {
        dataManager.updateItem(item: item, newName: newName, newDescription: newDescription)
        getAllItems()
    }
}

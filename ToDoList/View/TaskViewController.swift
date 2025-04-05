//
//  ViewController.swift
//  ToDoList
//
//  Created by Иван Семенов on 05.04.2025.
//

import UIKit

final class TaskViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let networkManager: NetworkManager = NetworkManager(with: .default)
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)
        return table
    }()
    
    private(set) var models = [ToDoListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Задачи"
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        getAllItems()
        addNavigationItems()
        fetchAndSaveFromAPI()
    }
    
    func fetchAndSaveFromAPI() {
        networkManager.obtainTodos { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let todos):
                    print("Получено задач: \(todos.count)")
                    todos.forEach { dto in
                        guard let self else { return }
                        // защита от дублей
                        if !self.models.contains(where: { $0.id == dto.id }) {
                            _ = ToDoListItem.from(dto: dto, context: self.context)
                        }
                    }
                    do {
                        try self?.context.save()
                        self?.getAllItems()
                    } catch {
                        print("Ошибка при сохранении: \(error)")
                    }
                case .failure(let error):
                    print("Ошибка загрузки: \(error.localizedDescription)")
                }
            }
        }
    }

    
    func addNavigationItems() {
        let addAction = UIAction { _ in
            let alert = UIAlertController(title: "Новая задача",
                                          message: nil,
                                          preferredStyle: .alert)
            alert.addTextField()
            alert.addAction(UIAlertAction(title: "Добавить", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                    return
                }
                self?.createItem(name: text)
            }))
            self.present(alert, animated: true)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: addAction)
    }

    //CoreData
    func getAllItems() {
        do {
            models = try context.fetch(ToDoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            //error
        }
    }
    
    func createItem(name: String) {
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        
        do {
            try context.save()
            getAllItems()
        } catch {
            //error
        }
    }
    
    func deleteItem(item: ToDoListItem) {
        context.delete(item)
        do {
            try context.save()
            getAllItems()
        } catch {
            //error
        }
    }
    
    func updateItem(item: ToDoListItem, newName: String) {
        item.name = newName
        do {
            try context.save()
            getAllItems()
        } catch {
            //error
        }
    }
}

extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let model = models[indexPath.row]
        cell.configureCell(with: model)
        
        return cell
    }
    
    //TODO: переделать
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        
        let sheet = UIAlertController(title: "Редактировать или Удалить",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        sheet.addAction(UIAlertAction(title: "Редактировать", style: .default, handler: { [weak self] _ in
            let alert = UIAlertController(title: "Редактирование",
                                          message: nil,
                                          preferredStyle: .alert)
            alert.addTextField()
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "Отмена", style: .destructive))
            alert.addAction(UIAlertAction(title: "Сохранить", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
                self?.updateItem(item: item, newName: newName)
            }))
            
            self?.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))
        present(sheet, animated: true)
    }
}

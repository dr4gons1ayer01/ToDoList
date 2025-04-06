//
//  ViewController.swift
//  ToDoList
//
//  Created by Иван Семенов on 05.04.2025.
//

import UIKit

final class TaskViewController: UIViewController {

    private let contentView: TaskView = .init()
    private let viewModel: TaskViewModel
    
    init(viewModel: TaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Задачи"
        
        configureTableView()
        configureBindings()
        
        addNavigationItems()
        viewModel.fetchAndSaveFromAPI()
    }
    
    private func configureTableView() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }
    
    private func configureBindings() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.contentView.tableView.reloadData()
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
                self?.viewModel.createItem(name: text)
            }))
            self.present(alert, animated: true)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: addAction)
    }
    
}

extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let model = viewModel.items[indexPath.row]
        cell.configureCell(with: model)
        
        return cell
    }
    
    //TODO: переделать
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.items[indexPath.row]
        
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
                self?.viewModel.updateItem(item: item, newName: newName)
            }))
            
            self?.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { [weak self] _ in
            self?.viewModel.deleteItem(item: item)
        }))
        present(sheet, animated: true)
    }
}

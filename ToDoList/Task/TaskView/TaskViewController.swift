//
//  ViewController.swift
//  ToDoList
//
//  Created by Иван Семенов on 05.04.2025.
//

import UIKit

final class TaskViewController: UIViewController {

    private let searchController = UISearchController()
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
        configureTableView()
        configureSearch()
        configureBindings()
        
        viewModel.fetchAndSaveFromAPI()
    }
    
    @objc private func didTapAddButton() {
        let alert = UIAlertController(title: "Новая задача",
                                      message: nil,
                                      preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Название задачи"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Описание"
        }

        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            guard let fields = alert.textFields,
                  let name = fields[0].text, !name.isEmpty,
                  let description = fields[1].text else { return }
            
            self?.viewModel.createItem(name: name, description: description)
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(addAction)
        
        alert.view.tintColor = .systemYellow
        
        present(alert, animated: true)
    }
    
    private func configureTableView() {
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        contentView.addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    }
    
    private func configureSearch() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = .systemYellow
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }
    
    private func configureBindings() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.contentView.tableView.reloadData()
                self?.contentView.taskCountLabel.text = "\(self?.viewModel.filteredItems.count ?? 0) Задач"
            }
        }
    }
}

//MARK: UISearchResultsUpdating
extension TaskViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterItems(with: searchText)
    }
}

//MARK: TaskTableViewCellDelegate
extension TaskViewController: TaskTableViewCellDelegate {
    func didToggleCompletion(for cell: TaskTableViewCell) {
        guard let indexPath = contentView.tableView.indexPath(for: cell) else { return }
        let item = viewModel.filteredItems[indexPath.row]
        viewModel.toggleCompletion(for: item)
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let model = viewModel.filteredItems[indexPath.row]
        cell.configureCell(with: model)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.filteredItems[indexPath.row]
        let detailVM = DetailViewModel(item: item)
        let detailVC = DetailViewController(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let item = viewModel.filteredItems[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let edit = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
                self?.presentEditAlert(for: item)
            }
            
            let share = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                let activityVC = UIActivityViewController(activityItems: [item.name ?? ""], applicationActivities: nil)
                self?.present(activityVC, animated: true)
            }
            
            let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                let confirmAlert = UIAlertController(title: "Удалить задачу?",
                                                     message: "Вы уверены что хотите удалить?",
                                                     preferredStyle: .alert)
                confirmAlert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
                confirmAlert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
                    self?.viewModel.deleteItem(item: item)
                }))
                self?.present(confirmAlert, animated: true)
            }
            return UIMenu(title: "", children: [edit, share, delete])
        }
    }

    private func presentEditAlert(for item: ToDoListItem) {
        let alert = UIAlertController(title: "Редактирование", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.text = item.name }
        alert.addTextField { $0.text = item.taskDescription }

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            guard
                let fields = alert.textFields,
                let name = fields[0].text, !name.isEmpty,
                let description = fields[1].text
            else { return }
            
            self?.viewModel.updateItem(item: item, newName: name, newDescription: description)
        }
        
        alert.addAction(saveAction)
        alert.view.tintColor = .systemYellow
        present(alert, animated: true)
    }
}

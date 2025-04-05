//
//  ViewController.swift
//  ToDoList
//
//  Created by Иван Семенов on 05.04.2025.
//

import UIKit

class FirstViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    let models = [ToDoListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Задачи"
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
    }
    
    //CoreData
    func getAllItems() {
        
    }
    
    func createItem(name: String) {
        
    }
    
    func deleteItem(item: ToDoListItem) {
        
    }
    
    func updateItem(item: ToDoListItem) {
        
    }
}

extension FirstViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var listConiguration = cell.defaultContentConfiguration()
        listConiguration.text = "Hello"
        listConiguration.secondaryText = "World"
        listConiguration.secondaryTextProperties.color = .systemIndigo
        cell.contentConfiguration = listConiguration
        
        return cell
    }
}

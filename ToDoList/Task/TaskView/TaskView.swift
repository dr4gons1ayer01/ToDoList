//
//  TaskView.swift
//  ToDoList
//
//  Created by Иван Семенов on 06.04.2025.
//

import UIKit

final class TaskView: UIView {

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.contentInsetAdjustmentBehavior = .automatic
        table.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)
        return table
    }()

    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .systemYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()

    lazy var taskCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 Задач"
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bottomBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.secondarySystemBackground
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(tableView)
        addSubview(bottomBar)
        bottomBar.addSubview(addButton)
        bottomBar.addSubview(taskCountLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor),

            bottomBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 90),

            addButton.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -16),
            addButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor, constant: -16),
            addButton.widthAnchor.constraint(equalToConstant: 28),
            addButton.heightAnchor.constraint(equalToConstant: 28),

            taskCountLabel.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor, constant: -16),
            taskCountLabel.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor),
        ])
    }
}

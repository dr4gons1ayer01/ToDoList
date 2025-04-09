//
//  DetailView.swift
//  ToDoList
//
//  Created by Иван Семенов on 06.04.2025.
//

import UIKit

final class DetailView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 34, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func formattedDate(_ date: Date?) -> String {
        guard let date else { return "-" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
    
    func configure(with item: ToDoListItem) {
        titleLabel.text = item.name
        dateLabel.text = formattedDate(item.createdAt)
        descriptionLabel.text = "\(item.taskDescription ?? "")"
    }
    
    private func setupLayout() {
        let mainStackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel, descriptionLabel])
        mainStackView.axis = .vertical
        mainStackView.alignment = .leading
        mainStackView.spacing = 12
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStackView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
}

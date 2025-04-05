//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Иван Семенов on 05.04.2025.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {
    
    private lazy var statusIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .medium)
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
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        statusIconImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with item: ToDoListItem) {
        dateLabel.text = dateFormat(item.createdAt)
        descriptionLabel.text = generateRandomDescription()
        
        let completed = item.isDone
        statusIconImageView.image = UIImage(systemName: completed ? "checkmark.circle" : "circle")
        statusIconImageView.tintColor = completed ? .systemYellow : .gray

        let title = item.name ?? ""
        let attributedString = NSMutableAttributedString(string: title)

        if completed {
            attributedString.addAttribute(.strikethroughStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSMakeRange(0, attributedString.length))
        }

        titleLabel.attributedText = attributedString
    }

    private func dateFormat(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
    
    func generateRandomDescription() -> String {
        let descriptions = [
            "Не забыть проверить, что уже есть в холодильнике.",
            "Составить список необходимых продуктов для ужина.",
            "Сфокусироваться на выполнении важных задач.",
            "Записать мысли и идеи в блокнот.",
            "Найти время для отдыха и восстановления."
        ]
        return descriptions.randomElement() ?? ""
    }
    
    private func setupLayout() {
        let mainStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, dateLabel])
        mainStackView.axis = .vertical
        mainStackView.alignment = .leading
        mainStackView.spacing = 4
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        let horizontalStack = UIStackView(arrangedSubviews: [statusIconImageView, mainStackView])
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 12
        horizontalStack.alignment = .top
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(horizontalStack)

        NSLayoutConstraint.activate([
            statusIconImageView.widthAnchor.constraint(equalToConstant: 24),
            statusIconImageView.heightAnchor.constraint(equalToConstant: 24),

            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Иван Семенов on 05.04.2025.
//

import UIKit

protocol TaskTableViewCellDelegate: AnyObject {
    func didToggleCompletion(for cell: TaskTableViewCell)
}

final class TaskTableViewCell: UITableViewCell {
    
    private lazy var statusIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
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
    
    weak var delegate: TaskTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        
        let tapGestureIconImageView = UITapGestureRecognizer(target: self, action: #selector(statusIconTapped))
        statusIconImageView.addGestureRecognizer(tapGestureIconImageView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        statusIconImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func statusIconTapped() {
        delegate?.didToggleCompletion(for: self)
    }
    
    func configureCell(with item: ToDoListItem) {
        dateLabel.text = dateFormat(item.createdAt)
        
        let description = item.taskDescription?.trimmingCharacters(in: .whitespacesAndNewlines)
        descriptionLabel.text = (description?.isEmpty == false) ? description : ToDoListItem.generateRandomDescription()
        
        let completed = item.isDone        
        UIView.transition(with: statusIconImageView,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
            self.statusIconImageView.image = UIImage(systemName: completed ? "checkmark.circle" : "circle")
            self.statusIconImageView.tintColor = completed ? .systemYellow : .gray
        })

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

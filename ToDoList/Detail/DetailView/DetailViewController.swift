//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Иван Семенов on 06.04.2025.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let contentView: DetailView = .init()
    private let viewModel: DetailViewModel
    
    init(viewModel: DetailViewModel) {
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
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .systemYellow
        contentView.configure(with: viewModel.item)
    }
}

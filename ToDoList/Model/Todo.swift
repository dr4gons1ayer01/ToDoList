//
//  Todo.swift
//  ToDoList
//
//  Created by Иван Семенов on 05.04.2025.
//

import Foundation

struct TodoDTO: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

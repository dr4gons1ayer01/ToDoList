//
//  NetworkManager.swift
//  ToDoList
//
//  Created by Иван Семенов on 05.04.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case emptyData
    case invalidData
}

class NetworkManager {
    
    private struct TodoResponse: Codable {
        let todos: [TodoDTO]
    }
    
    private let session: URLSession
    lazy var decoder: JSONDecoder = {
        JSONDecoder()
    }()
    
    init(with configuration: URLSessionConfiguration) {
        session = URLSession(configuration: configuration)
        
    }

    func obtainTodos(with completion: @escaping (Result<[TodoDTO], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        let request = URLRequest(url: url)
        session.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data else {
                completion(.failure(NetworkError.emptyData))
                return
            }
            do {
                let result = try self.decoder.decode(TodoResponse.self, from: data)
                completion(.success(result.todos))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}


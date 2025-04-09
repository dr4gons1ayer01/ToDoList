//
//  TaskViewModelTests.swift
//  ToDoListTests
//
//  Created by Иван Семенов on 09.04.2025.
//

import XCTest
import CoreData
@testable import ToDoList

final class TestCoreDataStack {
    static let shared = TestCoreDataStack()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Ошибка загрузки In-Memory Store: \(error)")
            }
        }
        return container
    }()

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}


protocol ToDoListItemRepresentable {
    var name: String? { get }
}

struct SimpleToDoItem: ToDoListItemRepresentable {
    var name: String?
}

final class MockDataManager: DataManaging {
    
    var mockItems: [ToDoListItem] = []

    func getAllItems() -> [ToDoListItem] {
        return mockItems
    }

    func createItem(name: String, description: String) {}
    func createItem(from dto: ToDoList.TodoDTO) {}
    func deleteItem(item: ToDoListItem) {}
    func updateItem(item: ToDoListItem, newName: String, newDescription: String) {}
    func saveContext() {}
}

final class TaskViewModelTests: XCTestCase {
    var viewModel: TaskViewModel!
    var mockDataManager: MockDataManager!

    override func setUp() {
        super.setUp()
        mockDataManager = MockDataManager()
        viewModel = TaskViewModel(dataManager: mockDataManager)
    }

    func test_filterItems_withSearchText_shouldReturnMatchingItems() {
        // Given
        let item1 = ToDoListItem(context: TestCoreDataStack.shared.viewContext)
        item1.name = "Покупки"

        let item2 = ToDoListItem(context: TestCoreDataStack.shared.viewContext)
        item2.name = "Спорт"

        mockDataManager.mockItems = [item1, item2]

        // When
        viewModel.getAllItems()
        viewModel.filterItems(with: "поку")

        // Then
        XCTAssertEqual(viewModel.filteredItems.count, 1)
        XCTAssertEqual(viewModel.filteredItems.first?.name, "Покупки")
    }
}


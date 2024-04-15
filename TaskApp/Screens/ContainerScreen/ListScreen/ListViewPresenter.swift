//
//  ListViewPresenter.swift
//  TestTask
//
//  Created by Mac on 17.03.2024.
//

import Foundation

protocol ListViewInPut: AnyObject {
    func updateUI(_ newTasks: [ToDoModel])
}

protocol ListViewOutPut: AnyObject {
    func moveToTaskView(with task: ToDoModel?)
    func deleteTaskWith(title: String?)
    func getTasks() -> [ToDoModel]
    func erase(task: ToDoModel)
    init(coreDataManager: CoreDataProtocol,
         router: RouterProtocol)
}

class ListViewPresenter: ListViewOutPut {
    // MARK: - Properties
    private weak var view: ListViewInPut?
    private var coreDataManager: CoreDataProtocol
    private var router: RouterProtocol
    
    // MARK: - Initialization
    required init(coreDataManager: CoreDataProtocol,
                  router: RouterProtocol) {
        self.coreDataManager = coreDataManager
        self.router = router
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataChange(_:)),
                                               name: .NSManagedObjectContextDidSave,
                                               object: nil)
    }
    
    // MARK: - Methods
    func setup(view: ListViewInPut?) {
        self.view = view
    }
    
    func moveToTaskView(with task: ToDoModel?) {
        router.showTaskView(with: task ?? ToDoModel())
    }
    
    func erase(task: ToDoModel) {
        coreDataManager.editTaskWith(title: task.title, taskInfo: task)
    }
    
    func deleteTaskWith(title: String?) {
        coreDataManager.deleteTaskWith(title: title ?? "")
    }
    
    func getTasks() -> [ToDoModel] {
        coreDataManager.fetchTasks().map { ToDoModel(title: $0.title,
                                                     explanation: $0.explanation,
                                                     isReady: $0.isReady) }
    }
    
    @objc
    private func handleDataChange(_ notification: Notification) {
        view?.updateUI(getTasks())
    }
}

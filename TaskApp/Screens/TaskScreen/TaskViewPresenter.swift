//
//  Presenter.swift
//  TestTask
//
//  Created by Mac on 17.03.2024.
//

import Foundation

protocol TaskViewOutPut: AnyObject {
    var oldTitleValue: String { get set }
    func added(_ task: ToDoModel)
    init(coreDataManager: CoreDataProtocol,
         router: RouterProtocol)
}

class TaskViewPresenter: TaskViewOutPut {
    // MARK: - Private Properties
    private var coreDataManager: CoreDataProtocol
    private var router: RouterProtocol
    var oldTitleValue = ""
    
    // MARK: - Initialization
    required init(coreDataManager: CoreDataProtocol, router: RouterProtocol) {
        self.coreDataManager = coreDataManager
        self.router = router
    }
    
    // MARK: - Methods
    private func edit(_ task: ToDoModel) {
        coreDataManager.editTaskWith(title: oldTitleValue, taskInfo: task)
    }
    
    func added(_ task: ToDoModel) {
        guard !task.title.isEmpty else { return }
        oldTitleValue.isEmpty ? coreDataManager.createTask(task) : edit(task)
        router.popToRoot()
    }
}

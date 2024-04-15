//
//  AssemblyModule.swift
//  TestTask
//
//  Created by Mac on 15.03.2024.
//

import Foundation
import UIKit

protocol AssemblyModuleProtocol {
    func assembleListView(router: RouterProtocol) -> UIViewController
    func assembleTaskView(router: RouterProtocol) -> UIViewController
    func assembleSourceView() -> UIViewController
}

class AssemblyModule: AssemblyModuleProtocol {
    private let coreDataManager = CoreDataManager()
    
    // MARK: - Methods
    func assembleListView(router: RouterProtocol) -> UIViewController {
        let listViewPresenter = ListViewPresenter(coreDataManager: coreDataManager, router: router)
        let listView = ListView(presenter: listViewPresenter)
        listViewPresenter.setup(view: listView)
        return listView
    }
    
    func assembleTaskView(router: RouterProtocol) -> UIViewController {
        let taskViewPresenter = TaskViewPresenter(coreDataManager: coreDataManager, router: router)
        let taskView = TaskView(presenter: taskViewPresenter)
        return taskView
    }
    
    func assembleSourceView() -> UIViewController {
        let sourceViewPresenter = SourceViewPresenter(networkManager: NetworkManager.shared)
        let sourceView = SourceView(sourcePresenter: sourceViewPresenter)
        sourceViewPresenter.setup(view: sourceView)
        return sourceView
    }
}

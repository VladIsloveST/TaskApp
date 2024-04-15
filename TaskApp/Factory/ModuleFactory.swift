//
//  ModuleFactory.swift
//  TestTask
//
//  Created by Mac on 18.03.2024.
//

import Foundation
import UIKit

protocol ModuleFactoryProtocol {
    func configureListModule(with navigationController: UINavigationController)
    func configureSourceModule() -> UIViewController
}

class ModuleFactory: ModuleFactoryProtocol {
    // MARK: - Private Properties
    private let assemblyModule: AssemblyModuleProtocol
    
    // MARK: - Initialization
    init(assemblyModule: AssemblyModuleProtocol = AssemblyModule()) {
        self.assemblyModule = assemblyModule
    }
    
    // MARK: - Methods
    func configureListModule(with navigationController: UINavigationController) {
        let router = ListRouter(navigatinController: navigationController,
                                assemblyModule: assemblyModule)
        router.initialViewController()
    }
    
    func configureSourceModule() -> UIViewController {
        assemblyModule.assembleSourceView()
    }
}

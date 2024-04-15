//
//  UITabBarController.swift
//  TestTask
//
//  Created by Mac on 14.03.2024.
//

import Foundation
import UIKit

extension UITabBarController  {
    func createTabBarItem(_ viewController: UIViewController, title: String,
                          imageName: String, selectedImage: String) -> UIViewController {
        viewController.tabBarItem.title = title
        let image = UIImage(systemName: imageName)
        viewController.tabBarItem.image = image
        viewController.tabBarItem.selectedImage = UIImage(systemName: selectedImage, withConfiguration: UIImage.SymbolConfiguration(pointSize: 18))
        return viewController
    }
}

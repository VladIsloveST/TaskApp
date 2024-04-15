//
//  UIViewController.swift
//  TestTask
//
//  Created by Mac on 18.03.2024.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertWith(message: String,
                       title: String = "Error",
                       actionTitle: String = "Cancel") {
        let attributedStringForMessage = NSAttributedString(string: message, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.setValue(attributedStringForMessage, forKey: "attributedMessage")
        let action = UIAlertAction(title: actionTitle, style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

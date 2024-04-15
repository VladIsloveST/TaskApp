//
//  UITextView.swift
//  TestTask
//
//  Created by Mac on 14.03.2024.
//

import Foundation
import UIKit

extension UITextView {
    func setupLayer() {
        layer.backgroundColor = UIColor.white.cgColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.25
    }
}

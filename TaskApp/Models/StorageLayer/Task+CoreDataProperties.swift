//
//  Task+CoreDataProperties.swift
//  TestTask
//
//  Created by Mac on 17.03.2024.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {}

extension Task {
    @NSManaged public var isReady: Bool
    @NSManaged public var explanation: String
    @NSManaged public var title: String
}

extension Task : Identifiable {}

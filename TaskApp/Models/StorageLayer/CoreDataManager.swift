//
//  CoreDataManager.swift
//  TestTask
//
//  Created by Mac on 17.03.2024.
//

import UIKit
import CoreData

private enum CoreDataError: Error {
    case unableToCreateDescription
    case unableToFetchArticlesFromContext
    case editingObjectError
}

protocol CoreDataProtocol {
    func createTask(_ taskData: ToDoModel)
    func fetchTasks() -> [Task]
    func editTaskWith(title: String, taskInfo: ToDoModel)
    func deleteTaskWith(title: String)
}

final class CoreDataManager: NSObject, CoreDataProtocol {    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    func createTask(_ taskData: ToDoModel) {
        guard !checkAvaible(with: taskData.title) else { return }
        guard let taskDescription = NSEntityDescription.entity(
            forEntityName: Task.description(), in: context)
        else { return print(CoreDataError.unableToCreateDescription) }
        let task = Task(entity: taskDescription, insertInto: context)
        task.title = taskData.title
        task.explanation = taskData.explanation
        task.isReady = taskData.isReady
        appDelegate.saveContext()
    }
    
    func fetchTasks() -> [Task] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Task.description())
        do {
            return try context.fetch(fetchRequest) as? [Task] ?? []
        } catch {
            print(CoreDataError.unableToFetchArticlesFromContext)
        }
        return []
    }
    
    func editTaskWith(title: String, taskInfo: ToDoModel) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Task.description())
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let results = try context.fetch(fetchRequest) as? [Task] ?? []
            if let object = results.first {
                object.title = taskInfo.title
                object.explanation = taskInfo.explanation
                object.isReady = taskInfo.isReady
                appDelegate.saveContext()
            }
        } catch {
            print(CoreDataError.editingObjectError)
        }
    }
    
    func deleteTaskWith(title: String) {
        guard !title.isEmpty,
                let task = fetchTasks().first(where: { $0.title == title }) else { return }
        context.delete(task)
        appDelegate.saveContext()
    }
    
    private func checkAvaible(with title: String) -> Bool {
        let tasks = fetchTasks()
        return tasks.contains { $0.title == title }
    }
}



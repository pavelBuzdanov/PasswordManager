//
//  CoreDataService.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 19.04.2021.
//

import Foundation
import CoreData

protocol CoreDataService {
    var mainContext: NSManagedObjectContext { get }
   
    
    func performSave(_ block: (NSManagedObjectContext) -> Void)
    
    func getObject<T: NSManagedObject>(entity: T.Type, with compareField: String, compareKey: String, context: NSManagedObjectContext) -> [T]?
    func getObjectWithBool<T: NSManagedObject>(entity: T.Type, compareField: String, boolState: Bool, context: NSManagedObjectContext) -> [T]?
    
    func performDelete(_ block: (NSManagedObjectContext) -> Void)
    func performUpdate(_ block: (NSManagedObjectContext) -> Void)
    
    func entityCountRequest<T: NSManagedObject>(entity: T.Type) -> Int?
}

class CoreDataManager: CoreDataService {
    
    // MARK: - Properties
    private let coreDataStack: CoreDataStack
    
    var mainContext: NSManagedObjectContext {
        return coreDataStack.mainContext
    }
    
    // MARK: - Constructor
    init(coreDataStack: CoreDataStack = CoreDataStack()) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - Fucntions
    func performSave(_ block: (NSManagedObjectContext) -> Void) {
        coreDataStack.performSave(block)
    }
    
    func getObject<T: NSManagedObject>(entity: T.Type, with compareField: String, compareKey: String, context: NSManagedObjectContext) -> [T]? {
        let fetchRequest = T.fetchRequest()
        let predicate = NSPredicate(format: "\(compareKey) = %@", compareField)
        fetchRequest.predicate = predicate
        
        do {
            guard let result = try context.fetch(fetchRequest) as? [T] else { return nil }
            return result
        } catch {
            print("Fetch Failure \(error) \(error.localizedDescription)")
            return nil
        }
    }
    
    func getObjectWithBool<T: NSManagedObject>(entity: T.Type, compareField: String, boolState: Bool, context: NSManagedObjectContext) -> [T]? {
        let fetchRequest = T.fetchRequest()
        let string = boolState ? "YES" : "NO"
        let predicate = NSPredicate(format: "\(compareField) = \(string)")
        fetchRequest.predicate = predicate
        
        do {
            guard let result = try context.fetch(fetchRequest) as? [T] else { return nil }
            return result
        } catch {
            print("Fetch Failure \(error) \(error.localizedDescription)")
            return nil
        }
    }
    
    func entityCountRequest<T: NSManagedObject>(entity: T.Type) -> Int? {
        let fetchRequest = T.fetchRequest()
        fetchRequest.resultType = .countResultType
        
        do {
            let result = try mainContext.count(for: fetchRequest)
            return result
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func performDelete(_ block: (NSManagedObjectContext) -> Void) {
        coreDataStack.performDelete(block)
    }
    
    func performUpdate(_ block: (NSManagedObjectContext) -> Void) {
        coreDataStack.performUpdate(block)
    }
    
    func saveContext() {
        do {
            try mainContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

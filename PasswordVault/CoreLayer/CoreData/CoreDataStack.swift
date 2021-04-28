
import Foundation
import CoreData

class CoreDataStack {
    
    // MARK: - Properties
    private static let modelName = "VaultModel"
    private static let modelExtension = "momd"
    
    private lazy var storeUrl: URL = {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("document path not found")
        }
        return documentsUrl.appendingPathComponent("\(CoreDataStack.modelName).sqlite")
    }()
    
    
    // MARK: - ManagedObjectModel
    private(set) static var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: CoreDataStack.modelName, withExtension: CoreDataStack.modelExtension) else {
            fatalError("Model not found")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("managedObjectModel cound not be created")
        }
        
        return managedObjectModel
    }()
    
    // MARK: - PersistentStoreCoordinator
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: CoreDataStack.managedObjectModel)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeUrl, options: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        return coordinator
    }()
    
    // MARK: - Contexts
    private lazy var writterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    private(set) lazy var deleteContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()

    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = writterContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    // MARK: - Save Context
    func performSave(_ block: (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait {
            block(context)
            if context.hasChanges {
                performSave(in: context)
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.obtainPermanentIDs(for: Array(context.registeredObjects))
                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        if let parent = context.parent {
            performSave(in: parent)
        }
    }
    
    func performDelete(_ block: (NSManagedObjectContext) -> Void) {
        let context = mainContext
        context.performAndWait {
            block(context)
            if context.hasChanges {
                performDelete(in: context)
            }
        }
    }
    
    private func performDelete(in context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.obtainPermanentIDs(for: Array(context.registeredObjects))
                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        if let parent = context.parent {
            performSave(in: parent)
        }
    }
    
    func performUpdate(_ block: (NSManagedObjectContext) -> Void) {
        let context = mainContext
        context.performAndWait {
            block(context)
            if context.hasChanges {
                performSave(in: context)
            }
        }
    }
    
}

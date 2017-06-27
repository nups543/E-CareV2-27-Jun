
import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    class var sharedInstance: CoreDataManager {
        struct Singleton {
            static let instance = CoreDataManager()
        }
        
        return Singleton.instance
    }
       private override init() {

        super.init()
    }
    
     lazy var persistentContainer: NSPersistentContainer = {
       
       let container = NSPersistentContainer(name: "E_CareV2")
        
        let description = NSPersistentStoreDescription() // enable auto lightweight migratn
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

   lazy var mainManagedObjectContext: NSManagedObjectContext = {
        
        let mainManagedObjectContext = self.persistentContainer.viewContext
        
        return mainManagedObjectContext
    }()
    
  //  func saveContext(){
       
     //   print("saveContext")
     //   let context = persistentContainer.viewContext
       // if context.hasChanges {
           // do {
             //   try context.save()
            //} catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
              //  let nserror = error as NSError
              //  fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            //}
 //   }
   // }
   }

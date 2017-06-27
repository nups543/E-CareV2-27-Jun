import UIKit
import CoreData

class GetData: NSObject {
    
//++++++++++++++++++++++++++++++++++++++++++++++Get Data Web Service++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    static func getJsonData(withParameter urlString: String, completion: @escaping (_ dictArray: [String: Any]?, _ error: Error?) -> Void){
        
        let request = URLRequest(url: URL(string: urlString)!)
        let task = URLSession.shared.dataTask(with: request) { ( data, response, error) in
        
            if let data = data{
                
                do {
                    if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                        completion(jsonData, nil)
                    }
                    
                }catch
                {
                    completion(nil, error)
                    print(error.localizedDescription)
                }
            }else{
                print("The request timed out")
            }
        }
    task.resume()
    
    }
 //++++++++++++++++++++++++++++++++++++++++++++++ALERT++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    static func showAlert (message :String?, title : String?, firstBtnText: String?, secondBtnText: String?,  firstBtnBlock:  @escaping () -> (), secondBtnBlock: @escaping () -> ())
    {
    
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)

        alertController.addAction(UIAlertAction(title: firstBtnText, style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            
            firstBtnBlock()
            
        }));
        
        if(secondBtnText != nil){
            
        alertController.addAction(UIAlertAction(title: secondBtnText, style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            
            // _ = self.navigationController?.popViewController(animated: true)
            secondBtnBlock()
           
        }));
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    //++++++++++++++++++++++++++++++++++++++++++++++FetchRequest+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    static func fetchPersistentData(entityName: String?, withPredicate: NSPredicate?) -> [NSManagedObject]{
        
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
            let request: NSFetchRequest<School> = School.fetchRequest()
            let newentity = NSEntityDescription.entity(forEntityName: entityName!, in: context)
            //request.predicate =  NSPredicate(format: "schoolCode = %@", code)
            request.entity = newentity
            request.returnsObjectsAsFaults = false
            
            do {
                let searchResults = try context.fetch(request) as [NSManagedObject]
                
                return searchResults
                
            } catch {
                
                self.showAlert(message: "No Data Found", title: "", firstBtnText: "OK", secondBtnText: nil, firstBtnBlock: {}, secondBtnBlock: {})
                
                print("Error with request: \(error)")
            }
    return []
        
    }
    
//    func deleteTestObjects(entity: String) {
//        
//        let context = getContext()
//        
//        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
//        fetch.returnsObjectsAsFaults = false
//        fetch.includesPropertyValues = false
//        
//        let request = NSBatchDeleteRequest(fetchRequest: fetch)
//        
//        do {
//            try context.execute(request)
//            print("Objects have been deleted")
//        } catch let error as NSError {
//            print("Error deleting objects \(error.localizedDescription)")
//        }
//        
//    }

}

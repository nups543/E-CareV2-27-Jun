import UIKit
import CoreData

class SenderIdViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var codeTxtfld1: UITextField!
    @IBOutlet weak var codeTxtfld2: UITextField!
    @IBOutlet weak var codeTxtfld3: UITextField!
    @IBOutlet weak var codeTxtfld4: UITextField!
    @IBOutlet weak var codeTxtfld5: UITextField!
    @IBOutlet weak var codeTxtfld6: UITextField!
    
    var schoolCodeTyped = String()
    var schoolArray = [[String: Any]]()
    var persistentContainer: NSPersistentContainer!
    let aSet  = NSCharacterSet.init(charactersIn:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz").inverted
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        persistentContainer = CoreDataManager.sharedInstance.persistentContainer
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        
        codeTxtfld1.text = ""
        codeTxtfld2.text = ""
        codeTxtfld3.text = ""
        codeTxtfld4.text = ""
        codeTxtfld5.text = ""
        codeTxtfld6.text = ""
        schoolCodeTyped = ""
        self.view.endEditing(true)
    }
    
    //MARK: textField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.font = UIFont(name: (textField.font?.fontName)!, size: 14)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        let nextTag: NSInteger = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        if (nextResponder != nil)
        {
            // Found next responder, so set it.
            nextResponder?.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        return false; // We do not want UITextField to insert line-breaks.
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let currentString   = textField.text! as NSString
        
        let newString       = currentString.replacingCharacters(in: range, with: string)
        let compSepByCharInSet      = string.components(separatedBy: aSet)
        let numberFiltered          = compSepByCharInSet.joined(separator: "")
       
        if ((newString.characters.count) <= 1 && string == numberFiltered) == true
        {
           
            textField.addTarget(self, action: #selector(self.textFieldMoveNext(textfield: )), for: UIControlEvents.editingChanged)
        }
        return (newString.characters.count) <= 1 && string == numberFiltered
    }
    
    func textFieldMoveNext(textfield : UITextField)//Custom
    {
        //print("textFieldMoveNext")
        
        let newString12 = textfield.text!
        //print("newString12 in next method = \(newString12)")
        if (newString12.characters.count == 0)
        {
            textFieldMoveBack(textfield: textfield)//Custom
        }
        else
        {
            let nextTag = textfield.tag + 1
            let nextResponder = textfield.superview?.viewWithTag(nextTag) as UIResponder!
            if (nextResponder != nil)
            {
                nextResponder?.becomeFirstResponder()
            } else {
                textfield.resignFirstResponder()
            }
        }
    }
    
    func textFieldMoveBack(textfield : UITextField)//Custom
    {
        let nextTag = textfield.tag - 1
        let nextResponder = textfield.superview?.viewWithTag(nextTag) as UIResponder!
        if (nextResponder != nil)
        {
            nextResponder?.becomeFirstResponder()
            
        } else {
            textfield.resignFirstResponder()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        schoolCodeTyped = String(format:"\(self.codeTxtfld1.text!)\(self.codeTxtfld2.text!)\(self.codeTxtfld3.text!)\(self.codeTxtfld4.text!)\(self.codeTxtfld5.text!)\(self.codeTxtfld6.text!)")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func enterPressed(_ sender: Any) {
        
        let urlString = "http://mobileservice.franciscansolutions.info/webservicejson.asmx/VerifySchoolCode?SchoolCode=\(schoolCodeTyped.uppercased())"
        
        GetData.getJsonData(withParameter: urlString) { (results, error) in
            
            if let result = results{
                
                if(result["Status"] as? String == "Success" ){
                    
                    let SchoolcodeExists = self.isCodeExist(code: self.schoolCodeTyped.uppercased())
                    
                    if( SchoolcodeExists == true){
                        
                        DispatchQueue.main.async{
                            
                            self.view.endEditing(true)
                            GetData.showAlert(message: "Dear User, the school/college code \(self.schoolCodeTyped.uppercased()) already exists, do you want to add another school?", title: "", firstBtnText: "NO", secondBtnText: "YES",
                                firstBtnBlock: {
                                
                                self.performSegue(withIdentifier: "loginSegue", sender: self)
                                
                                },
                                secondBtnBlock: {
                                    self.codeTxtfld1.text = ""
                                    self.codeTxtfld2.text = ""
                                    self.codeTxtfld3.text = ""
                                    self.codeTxtfld4.text = ""
                                    self.codeTxtfld5.text = ""
                                    self.codeTxtfld6.text = ""
                                    self.schoolCodeTyped = ""
                                    self.view.endEditing(true)
                                })
                        }
                        }else
                    {
                        self.saveData(dataResults: results)
                    }
                }else
                {
                    DispatchQueue.main.async{
                        
                        self.view.endEditing(true)
                        GetData.showAlert(message: "Wrong School Code entered", title: "", firstBtnText: "OK", secondBtnText: nil, firstBtnBlock: {}, secondBtnBlock: {})
                    }
                    
                }
            }
        }
    }
    
    func isCodeExist(code: String) -> Bool {

        let context2 = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let request: NSFetchRequest<School> = School.fetchRequest()
        let newentity = NSEntityDescription.entity(forEntityName: "School", in: context2)
        request.predicate =  NSPredicate(format: "schoolCode = %@", code)
        request.entity = newentity
        request.returnsObjectsAsFaults = false
        do {
            let searchResults = try context2.fetch(request) as [School]
            if(searchResults.count > 0){
            return true
            }else{
            return false
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        return false
    }
    
    func saveData (dataResults: [String: Any]?){
        
        self.persistentContainer.performBackgroundTask({ (backgroundContext) in
            
           // backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
            let schoolentity = NSEntityDescription.insertNewObject(forEntityName: "School", into: backgroundContext) as! School
            self.schoolArray = dataResults?["Table"] as! [[String : Any]]
            // print("self.schoolArray \n\(self.schoolArray)")
            for schoolData in self.schoolArray{
                
                if let name = schoolData["SchoolName"] as? String{
                    
                    schoolentity.schoolName = name
                    
                    DispatchQueue.main.async{
                        self.view.endEditing(true)
                        GetData.showAlert(message: "Dear User, the school/college code \(self.schoolCodeTyped.uppercased()) is found for \(name.uppercased())", title: "", firstBtnText: "OK", secondBtnText: nil, firstBtnBlock: {
                            
                            self.performSegue(withIdentifier: "loginSegue", sender: self)
                            
                        }, secondBtnBlock: {})
                    }
                if let website = schoolData["WebSite"] as? String{
                    schoolentity.schoolWebSite = website
                }
                if let ecarePanel = schoolData["EcarePanel"] as? String{
                    schoolentity.schoolEcare = ecarePanel
                }
                if let phone = schoolData["SupportPhone"] as? String{
                    schoolentity.supportPhone = phone
                }
                if let email = schoolData["SupportEmail"] as? String{
                    schoolentity.supportEmail = email
                }
                if self.schoolCodeTyped != ""{
                    schoolentity.schoolCode = self.schoolCodeTyped.uppercased()
                }
                do {
                    try backgroundContext.save()
                } catch {
                    fatalError("Failure to save context: \(error)")
                    }
                }
            }
        })
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
         self.view.endEditing(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if(segue.identifier ==  "loginSegue"){
            
            let logoImgPrefix = "http://mobile.franciscanecare.co.in/APLOGO/" + "THUM/" + "\(schoolCodeTyped).png"
            let logoNamePrefix = "http://mobile.franciscanecare.co.in/APLOGO/" + "FULL/" + "\(schoolCodeTyped).png"
            
            UserDefaults.standard.set(schoolCodeTyped, forKey: "currentSchoolCode")
            UserDefaults.standard.set("http://mobile.franciscanecare.co.in/APLOGO/", forKey: "logoUrlPrefix")
            
            let loginViewController = segue.destination as! LoginViewController
            
            if(schoolCodeTyped != ""){
                
            loginViewController.schoolCode = schoolCodeTyped
            loginViewController.logoNameImgUrl = logoNamePrefix
            loginViewController.logoImgUrl = logoImgPrefix
            }else{
                
                loginViewController.schoolCode = nil
                loginViewController.logoNameImgUrl = nil
                loginViewController.logoImgUrl = nil
            }
        }
    }
//    - (void)setupFetchedResultsController
//    {
//    // 1 - Decide what Entity you want
//    NSString *entityName = @"Car"; // Put your entity name here
//    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
//    
//    // 2 - Request that Entity
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
//    
//    // 3 - Filter it if you want
//    //request.predicate = [NSPredicate predicateWithFormat:@"Person.name = Blah"];
//    
//    // 4 - Sort it if you want
//    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name"
//    ascending:YES
//    selector:@selector(localizedCaseInsensitiveCompare:)]];
//    // 5 - Fetch it
//    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
//    managedObjectContext:self.managedObjectContext
//    sectionNameKeyPath:nil
//    cacheName:nil];
//    [self performFetch];
//    }

}

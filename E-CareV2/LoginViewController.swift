import UIKit
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var schoolNametxtFld: UITextField!
    @IBOutlet weak var usernametxtFld: UITextField!
    @IBOutlet weak var passwordtxtFld: UITextField!
    @IBOutlet weak var schoolimg: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var schoolNameImg: UIImageView!
    
    var persistentContainer: NSPersistentContainer!
    var logoImgUrl: String?
    var logoNameImgUrl: String?
    var schoolCode: String?
    var downBtn = UIButton()
    let effectView = UIView()
    var txtFldImage = UIImageView()
    var resultObjects = [School]()
    var userArray = [[String: Any]]()
    var schoolNamesAdded = [String]()
    var schoolCodesAdded = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.isHidden = true
        downBtn.isHidden = true
        
        resultObjects = GetData.fetchPersistentData(entityName: "School", withPredicate: nil) as! [School]
        persistentContainer = CoreDataManager.sharedInstance.persistentContainer
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        //self.navigationController?.navigationBar.shadowImage = UIImage()
        
        txtFldImage = UIImageView(frame: CGRect(x: 2.0, y: 0, width: 30, height: 22))
        schoolNametxtFld.leftView = txtFldImage
        
        if schoolCode != nil{
            
           // print("results \n \(resultObjects)")
            for result in resultObjects {
                
              if let schoolName = result.schoolName as String?{
                 schoolNametxtFld.text = schoolName
                     schoolNamesAdded.append(schoolName)
                }
                if let schoolCode1 = result.schoolCode as String?{
                     schoolCodesAdded.append(schoolCode1)
                }
            }

        let url1 = URL(string: logoImgUrl!)
        let url2 = URL(string: logoNameImgUrl!)
        
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url1!){
    
            DispatchQueue.main.async {
                self.schoolimg.image = UIImage(data: data)
                self.txtFldImage.image = UIImage(data: data)
            }
            }else{
                print("no image found")
            }
            if let data2 = try? Data(contentsOf: url2!){
    
                DispatchQueue.main.async {
                    self.schoolNameImg.image = UIImage(data: data2)
                }
            }else{
                print("no name image found")
            }
          }
        }else{
            
            print("Problem in getting school code")
        }
        
    }
    
    @IBAction func loginPressed(_ sender: Any) {
      
        if (usernametxtFld.text == "" && passwordtxtFld.text == ""){
            
            DispatchQueue.main.async{
                GetData.showAlert(message: "Please enter the details", title: "", firstBtnText: "OK", secondBtnText: nil, firstBtnBlock: {}, secondBtnBlock: {})
            }
        }else
        {
                  let urlString = "http://mobileservice.franciscansolutions.info/webservicejson.asmx/VerifyUser?SchoolCode=sjssgn&UserName=\(usernametxtFld.text!)&Password=\(passwordtxtFld.text!)"
            
                        GetData.getJsonData(withParameter: urlString) { (results, error) in
            
                            if let result = results{
            
                                if(result["Status"] as? String == "Success" ){
            
                                    let ifUserExists = self.isUserExist(username: self.usernametxtFld.text!, password: self.passwordtxtFld.text!)
            
                                    if( ifUserExists == true){
            
                                        DispatchQueue.main.async{
            
                                            self.view.endEditing(true)
                                            GetData.showAlert(message: "You are already signed in. Do you want to add another user?", title: "", firstBtnText: "NO", secondBtnText: "YES",
                                            firstBtnBlock: {
            
                                                        self.performSegue(withIdentifier: "mainViewSegue", sender: self)
            
                                            }, secondBtnBlock: {
                                                                
                                                                self.usernametxtFld.text = ""
                                                                self.passwordtxtFld.text = ""
                                                                self.view.endEditing(true)
                                            })
                                        }
                                    }else
                                    {
                                        self.saveData(dataResults: results, userName: self.usernametxtFld.text!, password: self.passwordtxtFld.text!)
                                        DispatchQueue.main.async {
                                          self.performSegue(withIdentifier: "mainViewSegue", sender: self)
                                        }
                                    }
                                }else{
                                    
                                    DispatchQueue.main.async {
                                        
                                        GetData.showAlert(message: "Incorrect username or password", title: "", firstBtnText: "OK", secondBtnText: nil, firstBtnBlock: {}, secondBtnBlock: {})
                                    }
                                    
                                }
                            }
                        }
            
                    }
        
    }

    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        if(textField == schoolNametxtFld){
            
        selectSchool(txtFld: textField)
            return false
        }
        return true
    }

    func selectSchool( txtFld: UITextField)  {
      
         tblView.frame = CGRect(x: txtFld.frame.origin.x , y: txtFld.frame.origin.y + txtFld.frame.size.height, width: txtFld.frame.size.width , height: 170 )
        
//        tblView.rowHeight                    = UITableViewAutomaticDimension
//        tblView.estimatedRowHeight           = 50
        
        downBtn.frame = CGRect(x: txtFld.frame.origin.x + txtFld.frame.size.width - 25, y: txtFld.frame.origin.y , width: 25 , height: txtFld.frame.size.height)
        downBtn.backgroundColor = UIColor.white
        downBtn.setBackgroundImage(UIImage(named : "Down Arrow"), for: UIControlState.normal)
        
        effectView.frame = self.view.frame
        effectView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
        
        self.view.addSubview(effectView)
        effectView.addSubview(downBtn)
        self.view.addSubview(tblView)
        
        tblView.isHidden = false
        downBtn.isHidden = false
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return schoolCodesAdded.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolList",for: indexPath as IndexPath)as! SchoolsTableViewCell
        
        cell.schoolName.text = schoolNamesAdded[indexPath.row]
        
        let logoUrlPrefix = UserDefaults.standard.object(forKey: "logoUrlPrefix") as! String
        let imageString = logoUrlPrefix + "THUM/" + "\(schoolCodesAdded[indexPath.row]).png"
        let imageUrl = URL(string: imageString)
        
        DispatchQueue.global(qos: .background).async {
            if let Imgdata = try? Data(contentsOf: imageUrl!){
                
                DispatchQueue.main.async {
                    cell.schoolImg.image = UIImage(data: Imgdata)

                }
            }else{
                print("no image found")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let getIndexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: getIndexPath) as! SchoolsTableViewCell
        
        let imageData = UIImagePNGRepresentation(currentCell.schoolImg.image!) as Data?
        
        let logoUrlPrefix = UserDefaults.standard.object(forKey: "logoUrlPrefix") as! String
        let imageString = logoUrlPrefix + "FULL/" + "\(schoolCodesAdded[getIndexPath.row]).png"
        let schoolNameUrl = URL(string: imageString)
        
        DispatchQueue.global(qos: .background).async {
                
                DispatchQueue.main.async {
                    self.schoolimg.image = UIImage(data: imageData!)
                    self.txtFldImage.image = UIImage(data: imageData!)
            }
            if let data2 = try? Data(contentsOf: schoolNameUrl!){
                
                DispatchQueue.main.async {
                    self.schoolNameImg.image = UIImage(data: data2)
                    
                }
            }else{
                print("no name image found")
            }
    }
    
        schoolNametxtFld.text = "\(schoolNamesAdded[getIndexPath.row])"
        UserDefaults.standard.set(schoolCodesAdded[getIndexPath.row], forKey: "currentSchoolCode")
        
        effectView.removeFromSuperview()
        tblView.isHidden = true
        downBtn.isHidden = true
    }
    
    func isUserExist(username: String, password: String) -> Bool {
        
        let context2 = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        let newentity = NSEntityDescription.entity(forEntityName: "User", in: context2)
        request.predicate =  NSPredicate(format: "username = %@ AND password = %@", username, password)
        request.entity = newentity
        request.returnsObjectsAsFaults = false
        do {
            let searchResults = try context2.fetch(request) as [User]
            print("searchResults \n \(searchResults)")
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

    func saveData (dataResults: [String: Any]?, userName : String, password: String){
        
        self.persistentContainer.performBackgroundTask({ (backgroundContext) in
         
            // backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
            let userEntity = NSEntityDescription.insertNewObject(forEntityName: "User", into: backgroundContext) as! User
            self.userArray = dataResults?["Table"] as! [[String : Any]]
            // print("self.schoolArray \n\(self.schoolArray)")
            for userData in self.userArray{
                
                userEntity.username = userName
                userEntity.password = password
                
                if let name = userData["Name"] as? String{
                    
                    userEntity.name = name
                    }
                    if let role = userData["Role"] as? String{
                        userEntity.panel = role
                    }
                    if let photoName = userData["Photo"] as? String{
                        userEntity.photo = photoName
                    }
                    if let studentClass = userData["Class"] as? String{
                        userEntity.studentClass = studentClass
                    }
                    if let studentId = userData["ID"] as? String{
                        userEntity.id = studentId
                    }
                    if let classId = userData["ClassId"] as? String{
                    userEntity.classId = classId
                    }
                
                    do {
                        try backgroundContext.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
            }
        )
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        effectView.removeFromSuperview()
        
        tblView.isHidden = true
        downBtn.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    }

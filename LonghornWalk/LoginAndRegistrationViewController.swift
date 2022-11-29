import UIKit
import FirebaseFirestore
import FirebaseAuth





class LoginAndRegistrationViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var loginOrRegistration: UISegmentedControl!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var loginOrSignupButton: UIButton!
    
    // Variables
    var screenType:String! = "Login"
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        print("\n\n WE ARE ON THE LOGIN SCREEN\n\n")
        
        super.viewDidLoad()
        
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        
        // Login screen is the default screen
        screenType = "Login"
        confirmPasswordTextField.isHidden = true
        confirmPasswordLabel.isHidden = true
        
        loginOrSignupButton.setTitle("Login", for: .normal)
        
//        Auth.auth().addStateDidChangeListener() {
//            auth, user in
//            if user != nil {
//                self.performSegue(withIdentifier: "loginSegue", sender: nil)
//                self.emailTextField.text = nil
//                self.passwordTextField.text = nil
//                self.confirmPasswordTextField.text = nil
//            }
//        }
        // Code for already logged in user to not login ??????
    }
    
    //MARK: SEGMENT CHANGE
    @IBAction func segmentChange(_ sender: Any) {
        // Change the storyboard's attributes on screen depending on what segment was chosen
        switch loginOrRegistration.selectedSegmentIndex {
        case 0:
            
            screenType = "Login"
            
            loginOrSignupButton.setTitle("Login", for: .normal)
            
            confirmPasswordTextField.isHidden = true
            confirmPasswordLabel.isHidden = true
            
        case 1:
            screenType = "SignUp"

            loginOrSignupButton.setTitle("Sign Up", for: .normal)

            confirmPasswordLabel.isHidden = false
            confirmPasswordTextField.isHidden = false
            
        default:
            screenType = "Login"
            
            loginOrSignupButton.setTitle("Login", for: .normal)
            
            confirmPasswordTextField.isHidden = true
            confirmPasswordLabel.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    //MARK: BUTTON IS PRESSED
    @IBAction func loginOrSignupIsPressed(_ sender: Any) {
        // Check for screen type first
        print("login or sign-up is pressed")
        
        if (screenType == "Login")
        {
            login()
        }
        else
        {
            signUp()
        }
    }
    
    func login()
    {
        // Login Path
        if loginCheck()
        {
            //MARK: FIREBASE AUTH LOGIN
            // User has all requirements fulfilled

            var email = emailTextField.text!
            var password = passwordTextField.text!

//            Auth.auth().addStateDidChangeListener() {
//                auth, user in
//                if user != nil {
//                    self.passwordTextField.text = nil
//                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
//                }
//            }
            
            Auth.auth().signIn(
                withEmail: email,
                password: password
            ) {
                (authResult, error) in

                if let error = error as NSError? {
                    self.statusLabel.text = "\(error.localizedDescription)"
                } else {
                    self.statusLabel.text = ""
                    UserProfile.loadUser(
                        email: email
                    )
                    self.emailTextField.text = nil
                    self.passwordTextField.text = nil
                    self.confirmPasswordTextField.text = nil
                    // successful login -> Segue into Homescreen
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            }
        } else {
            // Email PW pair not found
            let alert = UIAlertController(
                title: "Invalid Login",
                message: "Account Information Not Found",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default))
            present(alert, animated: true)
        }
    }
    
    func signUp() {
        // Registration Path
        print("\nuser is registering")
        var errorMessage = registerCheck()
        
        if (errorMessage != nil)
        // User does not have all requirements fulfilled
        {
            let alert = UIAlertController(
                title: "Requirements Not Met",
                message: errorMessage,
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default))
            present(alert, animated: true)
            return
        }
        print("\nregisterCheck is complete")
        // User has all requirements fulfilled
        //MARK: FIREBASE AUTH REGISTER
        print("\nFireBase Auth\n")
        
        var email = emailTextField.text!
        var password = passwordTextField.text!
        
       
        
        Auth.auth().createUser(
            withEmail: email,
            password: password
        ) {
            (authResult, error) in
            
            if let error = error as NSError? {
                print("\nThere are errors for Registration\n")
                self.statusLabel.text = "\(error.localizedDescription)"
            } else {
                // This is successful login
                print("No errors")
                // Update user in Firestore
                print("\nTEST ADDING NEW ENTRIES\n")
                self.statusLabel.text = ""
                self.emailTextField.text = nil
                self.passwordTextField.text = nil
                self.confirmPasswordTextField.text = nil
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                //MARK: FIRESTORE USER INIT
                //                    var ref: DocumentReference? = nil
                
//                var joinDate = Date()
//                var formatter = DateFormatter()
//                formatter.dateFormat = "dd-MM-yy"
//                var formattedDate = formatter.string(from: joinDate)
                
//                var user = UserProfile(
//                    userEmail: email,
//                    password: password,
//                    displayName: email,
//                    points: 0,
//                    joinDate: formattedDate
//                )
//
//                user.addUser()
//
//                appDelegate.currentUser = user
                
                //                    ref = self.db.collection("users").addDocument(data: [
                //                        "email": email,
                //                        "score": 0,
                //                        "joinDate": formattedDate,
                //                        "friendsList": [],
                //                        "locationsVisited": [],
                //                        "profilePicturePath": "",
                //                        "settingsPreferences": ""])
                //                    {err in
                //                        if let err = err {
                //                            print("Error adding document \(err)\n")
                //                        } else {
                //                            print("Document added with ID: \(ref!.documentID)\n")
                //
                //                        //MARK: USER CLASS INIT
                //                            self.currentUser = UserProfile(userEmail: self.emailTextField.text! ,username: self.usernameTextField.text!, password: self.passwordTextField.text!, displayName: ref!.documentID)
                //
                //                            AppDelegate.currentUser?.userEmail = self.emailTextField.text!
                //
                ////                        //MARK: STORE USER IN CORE DATA
                ////                            // store to core data
                ////                            let coreDatenewUser = NSEntityDescription.insertNewObject(forEntityName: "CoreDataUser", into: context)
                ////
                ////                            coreDatenewUser.setValue(self.emailTextField.text!, forKey: "email")
                ////                            coreDatenewUser.setValue(self.usernameTextField.text!, forKey: "username")
                ////                            coreDatenewUser.setValue(self.passwordTextField.text!, forKey: "password")
                ////                            coreDatenewUser.setValue(ref!.documentID, forKey: "displayName")
                ////
                ////                            print()
                ////                            print(coreDatenewUser)
                ////                            print()
                ////                            //commit the changes
                ////                            self.saveContext()
                ////                            print("CoreDataUser was saved")
                //
                //                            // Send user to homeScreen
                //                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
                //                        }
                //                    }
            }
        }
        
    }
    
    
    
    //MARK: REGISTRATION PATH
    func registerCheck() -> String?
    {
        // Check for filled fields
        if (!checkForFilledFields(textFields: emailTextField, passwordTextField, confirmPasswordTextField)) {
            // Check for same passwords
            return "Text field cannot be empty"
        }
        
        if (!checkForSamePassword(passwordField1: passwordTextField.text!, passwordField2: confirmPasswordTextField.text!)){
            // Check username Requirements
            return "Passwords don't match"
        }
        
        if (!checkForUTEmail(userEmail: emailTextField.text!)) {
            return "Email must be a UT email"
        }
        
        
        // User does not meet requirements for entry. Send error alert
        return nil
    }
    
    //MARK: LOGIN PATH
    func loginCheck() -> Bool{
        // Check for filled fields
        if checkForFilledFields(textFields: emailTextField, passwordTextField){
            return true
        }
        return false
    }
    
    // MARK: HELPER FUNCTIONS
    func checkForUTEmail(userEmail:String!) -> Bool{
        if userEmail.contains("@utexas.edu"){
            return true
        }
        return false
    }

    func checkForSamePassword(passwordField1:String!, passwordField2:String!) -> Bool{
        // Make sure password entries are the same and fulfill FireBase standards
        return ( (passwordField1 == passwordField2) && (passwordField1.count >= 6) && (passwordField2.count >= 6) )
    }

//    func checkUsernameRequirements(usernameRequest:String!) -> Bool{
//        // Check for string size of username entry
//        return ( (usernameRequest.count >= 6) && (usernameRequest.count <= 15) )
//    }

//    func checkForUniqueUsername(usernameEntry: String!) -> Bool{
        // CHECK BACK ON THIS LATER
//        // Look at users and make sure username entry is unique
//        print("\nUnique Username Check\n")
//        let db = Firestore.firestore()
//        db.collection("users").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//        }
//        return true
//
//    }

    func checkForFilledFields(textFields: UITextField...) -> Bool{
        // Make sure all entry boxes are filled out
        for textField: UITextField in textFields {
            if textField.text! == "" {
                return false
            }}
        return true
    }
}

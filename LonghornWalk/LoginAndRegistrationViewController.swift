import UIKit
import FirebaseFirestore
import FirebaseAuth

class LoginAndRegistrationViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var loginOrRegistration: UISegmentedControl!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
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
        usernameLabel.text = "Email:"
        confirmPasswordLabel.text = ""
        loginOrSignupButton.setTitle("Login", for: .normal)
        confirmPasswordTextField.isHidden = true
        emailLabel.isHidden = true
        emailTextField.isHidden = true
        
        // Code for already logged in user to not login ??????
        Auth.auth().addStateDidChangeListener() {
            auth, user in
            if user != nil && self.screenType == "Login" {
                self.usernameTextField.text = nil
                self.passwordTextField.text = nil
            }}
    }
    
    //MARK: SEGMENT CHANGE
    @IBAction func segmentChange(_ sender: Any) {
        // Change the storyboard's attributes on screen depending on what segment was chosen
        switch loginOrRegistration.selectedSegmentIndex {
        case 0:
            screenType = "Login"
            usernameLabel.text = "Email:"
            confirmPasswordLabel.text = ""
            loginOrSignupButton.setTitle("Login", for: .normal)
            confirmPasswordTextField.isHidden = true
            emailLabel.isHidden = true
            emailTextField.isHidden = true
        case 1:
            screenType = "SignUp"
            usernameLabel.text = "Username:"
            confirmPasswordLabel.text = "Confirm Password:"
            loginOrSignupButton.setTitle("Sign Up", for: .normal)
            confirmPasswordTextField.isHidden = false
            emailLabel.isHidden = false
            emailTextField.isHidden = false
        default:
            screenType = "Login"
            usernameLabel.text = "Email:"
            confirmPasswordLabel.text = ""
            loginOrSignupButton.setTitle("Login", for: .normal)
            confirmPasswordTextField.isHidden = true
            emailLabel.isHidden = true
            emailTextField.isHidden = true
        }
    }
    
    //MARK: BUTTON IS PRESSED
    @IBAction func loginOrSignupIsPressed(_ sender: Any) {
        // Check for screen type first
        print("login or sign-up is pressed")
        if screenType == "Login"{
            // Login Path
            if loginCheck(){
                //MARK: FIREBASE AUTH LOGIN
                // User has all requirements fulfilled
                Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) {
                    authResult, error in
                    if let error = error as NSError? {
                        print(error.localizedDescription)
                    } else {
                        // successful login -> Segue into Homescreen
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    }}
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
            
        } else {
            // Registration Path
            if registerCheck(){
                print("requirements met\n")
                // User has all requirements fulfilled
                //MARK: FIREBASE AUTH REGISTER
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) {
                    authResult, error in
                    if let error = error as NSError? {
                        print("\nThere are errors for Registration\n")
                        print("\(error.localizedDescription)")
                    } else {
                        // This is successful login
                        print("No errors")
                        // Update user in Firestore
                        print("\nTEST ADDING NEW ENTRIES\n")
                        
                        //MARK: FIRESTORE USER INIT
                        var ref: DocumentReference? = nil
                        print("username: \(self.usernameTextField.text!)")
                        ref = self.db.collection("users").addDocument(data: [
                            "username": "\(self.usernameTextField.text!)",
                            "email": "\(self.emailTextField.text!)",
                            "score": 0,])
                        {err in
                            if let err = err {
                                print("Error adding document \(err)\n")
                            } else {
                                print("Document added with ID: \(ref!.documentID)\n")
                                //MARK: USER CLASS INIT
                                
                                // Send user to homeScreen
                                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                            }
                        }}}
            } else {
                // User does not have all requirements fulfilled
                let alert = UIAlertController(
                    title: "Requirements Not Met",
                    message: "Please review User Requirements",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(
                    title: "OK",
                    style: .default))
                present(alert, animated: true)
            }}
    }
    
    //MARK: REGISTRATION PATH
    func registerCheck() -> Bool{
        // Check for filled fields
        if checkForFilledFields(textFields: emailTextField, usernameTextField, passwordTextField, confirmPasswordTextField){
            // Check for same passwords
            if checkForSamePassword(passwordField1: passwordTextField.text!, passwordField2: confirmPasswordTextField.text!){
                // Check username Requirements
                if checkUsernameRequirements(usernameRequest: usernameTextField.text!){
                        // Check for unique username
                    
                        if checkForUniqueUsername(usernameEntry: usernameTextField.text!){
                            // User Requirements are fulfilled
                            return true
                        }}}}
        // User does not meet requirements for entry. Send error alert
            return false
        }
    
    //MARK: LOGIN PATH
    func loginCheck() -> Bool{
        // Check for filled fields
        if checkForFilledFields(textFields: usernameTextField, passwordTextField){
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

    func checkUsernameRequirements(usernameRequest:String!) -> Bool{
        // Check for string size of username entry
        return ( (usernameRequest.count >= 6) && (usernameRequest.count <= 15) )
    }

    func checkForUniqueUsername(usernameEntry: String!) -> Bool{
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
        return true
        
    }

    func checkForFilledFields(textFields: UITextField...) -> Bool{
        // Make sure all entry boxes are filled out
        for textField: UITextField in textFields {
            if textField.text! == "" {
                return false
            }}
        return true
    }
}

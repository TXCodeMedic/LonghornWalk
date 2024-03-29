//
//  LoginAndRegistrationViewController.swift
//  LonghornWalk
//
//  Created by Matthew Galvez on 11/13/22.
//
// Filename: LonghornWalk
// Team: 10
// Course: CS329E

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol UserLoadProtocol {
    func userLoaded()
}

class LoginAndRegistrationViewController: UIViewController, UserLoadProtocol {
    
    // Outlets
    @IBOutlet weak var loginOrRegistration: UISegmentedControl!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var loginOrSignupButton: UIButton!
    
    // Variables
    var screenType:String! = "Login"
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        if UserDefaults.standard.bool(forKey: "darkMode") == false {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
        } else {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
        }
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        // Login screen is the default screen
        screenType = "Login"
        confirmPasswordTextField.isHidden = true
        confirmPasswordLabel.isHidden = true
        loginOrSignupButton.setTitle("Login", for: .normal)
        appDelegate.userProtocol = self
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
        if (screenType == "Login")
        {
            login()
        }
        else
        {
            signUp()
        }
    }
    
    func userLoaded() {
        // successful user load -> Segue into Homescreen
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
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
            Auth.auth().signIn(
                withEmail: email,
                password: password
            ) {
                (authResult, error) in
                if let error = error as NSError? {
                    //send alert to user for fail login
                    let alert = UIAlertController(
                        title: "Failed Login",
                        message: error.localizedDescription,
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(
                        title: "OK",
                        style: .default))
                    self.present(alert, animated: true)
                    return
                } else {
                    UserProfile.loadUser(
                        email: email
                    )
                    self.emailTextField.text = nil
                    self.passwordTextField.text = nil
                    self.confirmPasswordTextField.text = nil
                    // successful login -> Segue into Homescreen
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
    
    func signUp()  {
        // Registration Path
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
        // User has all requirements fulfilled
        //MARK: FIREBASE AUTH REGISTER
        var email = emailTextField.text!
        var password = passwordTextField.text!
        Auth.auth().createUser(
            withEmail: email,
            password: password
        ) {
            (authResult, error) in
            if let error = error as NSError? {
                var errorCode = error.code
                self.sameUserFound(errorCode: errorCode )
                return
            } else {
                // This is successful login
                // Update user in Firestore
                self.emailTextField.text = nil
                self.passwordTextField.text = nil
                self.confirmPasswordTextField.text = nil
                //MARK: FIRESTORE USER INIT
                var ref: DocumentReference? = nil
                var joinDate = Date()
                var formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yy"
                var formattedDate = formatter.string(from: joinDate)
                ref = self.db.collection("users").addDocument(data: [
                    "email": email,
                    "displayName": email,
                    "score": 0,
                    "joinDate": formattedDate,
                    "lastUpdate": formattedDate,
                    "profilePicturePath": "profilePictures/defaultProfilePicture.jpeg"])
                {err in
                    if let err = err {
                    } else {
                        UserProfile.loadUser(
                            email: email
                        )
                    }
                }
            }
        }
    }
    
    //MARK: REGISTRATION PATH
    func registerCheck() -> String?
    {
        // Check for filled fields
        if (!checkForFilledFields(textFields: emailTextField, passwordTextField, confirmPasswordTextField)) {
            // Check for same passwords
            return "Text fields cannot be empty"
        }
        if (!checkForSamePassword(passwordField1: passwordTextField.text!, passwordField2: confirmPasswordTextField.text!)){
            // Check username Requirements
            return "Passwords don't match"
        }
        if (!checkForPasswordLength(passwordField: passwordTextField.text!)){
            return "Password less than 6 characters"
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

    func checkForPasswordLength(passwordField:String) -> Bool{
        return passwordField.count >= 6
    }
    
    func checkForSamePassword(passwordField1:String!, passwordField2:String!) -> Bool{
        // Make sure password entries are the same and fulfill FireBase standards
        return  (passwordField1 == passwordField2)
    }

    func checkForFilledFields(textFields: UITextField...) -> Bool{
        // Make sure all entry boxes are filled out
        for textField: UITextField in textFields {
            if textField.text! == "" {
                return false
            }}
        return true
    }
    
    func sameUserFound(errorCode:Int){
        if errorCode == 17007{
            let alert = UIAlertController(
                title: "User is already registered",
                message: "Email is already registered to another account",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default))
            present(alert, animated: true)
            return
        } else {
            let alert = UIAlertController(
                title: "Unknown Error",
                message: "Unknown Error is presented. Email App Development team",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default))
            present(alert, animated: true)
            return
        }
    }
}

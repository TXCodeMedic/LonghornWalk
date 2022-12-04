//
//  User.swift
//  LonghornWalk
//
//  Created by Katrina Aliashkevich on 11/22/22.
//

import UIKit
import FirebaseFirestore

var userDocs:QuerySnapshot?

class UserProfile {
    
    public var userEmail: String
    public var password: String
    public var points: Int
    public var displayName: String
    // YYYY-MM-DD format for join date
    public var joinDate: String
    public var friendsList: [String]
    public var locationsVisited: [String]
    // file path to the image file stored in String format? not sure yet
    public var profilePic: UIImage?
    // store the setting preferences of the user somehow?
    public var settingPreferences: String
    
    
    init(userEmail: String, password: String, displayName:String, points: Int, joinDate: String) {
        
        self.userEmail = userEmail
        self.password = password
        self.joinDate = joinDate
        self.points = points
        self.displayName = displayName
        self.friendsList = []
        self.locationsVisited = []
        self.profilePic = nil
        self.settingPreferences = ""
    }
    
    
    static func loadUser(email: String) {
        // https://console.firebase.google.com/u/1/project/longhornwalk-4abea/firestore/data/~2Fusers
        let db = Firestore.firestore()
        // get user info from DB

        
        db.collection("users").getDocuments { snapshot, error in
            // no error
            if error == nil {
                // retrieve data from DB
                if let snapshot = snapshot{

                    // loop through users in data base
                    for doc in snapshot.documents{
                        // get data from user that matches currently logged in user
                        if (
                            doc["email"] as? String == email
                        ) {
                            // this is our current user that is logged in
                            appDelegate.currentUser = UserProfile(
                                userEmail: doc["email"] as? String ?? "",
                                password: doc["password"] as? String ?? "",
                                displayName: doc["displayName"] as? String ?? "",
                                points: doc["score"] as? Int ?? 0,
                                joinDate: doc["joinDate"] as? String ?? ""
                            )
                            appDelegate.userProtocol?.userLoaded()
                            break
                            // update score of this user from DB
                            //self.currentUser.points = doc["score"] as? Int ?? 0
                            // !!! should we also update joinDate, friendsList, etc. ?

                            // this data should already be in core data since we store every new user in core data
                        }
                    }
                    // status
                    print("in login path: end of loop through Firestore DB, updated current user to current user that is logged in")
                }
            }
            else{
                print("error retrieving from DB")
            }
        }
    }
    
    func saveUser() {
        // https://console.firebase.google.com/u/1/project/longhornwalk-4abea/firestore/data/~2Fusers
        let db = Firestore.firestore()
        // get user info from DB

        
        db.collection("users").getDocuments { snapshot, error in
            // no error
            if error == nil {
                // retrieve data from DB
                if let snapshot = snapshot{

                    // loop through users in data base
                    for doc in snapshot.documents{
                        // get data from user that matches currently logged in user
                        if (
                            doc["email"] as? String == self.userEmail
                        ) {
                            doc.reference.updateData(["displayName": self.displayName, "score": self.points])
    
                            break
                        }
                    }
                    // status
                    print("in login path: end of loop through Firestore DB, updated current user to current user that is logged in")
                }
            }
            else{
                print("error retrieving from DB")
            }
        }
    }
    
//    func addUser() {
//        //MARK: FIRESTORE USER INIT
//        let db = Firestore.firestore()
//        var ref: DocumentReference? = nil
//
//        var joinDate = Date()
//        var formatter = DateFormatter()
//        formatter.dateFormat = "dd-MM-yy"
//        var formattedDate = formatter.string(from: joinDate)
//
//        ref = db.collection("users").addDocument(data: [
//            "email": "\(userEmail)",
//            "score": points,
//            "joinDate": formattedDate,
//            "friendsList": [],
//            "locationsVisited": [],
//            "profilePicturePath": "",
//            "settingsPreferences": ""])
//        {err in
//            if let err = err {
//                print("Error adding document \(err)\n")
//            } else {
//                print("Document added with ID: \(ref!.documentID)\n")
//            }
//        }
//    }
    
}

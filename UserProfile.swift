//
//  User.swift
//  LonghornWalk
//
//  Created by Katrina Aliashkevich on 11/22/22.
//
// Filename: LonghornWalk
// Team: 10
// Course: CS329E

import UIKit
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import FirebaseStorage

var userDocs:QuerySnapshot?
let storage = Storage.storage()

class UserProfile {
    
    public var userEmail: String
    public var password: String
    public var points: Int
    public var displayName: String
    public var joinDate: String
    public var lastUpdate:String
    public var locationsVisited: [String]
    public var profilePic: UIImage?
    public var profilePicturePath:String
    
    
    init(userEmail: String, password: String, displayName:String, points: Int, joinDate: String, profilePicturePath:String, lastUpdate:String) {
        
        self.userEmail = userEmail
        self.password = password
        self.joinDate = joinDate
        self.lastUpdate = lastUpdate
        self.points = points
        self.displayName = displayName
        self.locationsVisited = []
        self.profilePic = nil
        self.profilePicturePath = profilePicturePath
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
                                joinDate: doc["joinDate"] as? String ?? "",
                                profilePicturePath: doc["profilePicturePath"] as? String ?? "",
                                lastUpdate: doc["lastUpdate"] as? String ?? ""
                            )
                            // pull picture from storage
                            let storageRef = storage.reference(withPath:appDelegate.currentUser?.profilePicturePath as! String)
                            storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                              if let error = error {
                                // Uh-oh, an error occurred!
                              } else {
                                // Data for "images/island.jpg" is returned
                                let image = UIImage(data: data!)
                                  appDelegate.currentUser?.profilePic = image
                              }
                            appDelegate.userProtocol?.userLoaded()
                            }
                            break
                        }
                    }
                }
            }
            else{
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
                            doc.reference.updateData(["displayName": self.displayName, "score": self.points, "profilePicturePath": self.profilePicturePath, "lastUpdate":self.lastUpdate ])
                            break
                        }
                    }
                }
            }
            else{
            }
        }
    }
}

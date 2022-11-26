//
//  User.swift
//  LonghornWalk
//
//  Created by Katrina Aliashkevich on 11/22/22.
//

import UIKit

class User {

    public var userEmail: String
    public var username: String
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
    

    init(userEmail: String, username: String, password: String, displayName:String) {
        
        var joinDate = Date()
        var formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yy"
        var formattedDate = formatter.string(from: joinDate)
        
        self.userEmail = userEmail
        self.username = username
        self.password = password
        self.joinDate = formattedDate
        self.points = 0
        self.displayName = displayName
        self.friendsList = []
        self.locationsVisited = []
        self.profilePic = nil
        self.settingPreferences = ""
    }
}

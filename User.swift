//
//  User.swift
//  LonghornWalk
//
//  Created by Katrina Aliashkevich on 11/22/22.
//

import UIKit

class User {

    public var username: String
    public var password: String
    public var points: Int
    public var displayName: String
    // YYYY-MM-DD format for join date
    public var joinDate: String
    public var friendsList: [String]
    public var locationsVisited: [String]
    // file path to the image file stored in String format? not sure yet
    public var profilePic: String
    // store the setting preferences of the user somehow?
    public var settingPreferences: String
    

    init(username: String, password: String, joinDate: String, displayName:String) {
        self.username = username
        self.password = password
        self.joinDate = joinDate
        self.points = 0
        self.displayName = displayName
        self.friendsList = []
        self.locationsVisited = []
        self.profilePic = ""
        self.settingPreferences = ""
    }
}

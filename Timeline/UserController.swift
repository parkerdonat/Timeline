//
//  UserController.swift
//  Timeline
//
//  Created by Parker Donat on 2/23/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation

class UserController {
    
    // returns the current user as an implicitly unwrapped optional. We are building an assumption that if there is no user, the login/signup screen will be presented until there is one.
    var currentUser: User! = UserController.mockUsers().first
    
    static let sharedController = UserController()
    
    static func userForIdentifier(identifier: String, completion: (user: User?) -> Void) {
        completion(user: mockUsers().first)
    }
    
    static func fetchAllUsers(completion: (users: [User]) -> Void) {
        completion(users: mockUsers())
    }
    
    static func followUser(user: User, completion: (success: Bool) -> Void) {
        completion(success: true)
    }
    
    static func userFollowsUser(user: User, followsUser: User, completion: (follows: Bool) -> Void ) {
        completion(follows: true)
    }
    
    static func followedByUser(user: User, completion: (followed: [User]?) -> Void) {
        completion(followed: mockUsers())
    }
    
    // used to authenticate against Firebase database of users
    static func authenticateUser(email: String, password: String, completion: (success: Bool, user: User?) -> Void) {
        completion(success: true, user: mockUsers().first)
    }
    
    // used to create a user in Firebase
    static func createUser(email: String, username: String, password: String, bio: String?, url: String?, completion: (success: Bool, user: User?) -> Void) {
        completion(success: true, user: mockUsers().first)
    }
    
    static func updateUser(user: User, username: String, bio: String?, url: String?, completion: (success: Bool, user: User?) -> Void) {
        completion(success: true, user: mockUsers().first)
    }
    
    static func logoutCurrentUser() {
        
    }
    
    static func mockUsers() -> [User] {
        
        let user1 = User(username: "parker", uid: "1234")
        let user2 = User(username: "kristi", uid: "1235")
        let user3 = User(username: "griffin", uid: "1236")
        
        return [user1, user2, user3]
    }
}
//
//  PostController.swift
//  Timeline
//
//  Created by Parker Donat on 2/24/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation
import UIKit

class PostController {
    
    
    static func fetchTimelineForUser(user: User, completion: (posts: [Post]?) -> Void) {
        
        completion(posts: mockPosts())
    }
    
    static func addPost(image: UIImage, caption: String?, completion: (success: Bool, post: Post?) -> Void) {
        
        completion(success: true, post: mockPosts().first)
    }
    
    static func postFromIdentifier(identifier: String, completion: (post: Post?) -> Void) {
        
        completion(post: mockPosts().first)
    }
    
    static func postsForUser(user: User, completion: (posts: [Post]?) -> Void) {
        
        completion(posts: mockPosts())
    }
    
    static func deletePost(post: Post) {
        
        
    }
    
    static func addCommentWithTextToPost(text: String, post: Post, completion: (success: Bool, post: Post?) -> Void?) {
        
        completion(success: true, post: mockPosts().first)
    }
    
    static func deleteComment(comment: Comment, completion: (success: Bool, post: Post?) -> Void) {
        
        completion(success: true, post: mockPosts().first)
    }
    
    static func addLikeToPost(post: Post, completion: (success: Bool, post: Post?) -> Void) {
        
        completion(success: true, post: mockPosts().first)
    }
    
    static func deleteLike(like: Like, completion: (success: Bool, post: Post?) -> Void) {
        
        completion(success: true, post: mockPosts().first)
    }
    
    static func orderPosts(posts: [Post]) -> [Post] {
        
        return []
    }
    
    static func mockPosts() -> [Post] {
        
        let sampleImageIdentifier = "-K1l4125TYvKMc7rcp5e"
        
        let like1 = Like(username: "parker", postIdentifier: "1234")
        let like2 = Like(username: "kristi", postIdentifier: "4566")
        let like3 = Like(username: "griffin", postIdentifier: "43212")
        
        let comment1 = Comment(username: "parker", text: "love this", postIdentifier: "1234")
        let comment2 = Comment(username: "kristi", text: "cool stuff", postIdentifier: "4566")
        
        let post1 = Post(imageEndpoint: sampleImageIdentifier, caption: "Nice shot!", comments: [comment1, comment2], likes: [like1, like2, like3])
        let post2 = Post(imageEndpoint: sampleImageIdentifier, caption: "Great lookin' kids!")
        let post3 = Post(imageEndpoint: sampleImageIdentifier, caption: "Love the way she looks when she smiles like that.")
        
        return [post1, post2, post3]
    }
    
    
}

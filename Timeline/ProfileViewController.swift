//
//  ProfileViewController.swift
//  Timeline
//
//  Created by Parker Donat on 2/23/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit
import SafariServices

class ProfileViewController: UIViewController, UICollectionViewDataSource, ProfileHeaderCollectionReusableViewDelegate {

    var user: User?
    var userPosts: [Post] = []
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if user == nil {
            user = UserController.sharedController.currentUser
            editBarButtonItem.enabled = true
        }
        
        print(user)
        updateBasedOnUser()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UserController.userForIdentifier(user!.identifier!) { (user) -> Void in
            self.user = user
            self.updateBasedOnUser()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateBasedOnUser() {
        guard let user = user else { return}
        
        title = user.username
        
        // Use the PostController to fetch the posts for the user, assign the userPosts to the results, and reload the collection view in the completion closure. 
        
        PostController.postsForUser(user) { (posts) -> Void in
            if let posts = posts {
                self.userPosts = posts
            } else {
                self.userPosts = []
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.collectionView.reloadData()
            })
        }

    }
    
    // MARK: - Logout Method
    
    func logoutButtonTapped() {
        
    }
    
    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        
        let post = userPosts[indexPath.item]
        
        cell.updateWithImageIdentifier(post.imageEndpoint)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView", forIndexPath: indexPath) as! ProfileHeaderCollectionResuableView
        
        headerView.updateWithUser(user!)
        headerView.delegate = self
        
        return headerView
    }

    // MARK: - Profile Header Collection Reusable View Delegate
    
    func userTappedURLButton() {
        if let profileURL = NSURL(string: user!.url!) {
            
            let safariViewController = SFSafariViewController(URL: profileURL)
            
            presentViewController(safariViewController, animated: true, completion: nil)
        }
    }
    
    func userTappedFollowActionButton() {
        guard let user = user else { return }
        
        if user == UserController.sharedController.currentUser {
            
            UserController.logoutCurrentUser()
            tabBarController?.selectedViewController = tabBarController?.viewControllers![0]
            
        } else {
            UserController.userFollowsUser(UserController.sharedController.currentUser, followsUser: user) { (follows) -> Void in
                
                if follows {
                    UserController.unfollowUser(self.user!, completion: { (success) -> Void in
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.updateBasedOnUser()
                        })
                    })
                } else {
                    UserController.followUser(self.user!, completion: { (success) -> Void in
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.updateBasedOnUser()
                        })
                    })
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editUser" {
            let destinationViewController = segue.destinationViewController as? LoginSignupViewController
            
            _ = destinationViewController?.view
            
            destinationViewController?.updateWithUser(user!)
        }
    }
        
}

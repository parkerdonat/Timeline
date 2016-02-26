//
//  UserSearchTableViewController.swift
//  Timeline
//
//  Created by Parker Donat on 2/23/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class UserSearchTableViewController: UITableViewController {
    
    
    //MARK: - Properties
    @IBOutlet weak var modeSegmentedControl: UISegmentedControl!
    
    // This array will hold the users that should be displayed in the table view. Only friends when displaying the friends list, and all users when adding a friend.
    var usersDataSource: [User] = []
    
    // return a ViewMode initialized with a rawValue from the selected segment index on modeSegmentedControl
    var mode: ViewMode {
        get {
            return ViewMode(rawValue: modeSegmentedControl.selectedSegmentIndex)!
        }
    }
    
    enum ViewMode: Int {
        case Friends = 0
        case All = 1
        
        // USED to fetch the correct set of User objects. We will use this in our updateViewForMode to set the usersDataSource array with either friends, or all users.
        func users(completion: (users: [User]?) -> Void) {
            
            switch self {
                
            case .Friends: UserController.followedByUser(UserController.sharedController.currentUser, completion: { (followed) -> Void in
                
                completion(users: followed)
            })
                
            case .All: UserController.fetchAllUsers() { (users) -> Void in
                completion(users: users)
                }
            }
        }
    }
    
    //MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViewBasedOnMode()
        
    }
    
    // This update method calls the above func closure in the enum in order to set the array of users or if no users exist to give an empty array. Plus, reloads the tableview.
    func updateViewBasedOnMode() {
        mode.users { (users) -> Void in
            if let users = users {
                self.usersDataSource = users
            } else {
                self.usersDataSource = []
            }
            
            self.tableView.reloadData()
        }
    }
    
    @IBAction func updateViewBasedonMode(sender: AnyObject) {
        
        updateViewBasedOnMode()
    }
    
    
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usersDataSource.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("usernameCell", forIndexPath: indexPath)
        
        let user = usersDataSource[indexPath.row]

        cell.textLabel?.text = user.username

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

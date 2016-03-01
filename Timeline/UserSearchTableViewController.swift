//
//  UserSearchTableViewController.swift
//  Timeline
//
//  Created by Parker Donat on 2/23/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class UserSearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    
    //MARK: - Properties
    @IBOutlet weak var modeSegmentedControl: UISegmentedControl!
    var searchController: UISearchController!
    
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
        setUpSearchController()
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
    
    func setUpSearchController() {
        let resultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("UserSearchResultsTableViewController")
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true
    }
    
    //MARK: - UISearchResultsUpdating Protocol
    
    // Captures the text in the search bar and assigning the search controller's usersDataSource to a filtered array of User objects where the username contains the search term, then reload the result view's tableView.
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        // Force unwrap because we expect text
        let searchTerm = searchController.searchBar.text!.lowercaseString
        
        let resultsViewController = searchController.searchResultsController as! UserSearchResultsTableViewController
        
        resultsViewController.usersResultsDataSource = usersDataSource.filter({$0.username.lowercaseString.containsString(searchTerm)})
        resultsViewController.tableView.reloadData()
        
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
    
    
    // MARK: - Navigation
    
    // capturing the indexPath of the cell, capturing the selected user, capturing and casting the destination view controller as a ProfileViewController, and assigning user to the destination view controller's property.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toProfileView" {
            guard let cell = sender as? UITableViewCell else { return }
            
            if let indexPath = tableView.indexPathForCell(cell) {
                
                let user = usersDataSource[indexPath.row]
                
                let destinationViewController = segue.destinationViewController as? ProfileViewController
                destinationViewController?.user = user
                
            } else if let indexPath = (searchController.searchResultsController as? UserSearchResultsTableViewController)?.tableView.indexPathForCell(cell) {
                
                let user = (searchController.searchResultsController as! UserSearchResultsTableViewController).usersResultsDataSource[indexPath.row]
                
                let destinationViewController = segue.destinationViewController as? ProfileViewController
                destinationViewController?.user = user
            }
        }
    }
}

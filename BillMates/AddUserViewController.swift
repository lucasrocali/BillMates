//
//  AddUserViewController.swift
//  BillMates
//
//  Created by Lucas Rocali on 4/26/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class AddUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   

    var model = Model.sharedInstance
    
    @IBOutlet weak var addedUsersTableView: UITableView!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBAction func btnLeaveGroup(sender: UIButton) {
        if model.deleteGroupOfUser() {
            println("deletou!")
            self.logout()
        } else {
            println("You cannot leave the group!")
        }
    }
    
    func logout() {
        println("chama ini view")
        //PFUser.logOut()
        //var initialVC = InitialViewController()
        //initialVC.loginSetup()
        
        var storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        var vc : UITabBarController = storyBoard.instantiateViewControllerWithIdentifier("initialViewController") as! UITabBarController
        
        self.presentViewController(vc, animated: false, completion: nil)
        
    }
    @IBAction func buttonAddUser(sender: UIButton) {
        if !model.isTotallyEmpty(txtName.text) {
            model.joinGroupWhithoutLogin(txtName.text)
            txtName.text = ""
            self.view.endEditing(true)
            self.addedUsersTableView.reloadData()
            txtName.text = ""
        }
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if model.deleteUserOfGroup(indexPath.row) {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
            let managedContext = appDelegate.managedObjectContext!
        
            if editingStyle == UITableViewCellEditingStyle.Delete
            {
            
                //println("delete at \(indexPath.row)")
                //model.deleteUserOfGroup(indexPath.row)
                self.addedUsersTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        } else {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Here's a message"
            alert.addButtonWithTitle("Understod")
            alert.show()
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.groupFriendsString.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addedUsersCell", forIndexPath: indexPath) as! UITableViewCell
        
        var friendName: String = self.model.groupFriendsString[indexPath.row]
        cell.textLabel!.text = friendName

        return cell
    }

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //resignFirstResponder()
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

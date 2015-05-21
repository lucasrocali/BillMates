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
    let alert = UIAlertView()
    
    @IBOutlet weak var addedUsersTableView: UITableView!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBAction func btnLeaveGroup(sender: UIButton) {
        if model.deleteGroupOfUser() {
            println("deletou!")
            self.logout()
        } else {
            let alert = UIAlertView()
            alert.title = "You cannot leave the group"
            alert.message = "Because you share a bill"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }
    
    func logout() {
        println("chama ini view")
        var storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        var vc : UITabBarController = storyBoard.instantiateViewControllerWithIdentifier("initialViewController") as! UITabBarController
        
        self.presentViewController(vc, animated: false, completion: nil)
        
    }
    @IBAction func buttonAddUser(sender: UIButton) {
        if !model.isTotallyEmpty(txtName.text) {
            if model.joinGroupWhithoutLogin(txtName.text) {
                txtName.text = ""
                self.view.endEditing(true)
                self.addedUsersTableView.reloadData()
                txtName.text = ""
            }
            else {
                let alert = UIAlertView()
                alert.title = "You cannot add an user that have an account"
                alert.message = "The user should join the group"
                alert.addButtonWithTitle("Ok")
                alert.show()
            }
        }
    }
    override func viewDidAppear(animated: Bool) {
        self.addedUsersTableView.reloadData()
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if model.connectionStatus! {
            var response : Int = model.deleteUserOfGroup(indexPath.row)
            if response == 0{
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                let managedContext = appDelegate.managedObjectContext!
                
                if editingStyle == UITableViewCellEditingStyle.Delete
                {
                    self.addedUsersTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                }
            } else if response == 1{
                alert.message = "Because the user shares a bill"
                alert.show()
            } else if response  == 2{
                alert.message = "The user should leave the group"
                alert.show()
            }
        } else {
            alert.title = "No internet connection"
            alert.message = "A user cannot be deleted now since another operation can be in progress"
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

        if model.userObject?.username == self.model.groupFriendsString[indexPath.row] {
            cell.userInteractionEnabled = false
        }
        return cell
    }

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        alert.title = "You cannot delete the user"
        alert.addButtonWithTitle("Ok")

    }
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

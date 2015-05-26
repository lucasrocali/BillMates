//
//  GroupViewController.swift
//  BillMates
//
//  Created by Lucas Rocali on 5/12/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class GroupViewController: UIViewController {

    var model = Model.sharedInstance
    
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var txtGroupName: UITextField!
    @IBOutlet weak var txtGroupKey: UITextField!
    let alert = UIAlertView()
    
    @IBOutlet weak var btnJoinGroup: UIButton!
    @IBOutlet weak var btnCreateGroup: UIButton!
    
    @IBAction func btnJoinGroupDown(sender: UIButton) {
    }
    @IBAction func btnCreateGroupDown(sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        alert.title = "You cannot delete the user"
        alert.addButtonWithTitle("Ok")
        
        //Layout
        txtGroupName.font = fontNeutral
        txtGroupName.backgroundColor = colorBaseDarkGray
        
        txtGroupKey.font = fontNeutral
        txtGroupKey.backgroundColor = colorBaseDarkGray
        
        btnJoinGroup.titleLabel!.font = fontButton
        btnJoinGroup.titleLabel!.textColor = colorWhite
        btnJoinGroup.backgroundColor = colorDarkGreen
        
        btnCreateGroup.titleLabel!.font = fontButton
        btnCreateGroup.titleLabel!.textColor = colorWhite
        btnCreateGroup.backgroundColor = colorDarkGreen

    }
    
    @IBAction func btnLogout(sender: UIBarButtonItem) {
        self.logout()
    }
    func logout() {
        if model.isConnectedToNetwork() {
            //println("Log out e chama view")
            PFUser.logOut()
            model.resetModel()
            
            var storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            var vc : UITabBarController = storyBoard.instantiateViewControllerWithIdentifier("initialViewController") as! UITabBarController
            
            self.presentViewController(vc, animated: false, completion: nil)
        } else {
            let alert = UIAlertView()
            alert.title = "No internet connection"
            alert.message = "You cannot log out"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
        
    }
    @IBAction func btnCreateGroup(sender: UIButton) {
        alert.title = "You cannot create the group"
        alert.addButtonWithTitle("Ok")
        //lblError.hidden = true
        if !model.isTotallyEmpty(txtGroupName.text) && !model.isTotallyEmpty(txtGroupKey.text) {
            if self.model.createGroup(txtGroupName.text,groupKey: txtGroupKey.text) {
                //println(" GROUP CREATED")
        
                var storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
                var vc : UITabBarController = storyBoard.instantiateViewControllerWithIdentifier("initialViewController") as! UITabBarController
        
                self.presentViewController(vc, animated: false, completion: nil)
            } else {
                //lblError.hidden = false
                alert.message = "This name has alread been used as group name"
                alert.show()
            }
        } else {
            //lblError.hidden = false
            //lblError.text = "Please fill Group Name and Group Key"
            alert.message = "PPlease fill Group Name and Group Key"
            alert.show()
        }
    }
    
    @IBAction func btnJoinGroup(sender: UIButton) {
        alert.title = "You cannot join the group"
        alert.addButtonWithTitle("Ok")
        //lblError.hidden = true
        if !model.isTotallyEmpty(txtGroupName.text) && !model.isTotallyEmpty(txtGroupKey.text) {
            if self.model.joinGroup(txtGroupName.text,groupKey: txtGroupKey.text) {
                //println(" GROUP JOINED")
            
                var storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
                var vc : UITabBarController = storyBoard.instantiateViewControllerWithIdentifier("initialViewController") as! UITabBarController
            
                self.presentViewController(vc, animated: false, completion: nil)
            } else {
                //lblError.hidden = false
                //lblError.text = "Group Name and Group Key not found"
                alert.message = "Group Name and/or Group Key not found"
                alert.show()
            }
        }
        else {
            //lblError.hidden = false
            //lblError.text = "Please fill Group Name and Group Key"
            alert.message = "Please fill Group Name and Group Key"
            alert.show()
        }

    }
    func DismissKeyboard(){
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

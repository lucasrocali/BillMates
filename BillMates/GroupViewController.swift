//
//  GroupViewController.swift
//  BillMates
//
//  Created by Lucas Rocali on 5/12/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {

    var model = Model.sharedInstance
    
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var txtGroupName: UITextField!
    @IBOutlet weak var txtGroupKey: UITextField!
    @IBAction func btnCreateGroup(sender: UIButton) {
        lblError.hidden = true
        if !model.isTotallyEmpty(txtGroupName.text) && !model.isTotallyEmpty(txtGroupKey.text) {
            if self.model.createGroup(txtGroupName.text,groupKey: txtGroupKey.text) {
                println(" GROUP CREATED")
        
                var storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
                var vc : UITabBarController = storyBoard.instantiateViewControllerWithIdentifier("initialViewController") as! UITabBarController
        
                self.presentViewController(vc, animated: false, completion: nil)
            } else {
                lblError.hidden = false
                lblError.text = "Please, try again with another name"
            }
        } else {
            lblError.hidden = false
            lblError.text = "Please fill Group Name and Group Key"
        }
    }
    @IBAction func btnJoinGroup(sender: UIButton) {
        lblError.hidden = true
        if !model.isTotallyEmpty(txtGroupName.text) && !model.isTotallyEmpty(txtGroupKey.text) {
            if self.model.joinGroup(txtGroupName.text,groupKey: txtGroupKey.text) {
                println(" GROUP JOINED")
            
                var storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
                var vc : UITabBarController = storyBoard.instantiateViewControllerWithIdentifier("initialViewController") as! UITabBarController
            
                self.presentViewController(vc, animated: false, completion: nil)
            } else {
                lblError.hidden = false
                lblError.text = "Group Name and Group Key not found"
            }
        }
        else {
            lblError.hidden = false
            lblError.text = "Please fill Group Name and Group Key"
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

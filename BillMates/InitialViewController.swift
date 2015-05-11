//
//  InitialViewController.swift
//  BillMates
//
//  Created by Lucas Rocali on 5/8/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class InitialViewController: UITabBarController,PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIViewControllerTransitioningDelegate {
    
    var model = Model.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if(PFUser.currentUser() == nil){
            println("Log in")
            var loginViewController = PFLogInViewController()
            
            loginViewController.delegate = self
            
            var signUpViewController = PFSignUpViewController()
            
            signUpViewController.delegate = self
            
            loginViewController.signUpController = signUpViewController
            
            self.presentViewController(loginViewController, animated: true, completion: nil)
            

        } else {
            println("Alread Logged")
            println(PFUser.currentUser()!)
            model.fetchAllObjectsFromLocalDataStore()
            model.fetchAllObjects()
            
            var userGroup = ""
            var query = PFUser.query()
            query!.whereKey("username", equalTo:PFUser.currentUser()!.username!)
            query!.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
                if (error == nil){
                    var temp: NSArray = objects as! NSArray
                    //println(temp)
                    if temp.count > 0 {
                        
                        var txt: NSMutableArray = NSMutableArray()
                        txt = temp.mutableCopy() as! NSMutableArray

                        var user = txt.objectAtIndex(0)
                        if user["group"]! == nil {
                            
                            var storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            
                            var vc : UINavigationController = storyBoard.instantiateViewControllerWithIdentifier("groupViewController") as! UINavigationController
                            
                            self.presentViewController(vc, animated: true, completion: nil)
                            /*
                            var createOrJoinGroup = GroupViewController() as! UIViewController
                            
                            
                            
                            self.presentViewController(createOrJoinGroup, animated: true, completion: nil)*/

                            userGroup = "0"
                         
                        } else {
                            userGroup = user["group"]! as! String
                        }
                        //var aux = user["group"]!
                        //userGroup = aux
                        println(userGroup)
                    }
                    
                } else {
                    println(error?.userInfo)
                }
                
            }/*
            if userGroup == "0" { //No group
                var createOrJoinGroup = CreateOrJoinGroupViewController()
                
                //createOrJoinGroup.delegate = self
                
                
                self.presentViewController(createOrJoinGroup, animated: true, completion: nil)
            }*/
            /*
            var queryBill: PFQuery = PFQuery(className: "User")
            queryBill.fromLocalDatastore()
            
            var user : NSMutableArray = NSMutableArray()

            
            queryBill.whereKey("username", equalTo: PFUser.currentUser()!.username!)

            queryBill.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
                if (error == nil){
                    var temp: NSArray = objects as! NSArray
                    //println(temp)
                    if temp.count > 0 {
                        user = temp.mutableCopy() as! NSMutableArray
                        println("User \(user)")
                    }
                    
                } else {
                    println(error?.userInfo)
                }
                
            }// -*/
           /* var billsListTableViewController = BillsListTableViewController()
            billsListTableViewController.fetchAllObjectsFromLocalDataStore()
            billsListTableViewController.fetchAllObjects()*/
        }
        
                /*
        if(PFUser.currentUser().group == nil){
            println("No group")
            
        } else {
            println("Alread Logged")
        }*/
        
        
    }
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if(!username.isEmpty || !password.isEmpty){
            return true
        }
        else {
            return false
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        println("Fail to Log In..");
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        if let password = info["password"] as? String {
            return count(password.utf16) >= 8
        }else {
            return false
        }
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        println("Fail to Sign Up..")
    }
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        println("User dissmissed to sign up")
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

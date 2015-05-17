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

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //model.resetModel()
        loginSetup()
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
    
    func loginSetup() {
        if(PFUser.currentUser() == nil){
            println("Log in")
            var loginViewController = PFLogInViewController()
            
            loginViewController.delegate = self
            
            var signUpViewController = PFSignUpViewController()
            
            signUpViewController.delegate = self
            
            loginViewController.signUpController = signUpViewController
            
            self.presentViewController(loginViewController, animated: true, completion: nil)
            
            
        } else {
            
            
            var query = PFUser.query()
            query!.whereKey("username", equalTo:PFUser.currentUser()!.username!)
            query!.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
                if (error == nil){
                    var temp: NSArray = objects as! NSArray
                    if temp.count > 0 {
                        
                        var txt: NSMutableArray = NSMutableArray()
                        txt = temp.mutableCopy() as! NSMutableArray
                        
                        var user : PFUser = txt.objectAtIndex(0) as! PFUser
                         var userGroup : String = "x"
                        if user["group"] != nil {
                            userGroup = user["group"] as! String
                            println(userGroup)
                        }
                        if user["group"] == nil || userGroup == "nil"{
                        
                            var storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        
                            var vc : UINavigationController = storyBoard.instantiateViewControllerWithIdentifier("groupViewController") as! UINavigationController
                            
                            self.presentViewController(vc, animated: true, completion: nil)
                                
                            println("Alread Logged")
                            println(PFUser.currentUser()!)
                            //self.model.fetchAllObjectsFromLocalDataStore()
                            //self.model.fetchAllObjects()
                        }
                    
                    } else {
                            println(error?.userInfo)
                        }
                }
            }
        }

    }

}

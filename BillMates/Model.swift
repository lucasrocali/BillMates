//
//  Model.swift
//  BillMates
//
//  Created by Lucas Rocali on 4/26/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import Parse
import ParseUI

class Model {
    
    var bills : [Bill] = [Bill]()
    
    var users : [User] = [User]()
    
    var addedUsers: [String] = [String]()
    
    var friendObjects : NSMutableArray = NSMutableArray()
    
    var billObjects: NSMutableArray = NSMutableArray()
    
    
    func fetchAllObjectsFromLocalDataStore(){
        var queryBill: PFQuery = PFQuery(className: "Bill")
        queryBill.fromLocalDatastore()
        
        
        queryBill.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        
        queryBill.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            if (error == nil){
                var temp: NSArray = objects as! NSArray
                //println(temp)
                 if temp.count > 0 {
                    self.billObjects = temp.mutableCopy() as! NSMutableArray
                    println("Bills \(self.billObjects.count)")
                }
                
            } else {
                println(error?.userInfo)
            }
            
        }// -
        var queryFriend: PFQuery = PFQuery(className: "Friend")
        queryFriend.fromLocalDatastore()
        
        
        queryFriend.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        
        queryFriend.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            if (error == nil){
                var temp: NSArray = objects as! NSArray
                //println(temp)
                if temp.count > 0 {
                    self.friendObjects = temp.mutableCopy() as! NSMutableArray
                    println("Friends \(self.friendObjects.count)")
                }
                
            } else {
                println(error?.userInfo)
            }
            
        }
    }
    
    func fetchAllObjects(){
        PFObject.unpinAllObjectsInBackgroundWithBlock(nil)
        
        var queryBill: PFQuery = PFQuery(className: "Bill")
        queryBill.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        
        queryBill.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            if (error == nil){
                PFObject.pinAllInBackground(objects,block:nil)
                self.fetchAllObjectsFromLocalDataStore()
            } else {
                println(error?.userInfo)
            }
            
        }
        
        var queryFriend: PFQuery = PFQuery(className: "Friend")
        queryFriend.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        
        queryFriend.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            if (error == nil){
                PFObject.pinAllInBackground(objects,block:nil)
                self.fetchAllObjectsFromLocalDataStore()
            } else {
                println(error?.userInfo)
            }
            
        }

        
    }
    //Singleton
    private struct Static {
        static var instance: Model?
    }
    
    
    
    private init(){}
    
    class var sharedInstance: Model {
        if (Static.instance == nil) {
            Static.instance = Model()
        }
        return Static.instance!
    }
    
    func getBill(index: Int) -> PFObject {
        return self.billObjects.objectAtIndex(index) as! PFObject
    }
    
    func deleteBill(index: Int) {
        println("Delete at \(index)")
        //println(billObjects)
        
        var bill = billObjects.objectAtIndex(index) as! PFObject
        
        
        
        var query = PFQuery(className:"Bill")
        query.getObjectInBackgroundWithId(bill.objectId!) {
            (bill: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else {
                bill?.deleteInBackground()
            }}
        
        self.billObjects.removeObjectAtIndex(index)
        //var object = billObjects.objectAtIndex(index) as! PFObject
        //self.billObjects.
        //println(billObjects)
        
        /*
        let bill = bills[index]
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        managedContext.deleteObject(bill)
        
        bills.removeAtIndex(index)
        
        var error: NSError?
        if !managedContext.save(&error) {
            abort()
        }*/
    }
    
    func getBills() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Bill")
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as! [Bill]?
        
        if let results = fetchedResults {
            bills = results
        }
        else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    func saveBill(#description:String, value:String) {
        var object : PFObject!
        
        object = PFObject(className: "Bill")
        
        object["username"] = PFUser.currentUser()?.username
        
        object["description"] = description
        object["value"] = NSString(string: value).floatValue
        
        object["paidBy"] = PFUser.currentUser()?.username
        
        object["sharedWith"] = addedUsers
        
        
        
        object.saveEventually { (success,error) -> Void in
            if (error == nil){
                println("Salvou!")
            }
            else {
                println("Nao mandou..")
            }
        }
        
        addedUsers.removeAll(keepCapacity: false)

        /*
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("Bill", inManagedObjectContext: managedContext)
        
        //let managedContextUser = appDelegate.managedObjectContext!
        //let entityUser = NSEntityDescription.entityForName("User", inManagedObjectContext: managedContextUser)
        
        let bill = Bill(entity: entity!, insertIntoManagedObjectContext: managedContext)
        let billOwnerName = addedUsers[0]
        
        bill.attDescription = description
        bill.attValue = value
        bill.billOwner = getObjUser(billOwnerName)
        
        for i in 1..<addedUsers.count {
            let billOwnerName = addedUsers[i]
            bill.addBillUser(getObjUser(billOwnerName))
        }
        self.bills.append(bill)
//        println(bill.billOwner.attName)
        //println("Owner of \(bill.getDescrition()) is \(bill.getBillOwner().attName)")
        //for user in addedUsers {
            //println(user)
        //}
        addedUsers.removeAll(keepCapacity: false)
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not fetch \(error), \(error!.userInfo)")
        }*/
    }
    func getUser(index: Int) -> User {
        return users[index]
    }


    func saveUser(#name:String) {
        var object : PFObject!
        
        object = PFObject(className: "Friend")
        
        object["username"] = PFUser.currentUser()?.username
        
        object["friendName"] = name
        
        object.saveEventually { (success,error) -> Void in
            if (error == nil){
                println("Salvou!")
            }
            else {
                println("Nao mandou..")
            }
        }
        /*
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedContext)
        
        let user = User(entity: entity!, insertIntoManagedObjectContext: managedContext)
        user.attName = name
        self.users.append(user)
        
        
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not fetch \(error), \(error!.userInfo)")
        }*/
    }

    func getUsers() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as! [User]?
        
        if let results = fetchedResults {
            users = results
        }
        else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    func deleteUser(index:Int) {
        println("Delete at \(index)")
        //println(billObjects)
        
        var user = friendObjects.objectAtIndex(index) as! PFObject
        
        
        
        var query = PFQuery(className:"Friend")
        query.getObjectInBackgroundWithId(user.objectId!) {
            (bill: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else {
                bill?.deleteInBackground()
            }}
        
        self.friendObjects.removeObjectAtIndex(index)
        /*
        var index = -1
        for i in 0..<users.count {
            if (users[i].attName == name) {
                index = i
            }
        }
        
        if index >= 0{
            let user  = users[index]
        
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
                let managedContext = appDelegate.managedObjectContext!
                managedContext.deleteObject(user)
        
                users.removeAtIndex(index)
        
                var error: NSError?
            if !managedContext.save(&error) {
                abort()
            }
        }
        else {
            println("Name not found")
        }*/
    }
    func addAddedUsers(name: String){
        self.addedUsers.append(name)
    }
    
    func removeAddedUsers(name:String){
        var index = -1
        for i in 0..<addedUsers.count {
            if (addedUsers[i] == name) {
                index = i
            }
        }
        if index >= 0{
            addedUsers.removeAtIndex(index)
        }
    }
    
    func isAddedUser(name:String) -> Bool {
        var index = -1
        for i in 0..<addedUsers.count {
            if (addedUsers[i] == name) {
                index = i
            }
        }
        if index >= 0{
            return true
        }
        return false
    }
    
    func isTotallyEmpty(text:String) -> Bool {
        let trimmed = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        return trimmed.isEmpty
    }
    
    func getObjUser (name:String) -> User {
        var index = 0
        for i in 0..<users.count {
            //println("\(users[i].attName) - \(name)")
            if (users[i].attName == name) {
                //println("Foi")
                index = i
            }
        }
        //println(index)
        return users[index]
        
    }
}

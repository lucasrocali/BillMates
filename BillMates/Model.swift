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
    
    var friendString : [String] = [String]()
    
    var billObjects: NSMutableArray = NSMutableArray()
    
    var userObject: NSMutableArray = NSMutableArray()
    
    
    func fetchAllObjectsFromLocalDataStore(){
        
        var query = PFUser.query()
        var user = query!.getObjectWithId(PFUser.currentUser()!.objectId!) as! PFUser
        
        var queryBill: PFQuery = PFQuery(className: "Bill")
        queryBill.fromLocalDatastore()
        
        queryBill.whereKey("groupName", equalTo: user["group"]!)
        
        queryBill.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            if (error == nil){
                var temp: NSArray = objects as! NSArray
                //println(temp)
                 if temp.count > 0 {
                    self.billObjects = temp.mutableCopy() as! NSMutableArray
                    println("\t\t\tBills \(self.billObjects.count)")
                }
                
            } else {
                println(error?.userInfo)
            }
            
        }
        
        var queryFriend: PFQuery = PFQuery(className: "Group")
        queryFriend.fromLocalDatastore()
        
        
        queryFriend.whereKey("groupName", equalTo: user["group"]!)
        
        queryFriend.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            if (error == nil){
                var temp: NSArray = objects as! NSArray
                //println(temp)
                if temp.count > 0 {
                    var aux : NSMutableArray = temp.mutableCopy() as! NSMutableArray
                    var group : PFObject = aux.objectAtIndex(0) as! PFObject
                    self.friendString = group["groupFriends"] as! [String]
                    println("Friends \(self.friendString)")
                }
                
            } else {
                println(error?.userInfo)
            }
            
        }
    }
    
    func fetchAllObjects(){
        PFObject.unpinAllObjectsInBackgroundWithBlock(nil)
        
        var query = PFUser.query()
        var user = query!.getObjectWithId(PFUser.currentUser()!.objectId!) as! PFUser
        
        var queryBill: PFQuery = PFQuery(className: "Bill")
        queryBill.whereKey("groupName", equalTo: user["group"]!)
        
        queryBill.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            if (error == nil){
                PFObject.pinAllInBackground(objects,block:nil)
                self.fetchAllObjectsFromLocalDataStore()
            } else {
                println(error?.userInfo)
            }
            
        }
        
        var queryFriend: PFQuery = PFQuery(className: "Group")
        queryFriend.whereKey("groupName", equalTo: user["group"]!)
        
        queryFriend.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            if (error == nil){
                PFObject.pinAllInBackground(objects,block:nil)
                self.fetchAllObjectsFromLocalDataStore()
            } else {
                println(error?.userInfo)
            }
            
        }
        
        
    }
    func createGroup(groupName:String,groupKey:String) -> Bool{
        
        var queryGroup: PFQuery = PFQuery(className: "Group")
        
        queryGroup.whereKey("groupName", equalTo: groupName)
        
        var temp: NSArray = queryGroup.findObjects() as! NSArray
        println(temp)
        if temp.count > 0 {
            return false
        }
        
        var object : PFObject!
        
        object = PFObject(className: "Group")
        
        object["whoCreate"] = PFUser.currentUser()!.username!
        
        object["groupName"] = groupName
        object["groupKey"] = groupKey
        
        var groupFriends : [String] = []
        groupFriends.append(PFUser.currentUser()!.username!)
        
        object["groupFriends"] = groupFriends
        
        
        
        var query = PFUser.query()
        var user = query!.getObjectWithId(PFUser.currentUser()!.objectId!) as! PFUser
        
        user["group"] = groupName
        
        if object.save() && user.save() {
            return true
        } else {
            return false
        }
    }
    
    func joinGroup(groupName:String,groupKey:String) -> Bool{
        
        var queryGroup: PFQuery = PFQuery(className: "Group")
        
        queryGroup.whereKey("groupName", equalTo: groupName)
        
        var temp: NSArray = queryGroup.findObjects() as! NSArray
        
        println(temp)
        var group : NSMutableArray = temp.mutableCopy() as! NSMutableArray
        
        if group.count > 0 {
            println(group.objectAtIndex(0))
            var g : PFObject = group.objectAtIndex(0) as! PFObject
            
            var key : String = g["groupKey"] as! String
            
            if key != groupKey {
                return false
            }
            
            var groupFriends : [String] = g["groupFriends"] as! [String]
            
            groupFriends.append(PFUser.currentUser()!.username!)
            
            g["groupFriends"] = groupFriends
            
            
            var query = PFUser.query()
            var user = query!.getObjectWithId(PFUser.currentUser()!.objectId!) as! PFUser
            
            user["group"] = groupName
            
            if g.save() && user.save(){
                return true
            } else {
                return false
            }
            

        }
        else {
           return false 
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
    }
    
    func saveBill(#description:String, value:String) {
        var object : PFObject!
        
        object = PFObject(className: "Bill")
        
        object["username"] = PFUser.currentUser()?.username
        
        object["description"] = description
        object["value"] = NSString(string: value).floatValue
        
        object["paidBy"] = PFUser.currentUser()?.username
        
        object["sharedWith"] = addedUsers
        
        var query = PFUser.query()
        var user = query!.getObjectWithId(PFUser.currentUser()!.objectId!) as! PFUser
        
        object["groupName"] =  user["group"]!
        
        
        object.saveEventually { (success,error) -> Void in
            if (error == nil){
                println("Salvou!")
            }
            else {
                println("Nao mandou..")
            }
        }
        
        
        
        addedUsers.removeAll(keepCapacity: false)
        
        
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
   
}

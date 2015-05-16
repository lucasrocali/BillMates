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
    
    var addedUsers: [String] = [String]()
    
    var billObjects: NSMutableArray = NSMutableArray()
    
    var userObject: PFUser?
    
    var groupObject : PFObject?
    
    var groupFriendsString : [String] = [String]()
    
    var debtObjects : NSMutableArray = NSMutableArray()
    
    func refreshData() {
        if(PFUser.currentUser() != nil){
            var query = PFUser.query()
            
            var user = query!.getObjectWithId(PFUser.currentUser()!.objectId!) as! PFUser
            if (PFUser.currentUser() != nil && user["group"] != nil){
                self.fetchAllObjects()
                self.fetchAllObjectsFromLocalDataStore()
            }
        }
    }
    
    func fetchAllObjectsFromLocalDataStore(){
        
        var query = PFUser.query()
        var user = query!.getObjectWithId(PFUser.currentUser()!.objectId!) as! PFUser
        self.userObject = user
        
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
                    //var vc = BillsListTableViewController()
                    //vc.tableView.reloadData()
                }
                
            } else {
                println(error?.userInfo)
            }
        }
        var queryGroup: PFQuery = PFQuery(className: "Group")
        queryGroup.fromLocalDatastore()
        queryGroup.whereKey("groupName", equalTo: user["group"]!)
        queryGroup.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            if (error == nil){
                var temp: NSArray = objects as! NSArray
                //println(temp)
                if temp.count > 0 {
                    var aux : NSMutableArray = temp.mutableCopy() as! NSMutableArray
                    self.groupObject = aux.objectAtIndex(0) as! PFObject
                    self.groupFriendsString = self.groupObject!["groupFriends"] as! [String]
                    println("Friends \(self.groupFriendsString)")
                }
                
            } else {
                println(error?.userInfo)
            }
            
        }
        var queryDebt : PFQuery = PFQuery(className: "Debts")
        queryDebt.fromLocalDatastore()
        queryDebt.whereKey("groupName", equalTo: user["group"]!)
        queryDebt.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            if (error == nil){
                var temp: NSArray = objects as! NSArray
                self.debtObjects  = temp.mutableCopy() as! NSMutableArray
            } else {
                println(error?.userInfo)
            }
        }
        
    }
    
    func fetchAllObjects(){
        PFObject.unpinAllObjectsInBackgroundWithBlock(nil)
        
        var query = PFUser.query()
        var user = query!.getObjectWithId(PFUser.currentUser()!.objectId!) as! PFUser
        self.userObject = user
        
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
        
        var queryDebt : PFQuery = PFQuery(className: "Debts")
        queryDebt.whereKey("groupName", equalTo: user["group"]!)
        
        queryDebt.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            if (error == nil){
                PFObject.pinAllInBackground(objects,block:nil)
                self.fetchAllObjectsFromLocalDataStore()
                if self.billObjects.count > 0 {
                    self.calculateDebts()
                }
                
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
    
    func joinGroupWhithoutLogin(name:String) -> Bool{
        /*var query = PFUser.query()
        var user = query!.getObjectWithId(PFUser.currentUser()!.objectId!) as! PFUser
        
        var queryGroup: PFQuery = PFQuery(className: "Group")
        
        queryGroup.whereKey("groupName", equalTo: user["group"]!)
        
        var temp: NSArray = queryGroup.findObjects() as! NSArray
        
        var group : NSMutableArray = temp.mutableCopy() as! NSMutableArray

        var g : PFObject = group.objectAtIndex(0) as! PFObject*/
        
       
            
        self.groupFriendsString.append(name)
            
        groupObject!["groupFriends"] = self.groupFriendsString
        if groupObject!.save(){
            refreshData()
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
    func deleteUserOfGroup(index: Int) {
        println("----------Delete at \(index)")
        //println(billObjects)
        println(self.groupFriendsString)
        println(self.groupObject!)
        
        self.groupFriendsString.removeAtIndex(index)
        
        self.groupObject!["groupFriends"] = self.groupFriendsString
        
        self.groupObject!.save()
        
        
        /*
        var bill = billObjects.objectAtIndex(index) as! PFObject
        
        
        
        var query = PFQuery(className:"Bill")
        query.getObjectInBackgroundWithId(bill.objectId!) {
            (bill: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else {
                bill?.deleteInBackground()
            }}
        
        //self.billObjects.removeObjectAtIndex(index)*/
    }
    
    func saveBill(#description:String, value:String) {
        var object : PFObject!
        
        object = PFObject(className: "Bill")
        
        object["whoCreated"] = self.userObject!["username"] as! String
        
        object["description"] = description
        object["value"] = NSString(string: value).floatValue
        
        object["paidBy"] = PFUser.currentUser()?.username
        
        object["sharedWith"] = addedUsers
        
        var query = PFUser.query()
        var user = query!.getObjectWithId(PFUser.currentUser()!.objectId!) as! PFUser
        
        object["groupName"] =  user["group"]!
        
        self.billObjects.addObject(object)
        
        object.saveEventually { (success,error) -> Void in
            if (error == nil){
                println("Salvou!")
                self.calculateDebts()
            }
            else {
                println("Nao mandou..")
            }
        }
        //addedUsers.removeAll(keepCapacity: false)
    }
    func editBill(#description:String, value:String, billId: String) {
        
        println(description)
        println(value)
        println(billId)
        var queryBill: PFQuery = PFQuery(className: "Bill")
        queryBill.getObjectInBackgroundWithId(billId) {
            (billToEdit: PFObject?, error: NSError?) -> Void in
            if error == nil && billToEdit != nil {
                println(billToEdit)
                billToEdit!["whoCreated"] = self.userObject!["username"] as! String
                
                billToEdit!["description"] = description
                billToEdit!["value"] = NSString(string: value).floatValue
                
                billToEdit!["sharedWith"] = self.addedUsers
                billToEdit!.saveEventually()
                
                
                self.addedUsers.removeAll(keepCapacity: false)
            } else {
                println(error)
            }
        }
        
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
    
    func getNumOfDebts(n:Int) -> Int{
        var numOfDebts = 0
        for i in 1..<n{
            numOfDebts = numOfDebts + i
        }
        //println("pra \(n) eh \(numOfDebts)")
        return numOfDebts
    }
    
    func createDebtRelations(groupFriends: [String],groupName:String) {
        
        var queryDebts: PFQuery = PFQuery(className: "Debts")
        
        queryDebts.whereKey("groupName", equalTo: groupName)
        
        queryDebts.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            if (error == nil){
                    var temp: NSArray = objects as! NSArray
                var debtsToDelete : NSMutableArray = temp.mutableCopy() as! NSMutableArray
                for debtToDelte in debtsToDelete {
                    println("delete IHAAAA")
                    var group : PFObject = debtToDelte as! PFObject
                    group.deleteInBackground()
                }
            } else {
                println(error?.userInfo)
            }
        }
        

        /*var queryDebts: PFQuery = PFQuery(className: "Debts")
        
        queryDebts.whereKey("groupName", equalTo: groupName)

        var tempDebts: NSArray = queryDebts.findObjects() as! NSArray*/
        //println(groupName)
        for i in 1..<groupFriends.count {
                for j in (i+1)...groupFriends.count {
                    println("Relation between \(i) and \(j)")
                    var object : PFObject!
                    object = PFObject(className: "Debts")
                    
                    var groupNameStr : String = String(i) + String(j)
                    object["debtId"] = groupNameStr
                    object["user1"] = groupFriends[i-1]
                    object["user2"] = groupFriends[j-1]
                    object["value"] = 0
                    object["groupName"] = groupName
                    object.save()
            }
        }
        
    }
    
    func getDebtId(paidBy:String,sharedUser:String,groupFriends:[String]) -> (debtId: String, direction: Int){
        // 1 = user 2 should pay to user 1
        // -1 = user 1 should pay to user 2
        var direction : Int = 0
        var indexUser1 : Int = -1
        var indexUser2 : Int = -1
        for i in 0..<groupFriends.count {
            if groupFriends[i] == paidBy {
                indexUser1 = i
            }
            if groupFriends[i] == sharedUser {
                indexUser2 = i
            }
        }
        var debtId : String = ""
        if indexUser1 < indexUser2 {
            debtId = String(indexUser1+1) + String(indexUser2+1)
            direction = 1
        } else {
            debtId = String(indexUser2+1) + String(indexUser1+1)
            direction = -1
        }
        return (debtId,direction)
    }
    
    func refreshDebts(groupFriends: [String],groupName: String) {
        self.debtObjects.removeAllObjects()
        var localDebtStorage = Dictionary<String, Float>()
        for i in 1..<groupFriends.count {
            for j in (i+1)...groupFriends.count {
                var dbtID : String = String(i) + String(j)
                localDebtStorage[dbtID] = 0.0 as Float
            }
        }
        //println(localDebtStorage)
        for billObject in self.billObjects {  //----
            //println(billObject)
            
            
            var bill : PFObject = billObject as! PFObject
            
            var paidBy : String = bill["paidBy"] as! String
            var sharedWith : [String] = bill["sharedWith"] as! [String]
            var value : Float = bill["value"] as! Float
            println(paidBy + sharedWith[0])
            for sharedUser in sharedWith {
                if sharedUser != paidBy {
                    var (dbId,direction) = getDebtId(paidBy, sharedUser: sharedUser, groupFriends: groupFriends)
                    
                    localDebtStorage[dbId] = localDebtStorage[dbId]! + value*Float(direction)/Float(sharedWith.count)
                }
            }
        }
        for localDebt in localDebtStorage {
            var queryDebts: PFQuery = PFQuery(className: "Debts")
            
            queryDebts.whereKey("groupName", equalTo: groupName)
            queryDebts.whereKey("debtId", equalTo: localDebt.0)
            
           // var temp: NSArray = queryDebts.findObjects() as! NSArray
            queryDebts.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
                if (error == nil){
                    var temp: NSArray = objects as! NSArray
                    var debToUpdate : PFObject = temp.objectAtIndex(0) as! PFObject
                    debToUpdate["value"] = localDebt.1
                    debToUpdate.saveEventually()
                    self.debtObjects.addObject(debToUpdate)
                    println("Group: \(groupName) billCode \(localDebt.0) value: \(localDebt.1)")
                    
                } else {
                    println(error?.userInfo)
                }
            }
        }
    }
    
    
    func calculateDebts() {
        var queryGroup: PFQuery = PFQuery(className: "Group")
        var query = PFUser.query()
        var user = query!.getObjectWithId(PFUser.currentUser()!.objectId!) as! PFUser
        var userGroupName : String = user["group"]! as! String
        queryGroup.whereKey("groupName", equalTo: userGroupName)
        
        var temp: NSArray = queryGroup.findObjects() as! NSArray
        var group : PFObject = temp.objectAtIndex(0) as! PFObject

        var groupFriends : [String] = group["groupFriends"] as! [String]
        var n = 5
        var num = 0
        for i in 1..<n {
            num = num + 1
        }
        println(self.debtObjects.count)
        if self.debtObjects.count != getNumOfDebts(groupFriends.count) {
            println("CREATE RELATIONS")
            //groupFriends.append("a")
            createDebtRelations(groupFriends,groupName:userGroupName)
        }
        println("GET RELATIONS")
        refreshDebts(groupFriends,groupName:userGroupName)

        
    }
   
}

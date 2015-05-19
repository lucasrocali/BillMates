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
    
    var filteredBills: NSMutableArray = NSMutableArray()
    
    var userObject: PFUser?
    
    var groupObject : PFObject?
    
    var groupFriendsString : [String] = [String]()
    
    var debtObjects : NSMutableArray = NSMutableArray()
    
    var debtStringCell : [String] = [String]()
    
    var relations : [Relation] = [Relation]()
    
    var imageToSave : UIImage?

    
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
                    println("\tbillObjects saved \(self.billObjects.count)")
                }
                
            } else {
                //println(error?.userInfo)
                println("ERROR NO FECTH FROM LOCAL - BILL")
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
                    println("\tgroupFRiensdsString saved \(self.groupFriendsString)")
                }
                
            } else {
                //println(error?.userInfo)
                println("ERROR NO FECTH FROM LOCAL - GROUP")
            }
            
        }
        var queryDebt : PFQuery = PFQuery(className: "Debts")
        queryDebt.fromLocalDatastore()
        queryDebt.whereKey("groupName", equalTo: user["group"]!)
        queryDebt.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            if (error == nil){
                println("THREAD PRA PEGAR OS DEBTS!!!!!")
                var temp: NSArray = objects as! NSArray
                self.debtObjects  = temp.mutableCopy() as! NSMutableArray
                println("\tdebtObjects saved \(self.debtObjects)")
                 if self.debtObjects.count > 0 {
                    println("CHAMOU FUDEU")
                    if self.groupObject != nil {
                        var groupFriends : [String] = self.groupObject!["groupFriends"] as! [String]
                        if self.debtObjects.count != self.getNumOfDebts(groupFriends.count) {
                            self.calculateDebts(true)
                        } else {
                            self.calculateDebts(true)
                        }
                    }
                }
            } else {
                //println(error?.userInfo)
                println("ERROR NO FECTH FROM LOCAL - DEBTS")
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
                println("ERROR NO FECTH - BILL")
            }
            
        }
        
        var queryFriend: PFQuery = PFQuery(className: "Group")
        queryFriend.whereKey("groupName", equalTo: user["group"]!)
        
        queryFriend.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            if (error == nil){
                PFObject.pinAllInBackground(objects,block:nil)
                self.fetchAllObjectsFromLocalDataStore()
            } else {
                println("ERROR NO FECTH - GROUP")
            }
            
        }
        
        var queryDebt : PFQuery = PFQuery(className: "Debts")
        queryDebt.whereKey("groupName", equalTo: user["group"]!)
        
        queryDebt.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            if (error == nil){
                PFObject.pinAllInBackground(objects,block:nil)
                self.fetchAllObjectsFromLocalDataStore()
            } else {
                println("ERROR NO FECTH - DEBTS")
            }
            
        }
        
        
    }
    func createGroup(groupName:String,groupKey:String) -> Bool{
        
        
        var queryGroup: PFQuery = PFQuery(className: "Group")
        
        queryGroup.whereKey("groupName", equalTo: groupName)
        
        var temp: NSArray = queryGroup.findObjects() as! NSArray
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
            self.groupObject = object
            println("\tgroup created \(self.groupObject)")
            return true
        } else {
            return false
        }
    }
    
    func joinGroupWhithoutLogin(name:String) -> Bool{
        var query = PFUser.query()
        
        query!.whereKey("username", equalTo: name)
        
        var temp : NSArray = query!.findObjects() as! NSArray
        
        if temp.count > 0 {
            return false
        }
        self.groupFriendsString.append(name)
            
        groupObject!["groupFriends"] = self.groupFriendsString
        if groupObject!.save(){
            refreshData()
            self.calculateDebts(true)
            println("group joined without user\(self.groupObject)")
            return true
        } else {
            println("problme to save")
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
                self.groupObject = g
                println("group joined \(self.groupObject)")
                return true
            } else {
                return false
            }
        }
        else {
           return false 
        }
    }
    func resetModel() {
        Static.instance = nil
        //self.billObjects = []
    }
    //Singleton
    private struct Static {
        static var instance: Model?
    }
    class var sharedInstance: Model {
        if (Static.instance == nil) {
            Static.instance = Model()
        }
        return Static.instance!
    }
    
    func deleteBill(index: Int) {
        println("Delete bill at \(index)")
        
        var bill = billObjects.objectAtIndex(index) as! PFObject
        
        var query = PFQuery(className:"Bill")
        query.getObjectInBackgroundWithId(bill.objectId!) {
            (bill: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println("ERRO PRA DELETAR")
            } else {
                bill?.delete()
                //self.billObjects.removeObjectAtIndex(index)
                self.calculateDebts(true)
            }
            
        }
        self.billObjects.removeObjectAtIndex(index)
    }
    
    func canDelete(username:String) -> Bool {
        for debt in self.debtObjects {
            var checkDebt : PFObject = debt as! PFObject
            var user1 : String = checkDebt["user1"] as! String
            var user2 : String = checkDebt["user2"] as! String
            var value : Float = checkDebt["value"] as! Float
            if (user1 == username || user2 == username) && value != 0 {
                println("esse cara deve!!")
                return false
            }
        }
        return true
    }
    
    func deleteGroupOfUser() -> Bool{
        var user : PFUser = self.userObject!
        var username : String = user["username"] as! String
        if canDelete(username) {
            user["group"] = "nil"
            user.save()
            self.resetModel()
            //billObjects = []
            return true
        } else {
            return false
        }
        
    }
    func deleteUserOfGroup(index: Int) -> Int{
        println(self.debtObjects)
        
        println(self.groupFriendsString)
        var userToDelete : String = self.groupFriendsString[index]
        
        for debt in self.debtObjects {
            var checkDebt : PFObject = debt as! PFObject
            var user1 : String = checkDebt["user1"] as! String
            var user2 : String = checkDebt["user2"] as! String
            var value : Float = checkDebt["value"] as! Float
            if (user1 == userToDelete || user2 == userToDelete) && value != 0 {
                println("esse cara deve!!")
                return 1
            }
        }
        var query = PFUser.query()
        
        query!.whereKey("username", equalTo: userToDelete)
        
        var temp : NSArray = query!.findObjects() as! NSArray
       
        if temp.count > 0 {
            return 2
        }
 
        println("Delete user at \(index)")
    
        self.groupFriendsString.removeAtIndex(index)
        
        self.groupObject!["groupFriends"] = self.groupFriendsString
        
        self.groupObject!.save()
        self.calculateDebts(true)
        
        return 0
    }
    
    func saveBill(#description:String, value:String) {
        var object : PFObject!
        
        object = PFObject(className: "Bill")
        
        object["whoCreated"] = self.userObject!["username"] as! String
        
        object["description"] = description
        object["value"] = NSString(string: value).floatValue
        
        object["paidBy"] = PFUser.currentUser()?.username
        
        object["sharedWith"] = addedUsers
        
        
        //let scaledImage = scaleImageWith(pickedImage)
        //var defautImg : UIImage = UIImage(named: "0")!
        
        var query = PFUser.query()
        var user = query!.getObjectWithId(PFUser.currentUser()!.objectId!) as! PFUser
        
        object["groupName"] =  user["group"]!
        
        
        if self.imageToSave != nil {
            println("tem imagem pra salvar")
            var image : UIImage = self.imageToSave!
            var imageData = UIImagePNGRepresentation(image)
            var imageFile = PFFile(data:imageData)
            object["img"] = imageFile
        }
        object.saveInBackgroundWithBlock({
            (success:Bool,error:NSError?) -> Void in
            if (error == nil){
                println("Salvou!")
                self.calculateDebts(true)
            }
            else {
                println("NAO SALVOU BILL")
            }
        })
        self.billObjects.addObject(object)
        //addedUsers.removeAll(keepCapacity: false)
    }
    func editBill(#description:String, value:String, billId: String,cellId:Int) {
        var queryBill: PFQuery = PFQuery(className: "Bill")
        queryBill.getObjectInBackgroundWithId(billId) {
            (billToEdit: PFObject?, error: NSError?) -> Void in
            if error == nil && billToEdit != nil {
                println(billToEdit)
                billToEdit!["whoCreated"] = self.userObject!["username"] as! String
                
                billToEdit!["description"] = description
                billToEdit!["value"] = NSString(string: value).floatValue
                
                billToEdit!["sharedWith"] = self.addedUsers
                self.billObjects.removeObjectAtIndex(cellId)
                self.billObjects.insertObject(billToEdit!, atIndex: cellId)
                
                //self.billObjects.addObject(billToEdit!)
                self.calculateDebts(true)
                billToEdit!.saveEventually()  { (success,error) -> Void in
                    if (error == nil){
                        println("EDITOU")
                        
                    }
                    else {
                        println("NAO EDITOU")
                    }
                }

                
                self.addedUsers.removeAll(keepCapacity: false)
            } else {
                println("NAO ACHOU BILL PRA EDITAR")
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
        
        for debt in self.debtObjects {
            var debtToDelete : PFObject = debt as! PFObject
            debtToDelete.delete()
            
        }
        self.debtObjects.removeAllObjects()
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
                     self.debtObjects.addObject(object)
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
    
    func refreshDebts(groupFriends: [String],groupName: String,backGround:Bool) {
        self.debtObjects.removeAllObjects()
        var localDebtStorage = Dictionary<String, Float>()
        for i in 1..<groupFriends.count {
            for j in (i+1)...groupFriends.count {
                var dbtID : String = String(i) + String(j)
                //println("-----> \(dbtID)")
                localDebtStorage[dbtID] = 0.0 as Float
            }
        }
        for billObject in self.billObjects {  //----
            var bill : PFObject = billObject as! PFObject
            
            var paidBy : String = bill["paidBy"] as! String
            var sharedWith : [String] = bill["sharedWith"] as! [String]
            var value : Float = bill["value"] as! Float
            //println(paidBy + sharedWith[0])
            for sharedUser in sharedWith {
                if sharedUser != paidBy {
                    var (dbId,direction) = getDebtId(paidBy, sharedUser: sharedUser, groupFriends: groupFriends)
                    localDebtStorage[dbId] = localDebtStorage[dbId]! + value*Float(direction)/Float(sharedWith.count)
                }
            }
        }
        
        if backGround {
            for localDebt in localDebtStorage {
                var queryDebts: PFQuery = PFQuery(className: "Debts")
                
                queryDebts.whereKey("groupName", equalTo: groupName)
                queryDebts.whereKey("debtId", equalTo: localDebt.0)
                
                queryDebts.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
                    if (error == nil){
                        var temp: NSArray = objects as! NSArray
                        var debToUpdate : PFObject = temp.objectAtIndex(0) as! PFObject
                        self.debtObjects.addObject(debToUpdate)
                        debToUpdate["value"] = localDebt.1
                        debToUpdate.saveEventually()
                        //self.generateDebtStrings()
                        println("Group: \(groupName) billCode \(localDebt.0) value: \(localDebt.1)")

                    } else {
                        println("FUDEU NO REFRESH EM BACKGROUND")
                    }
                }
            }
        } else {
            for localDebt in localDebtStorage {
                var queryDebts: PFQuery = PFQuery(className: "Debts")
            
                queryDebts.whereKey("groupName", equalTo: groupName)
                queryDebts.whereKey("debtId", equalTo: localDebt.0)
                println(groupName+localDebt.0)
                var temp: NSArray = queryDebts.findObjects() as! NSArray

                if temp.count > 0 {
                    var debToUpdate : PFObject = temp.objectAtIndex(0) as! PFObject
                    debToUpdate["value"] = localDebt.1
                    self.debtObjects.addObject(debToUpdate)
                    debToUpdate.save()
                    println("Group: \(groupName) billCode \(localDebt.0) value: \(localDebt.1)")
                }
        
            }
            self.generateDebtStrings()
        }
    }
    
    func filterBillsByRelation(user1:String,user2:String){
        self.filteredBills.removeAllObjects()
        println("FILTER FOR \(user1) AND \(user2)")
        var bills = self.billObjects
        for bill in bills {
            var paidBy: String = bill["paidBy"] as! String
            var sharedWith: [String] = bill["sharedWith"] as! [String]
            if user1 == paidBy {
                for sharedUser in sharedWith {
                    if user2 == sharedUser {
                        filteredBills.addObject(bill)
                    }
                }
            }
            if user2 == paidBy {
                for sharedUser in sharedWith {
                    if user1 == sharedUser {
                        filteredBills.addObject(bill)
                    }
                }
            }
        }
        println(filteredBills)
    }
    
    func generateDebtStrings() {
        println("GENERATE")
        self.relations = []
        var debts = self.debtObjects
        
        var debtStr : String = ""
        for debt in debts {
            var user1 : String = debt["user1"] as! String
            var user2 : String = debt["user2"] as! String
            var value : Float = debt["value"] as! Float
            if value < 0 {
                debtStr = user1 + " --> " + user2 + " = " +  String(format: "%.2f",value*(-1))
            } else if value > 0{
                debtStr = user1 + " <-- " + user2 + " = " +  String(format: "%.2f",value)
            } else {
                debtStr =  user1 + " -- " + user2 + " = " +  String(format: "%.2f",value)
            }
            var relation : Relation = Relation()
            relation.debtStringCell = debtStr
            relation.user1 = user1
            relation.user2 = user2
            relation.value = value
            self.relations.append(relation)
        }
    }
    /*
    func getDebtStringCell(index:Int) -> String {
        return self.relations[index].debtStringCell
    }*/
    
    func calculateDebts(background:Bool) {
        if self.groupObject != nil{
        var userGroupName : String = self.groupObject!["groupName"] as! String
        var groupFriends : [String] = self.groupObject!["groupFriends"] as! [String]
        println("DDEBT OBJECTS : \(self.debtObjects.count)")
        println(self.getNumOfDebts(groupFriends.count))
        if self.debtObjects.count != getNumOfDebts(groupFriends.count) {
            println("CREATE RELATIONS")
            createDebtRelations(groupFriends,groupName:userGroupName)
        }
        println("GET RELATIONS")
        refreshDebts(groupFriends,groupName:userGroupName,backGround:background)
        
        //generateDebtStrings()
        println("FINISH TO CALCULATE \(self.relations)")
    }
    }
   
}

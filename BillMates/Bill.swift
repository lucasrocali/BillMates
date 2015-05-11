//
//  Bill.swift
//  BillMates
//
//  Created by Lucas Rocali on 4/26/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import Foundation
import CoreData

class Bill: NSManagedObject {
    @NSManaged var attDescription: String
    @NSManaged var attValue: String
    @NSManaged var billOwner : User
    @NSManaged var billUsers: NSSet
    
    func getDescrition()-> String {
        return self.attDescription as String
    }
    
    func getValue()-> String {
        return self.attValue as String
    }
    
    func getBillOwner()->User {
        return self.billOwner as User
    }
    
    func getBillUsers()-> NSArray {
        var billUser = self.mutableSetValueForKey("billUsers");
        
        return billUser.allObjects
    }
    
    func addBillUser(user:User) {
        var billUser = self.mutableSetValueForKey("billUsers");
        billUser.addObject(user)
    }
}

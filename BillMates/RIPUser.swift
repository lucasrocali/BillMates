//
//  User.swift
//  BillMates
//
//  Created by Lucas Rocali on 4/26/15.
//  Copyright (c) 2015 Lucas Rocali. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {
    @NSManaged var attName: String

    func getName()->String {
        return self.attName as String
    }
}
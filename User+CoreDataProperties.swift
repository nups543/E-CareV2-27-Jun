//
//  User+CoreDataProperties.swift
//  E-CareV2
//
//  Created by Nupur Sharma on 27/06/17.
//  Copyright © 2017 Franciscan. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var classId: String?
    @NSManaged public var photo: String?
    @NSManaged public var id: String?
    @NSManaged public var studentClass: String?
    @NSManaged public var username: String?
    @NSManaged public var password: String?
    @NSManaged public var panel: String?
    @NSManaged public var schoolRelationship: School?

}

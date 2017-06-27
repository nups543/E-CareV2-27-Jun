//
//  School+CoreDataProperties.swift
//  E-CareV2
//
//  Created by Nupur Sharma on 27/06/17.
//  Copyright © 2017 Franciscan. All rights reserved.
//

import Foundation
import CoreData


extension School {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<School> {
        return NSFetchRequest<School>(entityName: "School")
    }

    @NSManaged public var schoolCode: String?
    @NSManaged public var schoolEcare: String?
    @NSManaged public var schoolName: String?
    @NSManaged public var schoolWebSite: String?
    @NSManaged public var supportEmail: String?
    @NSManaged public var supportPhone: String?
    @NSManaged public var userRelationship: User?

}

//
//  People+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Jason on 02/08/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

import Foundation
import CoreData


extension People {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<People> {
        return NSFetchRequest<People>(entityName: "People")
    }

    @NSManaged public var name: String?
    @NSManaged public var sex: String?
    @NSManaged public var age: String?

}

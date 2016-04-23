//
//  Settings+CoreDataProperties.swift
//  
//
//  Created by Pawel Rusin on 4/23/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Settings {

    @NSManaged var currentLevel: NSNumber?
    @NSManaged var currentLesson: NSNumber?
    @NSManaged var filterLevel: NSNumber?
    @NSManaged var filterLesson: NSNumber?
    @NSManaged var filterOn: NSNumber?
    @NSManaged var extraMaterial: NSNumber?

}

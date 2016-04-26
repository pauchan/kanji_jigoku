//
//  Testable+CoreDataProperties.swift
//  
//
//  Created by Pawel Rusin on 4/24/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Testable {

    @NSManaged var kanji: String?
    @NSManaged var meaning: String?
    @NSManaged var reading: String?
    @NSManaged var ascii_meaning: String?

}

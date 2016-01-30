//
//  Radical+CoreDataProperties.swift
//  
//
//  Created by Pawel Rusin on 1/30/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Radical {

    @NSManaged var name: String?
    @NSManaged var number: Int32
    @NSManaged var radical: String?
    @NSManaged var character: Kanji?

}

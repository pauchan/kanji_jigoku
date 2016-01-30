//
//  Kunyomi+CoreDataProperties.swift
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

extension Kunyomi {

    @NSManaged var speechPart: Int32
    @NSManaged var hiraganaReading: String?
    @NSManaged var character: Kanji?

}

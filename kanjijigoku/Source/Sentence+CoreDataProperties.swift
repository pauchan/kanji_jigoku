//
//  Sentence+CoreDataProperties.swift
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

extension Sentence {

    @NSManaged var example: String?
    @NSManaged var kanji: String?
    @NSManaged var meaning: String?
    @NSManaged var ascii_meaning: String?
    @NSManaged var sentence: String?
    @NSManaged var sentenceId: Int32
    @NSManaged var character: Kanji?
    @NSManaged var examples: Example?

}

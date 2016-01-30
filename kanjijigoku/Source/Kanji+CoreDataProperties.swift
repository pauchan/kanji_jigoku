//
//  Kanji+CoreDataProperties.swift
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

extension Kanji {

    @NSManaged var alternativeKanji: String?
    @NSManaged var alternativeRadical: Int32
    @NSManaged var kanji: String?
    @NSManaged var kanjiId: Int32
    @NSManaged var lesson: Int32
    @NSManaged var level: Int32
    @NSManaged var meaning: String?
    @NSManaged var note: String?
    @NSManaged var radical: Int32
    @NSManaged var relatedKanji: String?
    @NSManaged var strokeCount: Int32
    @NSManaged var examples: NSSet?
    @NSManaged var kunyomis: NSSet?
    @NSManaged var onyomis: NSSet?
    @NSManaged var radicals: NSSet?
    @NSManaged var sentences: NSSet?

}

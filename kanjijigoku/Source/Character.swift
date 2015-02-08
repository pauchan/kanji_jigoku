//
//  Character.swift
//  kanjijigoku
//
//  Created by Pawel Rusin on 2/8/15.
//  Copyright (c) 2015 Pawel Rusin. All rights reserved.
//

import Foundation
import CoreData

class Character: NSManagedObject {

    @NSManaged var kanji: String
    @NSManaged var meaning: String
    @NSManaged var strokeCount: Int16
    @NSManaged var radical: Int16
    @NSManaged var alternativeRadical: Int16
    @NSManaged var note: String
    @NSManaged var realatedKanji: String
    @NSManaged var lesson: Int16
    @NSManaged var level: Int16
    @NSManaged var code: Int16
    @NSManaged var kanjiId: Int16
    @NSManaged var readings: NSSet
    @NSManaged var examples: NSSet
    @NSManaged var sentences: NSSet
    @NSManaged var radicals: NSSet

}

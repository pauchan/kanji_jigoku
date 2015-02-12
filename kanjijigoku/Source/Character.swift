//
//  Character.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/12.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation
import CoreData

class Character: NSManagedObject {

    @NSManaged var alternativeKanji: String
    @NSManaged var alternativeRadical: Int32
    @NSManaged var code: Int32
    @NSManaged var kanji: String
    @NSManaged var kanjiId: Int32
    @NSManaged var lesson: Int32
    @NSManaged var level: Int32
    @NSManaged var meaning: String
    @NSManaged var note: String
    @NSManaged var radical: Int32
    @NSManaged var relatedKanji: Int32
    @NSManaged var strokeCount: Int32
    @NSManaged var examples: NSSet
    @NSManaged var radicals: NSSet
    @NSManaged var sentences: NSSet
    @NSManaged var kunyomis: NSSet
    @NSManaged var onyomis: NSSet

}

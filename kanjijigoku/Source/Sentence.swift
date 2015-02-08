//
//  Sentence.swift
//  kanjijigoku
//
//  Created by Pawel Rusin on 2/8/15.
//  Copyright (c) 2015 Pawel Rusin. All rights reserved.
//

import Foundation
import CoreData

class Sentence: NSManagedObject {

    @NSManaged var kanji: String
    @NSManaged var example: String
    @NSManaged var sentenceId: Int16
    @NSManaged var code: Int16
    @NSManaged var sentence: String
    @NSManaged var meaning: String
    @NSManaged var character: Character
    @NSManaged var examples: Example

}

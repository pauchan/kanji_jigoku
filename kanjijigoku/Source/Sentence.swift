//
//  Sentence.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/12.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation
import CoreData

class Sentence: NSManagedObject {

    @NSManaged var code: Int32
    @NSManaged var example: String
    @NSManaged var kanji: String
    @NSManaged var meaning: String
    @NSManaged var sentence: String
    @NSManaged var sentenceId: Int32
    @NSManaged var character: Character
    @NSManaged var examples: Example

}

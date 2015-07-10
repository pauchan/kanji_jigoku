//
//  Sentence.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/12.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation
import CoreData

class Sentence: BaseEntity {

    @NSManaged var example: String
    @NSManaged var kanji: String
    @NSManaged var meaning: String
    @NSManaged var sentence: String
    @NSManaged var sentenceId: Int32
    @NSManaged var character: Kanji
    @NSManaged var examples: Example

}

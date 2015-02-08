//
//  Example.swift
//  kanjijigoku
//
//  Created by Pawel Rusin on 2/8/15.
//  Copyright (c) 2015 Pawel Rusin. All rights reserved.
//

import Foundation
import CoreData

class Example: NSManagedObject {

    @NSManaged var kanji: String
    @NSManaged var exampleId: Int16
    @NSManaged var meaning: String
    @NSManaged var note: String
    @NSManaged var reading: String
    @NSManaged var code: Int16
    @NSManaged var example: String
    @NSManaged var character: Character
    @NSManaged var sentences: NSSet

}

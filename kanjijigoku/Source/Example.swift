//
//  Example.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/09.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation
import CoreData

class Example: NSManagedObject {

    @NSManaged var code: Int32
    @NSManaged var example: String
    @NSManaged var exampleId: Int32
    @NSManaged var kanji: String
    @NSManaged var meaning: String
    @NSManaged var note: String
    @NSManaged var reading: String
    @NSManaged var character: Character
    @NSManaged var sentences: NSSet

}

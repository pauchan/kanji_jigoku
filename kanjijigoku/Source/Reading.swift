//
//  Reading.swift
//  kanjijigoku
//
//  Created by Pawel Rusin on 2/8/15.
//  Copyright (c) 2015 Pawel Rusin. All rights reserved.
//

import Foundation
import CoreData

class Reading: NSManagedObject {

    @NSManaged var kanji: String
    @NSManaged var reading: String
    @NSManaged var meaning: String
    @NSManaged var note: String
    @NSManaged var readingId: Int16
    @NSManaged var code: Int16
    @NSManaged var character: Character

}

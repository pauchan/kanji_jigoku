//
//  Example.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/12.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation
import CoreData

class Example: Testable {

    @NSManaged var code: Int32
    @NSManaged var example: String
    @NSManaged var exampleId: Int32
    @NSManaged var note: String
    @NSManaged var character: Character
    @NSManaged var sentences: NSSet

}

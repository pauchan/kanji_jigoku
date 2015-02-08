//
//  Radical.swift
//  kanjijigoku
//
//  Created by Pawel Rusin on 2/8/15.
//  Copyright (c) 2015 Pawel Rusin. All rights reserved.
//

import Foundation
import CoreData

class Radical: NSManagedObject {

    @NSManaged var number: Int16
    @NSManaged var radical: String
    @NSManaged var name: String
    @NSManaged var character: Character

}

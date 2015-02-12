//
//  Radical.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/12.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation
import CoreData

class Radical: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var number: Int32
    @NSManaged var radical: String
    @NSManaged var character: Character

}

//
//  Testable.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/12.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation
import CoreData

class Testable: BaseEntity {

    @NSManaged var kanji: String
    @NSManaged var meaning: String
    @NSManaged var reading: String

}

//
//  Reading.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/12.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation
import CoreData

class Reading: Testable {

    @NSManaged var note: String
    @NSManaged var readingId: Int32

}

//
//  Kunyomi.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/12.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation
import CoreData

class Kunyomi: Reading {

    @NSManaged var speechPart: Int32
    @NSManaged var character: Character

}

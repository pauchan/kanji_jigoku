//
//  BaseEntity.swift
//  
//
//  Created by Pawel Rusin on 1/30/16.
//
//

import Foundation
import CoreData


class BaseEntity: NSManagedObject {

    var obligatory: Bool {
        
        get {
            if self.code!.rangeOfString("8") == nil {
                return true
            } else {
                return false
            }
        }
    }
}

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
            
            debugLog("code is \(self.code)")
            if self.code!.rangeOfString("8") == nil {
                
                return true
            }
            return false
        }
    }
}

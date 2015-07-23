//
//  PRBaseEntityExtension.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/07/10.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation

extension BaseEntity {
    
    var obligatory: Bool {
        
        get {
            
            debugLog("code is \(self.code)")
            if self.code.rangeOfString("8") == nil {
                
                return true
            }
            return false
        }
    }
}
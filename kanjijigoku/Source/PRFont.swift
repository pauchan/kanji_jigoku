//
//  PRFont.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/07/09.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation
import UIKit


extension UIFont {


    func appFont() -> UIFont {
        return UIFont(name: "HiraKakuProN-W3", size: 12.0)!
    }
    
    func appFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "HiraKakuProN-W3", size: size)!
    }
    
}
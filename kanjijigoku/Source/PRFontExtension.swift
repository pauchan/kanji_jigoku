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
    
    func appFontOfSize(size: CGFloat) -> UIFont {
        let fontSize = (IS_IPAD) ? size*2 : size;
        return UIFont(name: "HiraKakuProN-W3", size: fontSize)!
    }
    
}
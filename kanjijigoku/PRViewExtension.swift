//
//  PRViewExtension.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/07/09.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation
import UIKit


extension UIView {

    func fontSizeToFitView(desiredFont: UIFont, text: String) -> UIFont {
        
        let constraintsSize = CGSizeMake(self.bounds.size.width, CGFloat(MAXFLOAT))
        let requiredSize = text.boundingRectWithSize(constraintsSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: desiredFont], context: nil)
        println("Reqired size is: \(requiredSize.height) Actual size is: \(self.bounds.size.height)")  
        if requiredSize.height < self.bounds.size.height {
            
            return desiredFont
        } else {
            let ratio =  self.bounds.size.height / requiredSize.height
            println("new ratio is /(ratio)")
            return UIFont().appFontOfSize(ratio * desiredFont.pointSize)
        }
    }
}
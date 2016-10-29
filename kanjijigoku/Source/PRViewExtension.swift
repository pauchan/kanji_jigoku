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

    func fontSizeToFitView(_ desiredFont: UIFont, text: String) -> UIFont {
        
        let constraintsSize = CGSize(width: self.bounds.size.width, height: CGFloat(MAXFLOAT))
        let requiredSize = text.boundingRect(with: constraintsSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: desiredFont], context: nil)
        debugLog("Reqired size is: \(requiredSize.height) Actual size is: \(self.bounds.size.height)")
        if requiredSize.height < self.bounds.size.height {
            
            return desiredFont
        } else {
            let ratio =  self.bounds.size.height / requiredSize.height
            debugLog("new ratio is /(ratio)")
            return UIFont().appFontOfSize(ratio * desiredFont.pointSize)

        }
    }
}

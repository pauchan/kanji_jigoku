//
//  PRFuriganaLabel.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/16.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit
import CoreText

class PRFuriganaLabel : UIView
{

    var furiganaText : NSAttributedString!
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0)
        CGContextAddRect(context, rect)
        CGContextFillPath(context)
        
        CGContextTranslateCTM(context,0.0 , 35.0)
        CGContextScaleCTM(context, 1.0, -1.0)
        
        let line = CTLineCreateWithAttributedString(furiganaText)
        let width : Float = Float(CTLineGetTypographicBounds(line, nil, nil, nil))
        let yCenter : Float = (Float(rect.width)-width)/2.0
        
        CGContextTranslateCTM(context,CGFloat(yCenter) , 0.0)

        CTLineDraw(line, context)
    }

}

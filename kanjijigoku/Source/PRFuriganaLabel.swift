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
        
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, self.bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0)
        
        var attributedText = furiganaText as? NSMutableAttributedString
        
        let newFont = self.fontSizeToFitView(UIFont().appFontOfSize(22.0), text: furiganaText.string)
        attributedText?.addAttribute(NSFontAttributeName, value: newFont, range: NSRange(location: 0,length: furiganaText.length))
        
        if attributedText != nil {
            
            var alignment = CTTextAlignment.TextAlignmentCenter
            let alignmentSetting = [CTParagraphStyleSetting(spec: .Alignment, valueSize: Int(sizeofValue(alignment)), value: &alignment)]
            let paragraphStyle = CTParagraphStyleCreate(alignmentSetting, 1)
            CFAttributedStringSetAttribute(attributedText, CFRangeMake(0, CFAttributedStringGetLength(attributedText)), kCTParagraphStyleAttributeName, paragraphStyle)
            
            var path: CGMutablePathRef = CGPathCreateMutable()
            CGPathAddRect(path, nil, self.bounds)
            
            let frameSetter : CTFramesetterRef = CTFramesetterCreateWithAttributedString(attributedText)
            let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, attributedText!.length), path, nil)
            
            CTFrameDraw(frame, context)
        } else {
        
            let line = CTLineCreateWithAttributedString(furiganaText)
            let width : Float = Float(CTLineGetTypographicBounds(line, nil, nil, nil))
            let yCenter : Float = (Float(rect.width)-width)/2.0
            CGContextTranslateCTM(context,CGFloat(yCenter) , 0.0)
            CTLineDraw(line, context)
        }
    }

}

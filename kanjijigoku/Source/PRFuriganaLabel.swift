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

    var printExplanation : Bool!
    var furiganaText : NSAttributedString!

    
    override func drawRect(rect: CGRect) {

        let context = UIGraphicsGetCurrentContext()
        
        let attributedText = furiganaText as? NSMutableAttributedString
        print(attributedText?.string)
        print(furiganaText?.string)
        let fontSize = self.fontSizeForCharacterCount((attributedText?.length)!)
        let newFont = self.fontSizeToFitView(UIFont().appFontOfSize(fontSize), text: furiganaText.string)
        attributedText?.removeAttribute(NSFontAttributeName, range: NSRange(location: 0, length: furiganaText.length))
        attributedText?.addAttribute(NSFontAttributeName, value: newFont, range: NSRange(location: 0,length: furiganaText.length))
        
        // vertically align text
        let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Center
        attributedText?.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: furiganaText.length))
        
        if (attributedText != nil) { // this one determines if there is one line or more than one line for text

            let path: CGMutablePathRef = CGPathCreateMutable()
            let frameSetter : CTFramesetterRef = CTFramesetterCreateWithAttributedString(attributedText!)
            
            //flip context is required every time to prevent text beining drawn upside down
            CGContextSetTextMatrix(context, CGAffineTransformIdentity)
            CGContextTranslateCTM(context, 0, self.bounds.size.height)
            CGContextScaleCTM(context, 1.0, -1.0)

            print("characters \(attributedText?.length)")
            // TODO: 250 is not enough for the very long texts
            CGPathAddRect(path, nil, CGRectMake(0, rect.origin.y-(self.frame.size.height-220.0), self.frame.size.width, self.frame.size.height))

            let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, attributedText!.length), path, nil)
            
            CTFrameDraw(frame, context!)
        } else {
            let line = CTLineCreateWithAttributedString(furiganaText)
            CGContextSetTextMatrix(context, CGAffineTransformIdentity)
            CGContextTranslateCTM(context, 0, 50.0)
            CGContextScaleCTM(context, 1.0, -1.0)
            CTLineDraw(line, context!)
            
        }
    }
    
    func fontSizeForCharacterCount(count: Int) -> CGFloat
    {
        return CGFloat(24-2*(count/25))
    }
}

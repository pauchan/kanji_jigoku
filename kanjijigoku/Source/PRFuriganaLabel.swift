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

    
    override func draw(_ rect: CGRect) {

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
        paragraphStyle.alignment = NSTextAlignment.center
        attributedText?.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: furiganaText.length))
        
        if (attributedText != nil) { // this one determines if there is one line or more than one line for text

            let path: CGMutablePath = CGMutablePath()
            let frameSetter : CTFramesetter = CTFramesetterCreateWithAttributedString(attributedText!)
            
            //flip context is required every time to prevent text beining drawn upside down
            context!.textMatrix = CGAffineTransform.identity
            context?.translateBy(x: 0, y: self.bounds.size.height)
            context?.scaleBy(x: 1.0, y: -1.0)

            path.addRect(CGRect(x: 0, y: -20.0, width: self.frame.size.width, height: self.frame.size.height))

            let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, attributedText!.length), path, nil)
            
            CTFrameDraw(frame, context!)
        } else {
            let line = CTLineCreateWithAttributedString(furiganaText)
            context!.textMatrix = CGAffineTransform.identity
            context?.translateBy(x: 0, y: 50.0)
            context?.scaleBy(x: 1.0, y: -1.0)
            CTLineDraw(line, context!)
            
        }
    }
    
    func fontSizeForCharacterCount(_ count: Int) -> CGFloat
    {
        return CGFloat(24-2*(count/25))
    }
}

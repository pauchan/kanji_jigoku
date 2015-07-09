//
//  PRSentenceExtension.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/07/09.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation
import CoreText

extension Sentence
{
    func generateFuriganaString(baseString: String, furiganaString: String) -> NSAttributedString
    {
        
        let test1 = baseString as NSString
        let test2 = furiganaString as NSString
        
        var text = [.passRetained(test2) as Unmanaged<CFStringRef>?, .None, .None, .None]
        let annotation = CTRubyAnnotationCreate(.Auto, .Auto, 0.5, &text)
        
        var alignment = CTTextAlignment.TextAlignmentCenter
        var wrap = CTLineBreakMode.ByTruncatingTail
        
        var settings = [CTParagraphStyleSetting(spec: .Alignment, valueSize: Int(sizeofValue(alignment)), value: &alignment),CTParagraphStyleSetting(spec: .LineBreakMode, valueSize: Int(sizeofValue(wrap)), value: &wrap)]
        let style = CTParagraphStyleCreate(settings, 1)
        
        
        return NSAttributedString(string: test1 as String, attributes: [
            kCTRubyAnnotationAttributeName: annotation.takeUnretainedValue(),
            kCTParagraphStyleAttributeName: style
            ])
        
    }
    
    func replaceExplainedSentence(sentence: String) -> NSAttributedString
    {
        var parsedSentence : NSString = NSString(string: sentence)
        var range = NSMakeRange(0, count(sentence))
        var attributedString = NSMutableAttributedString(string: sentence)
        let regex = NSRegularExpression(pattern:"\\{(.*?);(.*?)\\}", options: nil, error: nil)
        
        var sentence2 = sentence
        
        while let group :NSTextCheckingResult = regex?.firstMatchInString(sentence2, options: nil, range: range)
        {
            
            attributedString.replaceCharactersInRange(group.range, withAttributedString: generateFuriganaString(parsedSentence.substringWithRange(group.rangeAtIndex(1)), furiganaString: parsedSentence.substringWithRange(group.rangeAtIndex(2))))
            parsedSentence = NSString(string: attributedString.string)
            sentence2 = String(parsedSentence)
            range = NSMakeRange(0, count(sentence2))
            
        }
        
        
        if let arr = regex?.matchesInString(sentence, options: nil, range: range)
        {
            for element in arr
            {
                let group = element as! NSTextCheckingResult
                
                
            }
        }
        return attributedString
    }
    
    
    func getExplainedSentence() -> NSAttributedString
    {
        var parsedSentence : NSString = NSString(string: sentence)
        var range = NSMakeRange(0, count(sentence))
        var attributedString = NSMutableAttributedString(string: parsedSentence as String)
        let regex = NSRegularExpression(pattern:"\\{(.*?);(.*?)\\}", options: nil, error: nil)
        
        var sentence2 = sentence
        
        while let group :NSTextCheckingResult = regex?.firstMatchInString(sentence2, options: nil, range: range)
        {
            
            attributedString.replaceCharactersInRange(group.range, withAttributedString: generateFuriganaString(parsedSentence.substringWithRange(group.rangeAtIndex(1)), furiganaString: parsedSentence.substringWithRange(group.rangeAtIndex(2))))
            parsedSentence = NSString(string: attributedString.string)
            sentence2 = String(parsedSentence)
            range = NSMakeRange(0, count(sentence2))
            
        }
        
        
        if let arr = regex?.matchesInString(sentence, options: nil, range: range)
        {
            for element in arr
            {
                let group = element as! NSTextCheckingResult
                
                
            }
        }
        return attributedString
    }
    
}
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
        let annotation = CTRubyAnnotationCreate(.Auto, .Auto, 0.5, &text) as CTRubyAnnotationRef
        
        var alignment = CTTextAlignment.Center
        var wrap = CTLineBreakMode.ByTruncatingTail
        
        let settings = [CTParagraphStyleSetting(spec: .Alignment, valueSize: Int(sizeofValue(alignment)), value: &alignment),CTParagraphStyleSetting(spec: .LineBreakMode, valueSize: Int(sizeofValue(wrap)), value: &wrap)]
        let style = CTParagraphStyleCreate(settings, 1)
        
        
        return NSAttributedString(string: test1 as String, attributes: [
            kCTRubyAnnotationAttributeName as String: annotation,
            kCTParagraphStyleAttributeName as String: style
            ])
        
    }
    
    func replaceExplainedSentence(sentence: String) -> NSAttributedString
    {
        var parsedSentence : NSString = NSString(string: sentence)
        var range = NSMakeRange(0, sentence.characters.count)
        let attributedString = NSMutableAttributedString(string: sentence)
        let regex = try? NSRegularExpression(pattern:"\\{(.*?);(.*?)\\}", options: [])
        
        var sentence2 = sentence
        
        while let group :NSTextCheckingResult = regex?.firstMatchInString(sentence2, options: [], range: range)
        {
            attributedString.replaceCharactersInRange(group.range, withAttributedString: generateFuriganaString(parsedSentence.substringWithRange(group.rangeAtIndex(1)), furiganaString: parsedSentence.substringWithRange(group.rangeAtIndex(2))))
            parsedSentence = NSString(string: attributedString.string)
            sentence2 = String(parsedSentence)
            range = NSMakeRange(0, sentence2.characters.count)
            
        }
        return attributedString
    }
    
    
    func getExplainedSentence() -> NSAttributedString
    {
        var parsedSentence : NSString = NSString(string: sentence!)
        var range = NSMakeRange(0, sentence!.characters.count)
        let attributedString = NSMutableAttributedString(string: parsedSentence as String)
        let regex = try? NSRegularExpression(pattern:"\\{(.*?);(.*?)\\}", options: [])
        
        var sentence2 = sentence
        
        while let group :NSTextCheckingResult = regex?.firstMatchInString(sentence!, options: [], range: range)
        {
            
            attributedString.replaceCharactersInRange(group.range, withAttributedString: generateFuriganaString(parsedSentence.substringWithRange(group.rangeAtIndex(1)), furiganaString: parsedSentence.substringWithRange(group.rangeAtIndex(2))))
            parsedSentence = NSString(string: attributedString.string)
            sentence2 = String(parsedSentence)
            range = NSMakeRange(0, sentence2!.characters.count)
            
        }
        return attributedString
    }
}
//
//  PRCharacterExtension.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/13.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation
import CoreText

extension Character
{

    func generateReadingString(set: NSSet) -> String
    {
        var returnString = ""
        if set.count == 0
        {
            return returnString
        }
        
        for itObject in set
        {
            if let reading = itObject as? Reading
            {
                returnString += reading.reading + "・"
            }
        }
        return returnString.substringWithRange(Range<String.Index>(start: returnString.startIndex, end: advance(returnString.endIndex, -1)))
    }
}

extension Sentence
{
    func generateFuriganaString(baseString: String, furiganaString: String) -> NSAttributedString
    {
    
        var text = [.passRetained(furiganaString) as Unmanaged<CFStringRef>?, .None, .None, .None]
        let annotation = CTRubyAnnotationCreate(.Auto, .Auto, 0.5, &text)
        
        return NSAttributedString(string: baseString, attributes: [
            kCTRubyAnnotationAttributeName: annotation.takeUnretainedValue(),
            ])
    
    }
    
    func replaceExplainedSentence(sentence: String) -> NSAttributedString
    {
        var parsedSentence : NSString = NSString(string: sentence)
        let range = NSMakeRange(0, countElements(sentence))
        var attributedString = NSMutableAttributedString(string: parsedSentence)
        let regex = NSRegularExpression(pattern:"\\{(.*?);(.*?)\\}", options: nil, error: nil)
        
        var sentence2 = sentence
        
        while let group :NSTextCheckingResult = regex?.firstMatchInString(sentence2, options: nil, range: range)
        {
            
            attributedString.replaceCharactersInRange(group.range, withAttributedString: generateFuriganaString(parsedSentence.substringWithRange(group.rangeAtIndex(1)), furiganaString: parsedSentence.substringWithRange(group.rangeAtIndex(2))))
            parsedSentence = NSString(string: attributedString.string)
            sentence2 = String(parsedSentence)
            
        }
        
        
        if let arr = regex?.matchesInString(sentence, options: nil, range: range)
        {
        for element in arr
        {
            let group = element as NSTextCheckingResult

            
        }
        }
        return attributedString
        
            
    }
}

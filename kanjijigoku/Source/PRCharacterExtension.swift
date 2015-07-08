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
        
        let test1 = baseString as NSString
        let test2 = furiganaString as NSString
    
        var text = [.passRetained(test2) as Unmanaged<CFStringRef>?, .None, .None, .None]
        let annotation = CTRubyAnnotationCreate(.Auto, .Auto, 0.5, &text)
        
//        CTParagraphStyleSetting alignmentSetting;
//        alignmentSetting.spec = kCTParagraphStyleSpecifierAlignment;
//        alignmentSetting.valueSize = sizeof(CTTextAlignment);
//        alignmentSetting.value = &alignment;

//        var alignment = CTTextAlignment.TextAlignmentLeft
//        let alignmentSetting = [CTParagraphStyleSetting(spec: .Alignment, valueSize: UInt(sizeofValue(alignment)), value: &alignment)]
//        let paragraphStyle = CTParagraphStyleCreate(alignmentSetting, 1)
//        CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTParagraphStyleAttributeName, paragraphStyle)
        
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

extension Example {

    func generateDescriptionString() -> NSAttributedString {
        
        var attributedText = NSMutableAttributedString(string: self.example, attributes: kPRKanjiJigokuHelveticaBoldTwenty)
        let attributedText2 = NSAttributedString(string: " 【" + self.reading + "】", attributes: kPRKanjiJigokuHelveticaFourteen)
        attributedText.appendAttributedString(attributedText2)
        return attributedText
        
    }

}

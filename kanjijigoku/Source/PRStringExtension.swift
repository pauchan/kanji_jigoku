    //
//  PRStringExtension.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/07/08.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation
import CoreText

extension String
{
    
    func removeReferenceSubstring() -> String {
        
        let regex = try? NSRegularExpression(pattern: "\\|.*?\\|" , options: .CaseInsensitive)
        let regex2 = try? NSRegularExpression(pattern: "[\\[\\]]" , options: .CaseInsensitive)
        
        let  mutString : NSMutableString = NSMutableString(string: self)
        
        regex!.replaceMatchesInString(mutString, options: [], range: NSMakeRange(0, self.characters.count), withTemplate: "")
        regex2!.replaceMatchesInString(mutString, options: [], range: NSMakeRange(0, mutString.length), withTemplate: "")
        return mutString as String
    }
    
    
    func isRomaji() -> Bool {
        
        return isAlhpabetWithCharacters("[a-z]")
    }

    func isKatakana() -> Bool {
        
        return isAlhpabetWithCharacters("[ァ-ヶ]")
    }
    
    func isHiragana() -> Bool {
        
        return isAlhpabetWithCharacters("[ぁ-ん]")
    }
    
    func isKanji() -> Bool {
        
        return isAlhpabetWithCharacters("[一-龠]")
    }
    
    func isAlhpabetWithCharacters(characters: String) -> Bool {
        
        let regex = try? NSRegularExpression(pattern: characters , options: .CaseInsensitive)
        let  mutString : NSMutableString = NSMutableString(string: self)
        
        regex!.replaceMatchesInString(mutString, options: [], range: NSMakeRange(0, self.characters.count), withTemplate: "")
        if mutString.length == 0 {
            
            return true
        }else {
            return false
        }
    }
    
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
    
    func furiganaExplainedSentence() -> NSAttributedString
    {
        var parsedSentence : NSString = NSString(string: self)
        var range = NSMakeRange(0, self.characters.count)
        let attributedString = NSMutableAttributedString(string: self)
        let regex = try? NSRegularExpression(pattern:"\\{(.*?);(.*?)\\}", options: [])
        
        var sentence2 = self
        
        while let group :NSTextCheckingResult = regex?.firstMatchInString(sentence2, options: [], range: range)
        {
            attributedString.replaceCharactersInRange(group.range, withAttributedString: generateFuriganaString(parsedSentence.substringWithRange(group.rangeAtIndex(1)), furiganaString: parsedSentence.substringWithRange(group.rangeAtIndex(2))))
            parsedSentence = NSString(string: attributedString.string)
            sentence2 = String(parsedSentence)
            range = NSMakeRange(0, sentence2.characters.count)
            
        }
        return attributedString
    }
    
    
    func furiganaExtractedSentence() -> NSAttributedString
    {
        var parsedSentence : NSString = NSString(string: self)
        var range = NSMakeRange(0, self.characters.count)
        let attributedString = NSMutableAttributedString(string: parsedSentence as String)
        let regex = try? NSRegularExpression(pattern:"\\{(.*?);(.*?)\\}", options: [])
        
        var sentence2 = self
        
        while let group :NSTextCheckingResult = regex?.firstMatchInString(sentence2, options: [], range: range)
        {
            attributedString.replaceCharactersInRange(group.range, withAttributedString: NSAttributedString(string: parsedSentence.substringWithRange(group.rangeAtIndex(1))))
            parsedSentence = NSString(string: attributedString.string)
            sentence2 = String(parsedSentence)
            range = NSMakeRange(0, sentence2.characters.count)
        }
        return attributedString
    }
    
    func kanjiWithOkurigana(kanji: String) -> String
        {
            do {
                let regexp = try NSRegularExpression(pattern: ".*（", options: [NSRegularExpressionOptions.CaseInsensitive])
                let mutReading = NSMutableString(string: self)
                regexp.replaceMatchesInString(mutReading, options: [], range: NSRange(location: 0,length: mutReading.length), withTemplate: kanji)
                let fullWidthBracketesSet = NSCharacterSet(charactersInString: "（）")
                return mutReading.stringByTrimmingCharactersInSet(fullWidthBracketesSet)
            } catch {
                print("Error while regexping string. Return default value.")
                return self
            }
    }
    
    
    func plainHiragana() -> String
        {
            return self.stringByReplacingOccurrencesOfString("（", withString: "").stringByReplacingOccurrencesOfString("）", withString: "")
    }
}


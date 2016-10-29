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
        
        let regex = try? NSRegularExpression(pattern: "\\|.*?\\|" , options: .caseInsensitive)
        let regex2 = try? NSRegularExpression(pattern: "[\\[\\]]" , options: .caseInsensitive)
        
        let  mutString : NSMutableString = NSMutableString(string: self)
        
        regex!.replaceMatches(in: mutString, options: [], range: NSMakeRange(0, self.characters.count), withTemplate: "")
        regex2!.replaceMatches(in: mutString, options: [], range: NSMakeRange(0, mutString.length), withTemplate: "")
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
    
    func isAlhpabetWithCharacters(_ characters: String) -> Bool {
        
        let regex = try? NSRegularExpression(pattern: characters , options: .caseInsensitive)
        let  mutString : NSMutableString = NSMutableString(string: self)
        
        regex!.replaceMatches(in: mutString, options: [], range: NSMakeRange(0, self.characters.count), withTemplate: "")
        if mutString.length == 0 {
            
            return true
        }else {
            return false
        }
    }
    
    func generateFuriganaString(_ baseString: String, furiganaString: String) -> NSAttributedString
    {
        
        let test1 = baseString as NSString
        let test2 = furiganaString as CFString
        
        var unmanaged = Unmanaged.passUnretained(test2)
        let annotation = CTRubyAnnotationCreate(.auto, .auto, 0.5, &unmanaged) as CTRubyAnnotation
        
        var alignment = CTTextAlignment.center
        var wrap = CTLineBreakMode.byTruncatingTail
        
        let settings = [CTParagraphStyleSetting(spec: .alignment, valueSize: Int(MemoryLayout.size(ofValue: alignment)), value: &alignment),CTParagraphStyleSetting(spec: .lineBreakMode, valueSize: Int(MemoryLayout.size(ofValue: wrap)), value: &wrap)]
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
        
        while let group :NSTextCheckingResult = regex?.firstMatch(in: sentence2, options: [], range: range)
        {
            attributedString.replaceCharacters(in: group.range, with: generateFuriganaString(parsedSentence.substring(with: group.rangeAt(1)), furiganaString: parsedSentence.substring(with: group.rangeAt(2))))
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
        
        while let group :NSTextCheckingResult = regex?.firstMatch(in: sentence2, options: [], range: range)
        {
            attributedString.replaceCharacters(in: group.range, with: NSAttributedString(string: parsedSentence.substring(with: group.rangeAt(1))))
            parsedSentence = NSString(string: attributedString.string)
            sentence2 = String(parsedSentence)
            range = NSMakeRange(0, sentence2.characters.count)
        }
        return attributedString
    }
    
    func kanjiWithOkurigana(_ kanji: String) -> String
        {
            do {
                let regexp = try NSRegularExpression(pattern: ".*（", options: [NSRegularExpression.Options.caseInsensitive])
                let mutReading = NSMutableString(string: self)
                let matches = regexp.replaceMatches(in: mutReading, options: [], range: NSRange(location: 0,length: mutReading.length), withTemplate: kanji)
                if matches == 0 {
                    return kanji
                } else {
                    let fullWidthBracketesSet = CharacterSet(charactersIn: "（）")
                    return mutReading.trimmingCharacters(in: fullWidthBracketesSet)
                }
            } catch {
                print("Error while regexping string. Return default value.")
                return self
            }
    }
    
    
    func plainHiragana() -> String
        {
            return self.replacingOccurrences(of: "（", with: "").replacingOccurrences(of: "）", with: "")
    }
    
    func replaceBracketWithHalfWidth() -> String
    {
        return self.replacingOccurrences(of: "（", with: "(").replacingOccurrences(of: "）", with: ")")
    }
    
    func substituteRemainingPolishChars() -> String {
        return self.replacingOccurrences(of: "ł", with: "l", options: NSString.CompareOptions.caseInsensitive, range: self.range(of: self))
    }
}


//
//  Sentence.swift
//  
//
//  Created by Pawel Rusin on 1/30/16.
//
//

import Foundation
import CoreData
import CoreText

class Sentence: BaseEntity {

    func generateFuriganaString(_ baseString: String, furiganaString: String) -> NSAttributedString
    {
        
        let test1 = baseString as NSString
        let test2 = furiganaString as CFString
        
        var x = Unmanaged.passUnretained(test2)
        
        let annotation = CTRubyAnnotationCreate(.auto, .auto, 0.5, &x) as CTRubyAnnotation
        
        var alignment = CTTextAlignment.center
        var wrap = CTLineBreakMode.byTruncatingTail
        
        let settings = [CTParagraphStyleSetting(spec: .alignment, valueSize: Int(MemoryLayout.size(ofValue: alignment)), value: &alignment),CTParagraphStyleSetting(spec: .lineBreakMode, valueSize: Int(MemoryLayout.size(ofValue: wrap)), value: &wrap)]
        let style = CTParagraphStyleCreate(settings, 1)
        
        
        return NSAttributedString(string: test1 as String, attributes: [
            kCTRubyAnnotationAttributeName as String: annotation,
            kCTParagraphStyleAttributeName as String: style
            ])
        
    }
    
    func replaceExplainedSentence() -> String
    {
        var tempSentence = sentence!
        
        var range = NSMakeRange(0, self.sentence!.characters.count)
        let mutString = NSMutableString(string: self.sentence!)
        let regex = try? NSRegularExpression(pattern:"\\{(.*?);(.*?)\\}", options: [])
        
        while let group :NSTextCheckingResult = regex?.firstMatch(in: tempSentence, options: [], range: range) {
            
            mutString.replaceCharacters(in: group.range, with: mutString.substring(with: group.rangeAt(1)))
            tempSentence = String(mutString)
            range = NSMakeRange(0, tempSentence.characters.count)
        }
        return String(mutString)
    }
}

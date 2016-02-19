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
    
    func replaceExplainedSentence() -> String
    {
        var tempSentence = sentence!
        
        var range = NSMakeRange(0, self.sentence!.characters.count)
        let mutString = NSMutableString(string: self.sentence!)
        let regex = try? NSRegularExpression(pattern:"\\{(.*?);(.*?)\\}", options: [])
        
        while let group :NSTextCheckingResult = regex?.firstMatchInString(tempSentence, options: [], range: range) {
            
            mutString.replaceCharactersInRange(group.range, withString: mutString.substringWithRange(group.rangeAtIndex(1)))
            tempSentence = String(mutString)
            range = NSMakeRange(0, tempSentence.characters.count)
        }
        return String(mutString)
    }
}

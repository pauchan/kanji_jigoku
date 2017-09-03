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

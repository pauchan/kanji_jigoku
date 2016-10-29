//
//  Kanji.swift
//  
//
//  Created by Pawel Rusin on 1/30/16.
//
//

import Foundation
import CoreData


class Kanji: BaseEntity {

    func generateReadingString(_ set: NSSet) -> String
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
                returnString += reading.reading! + "・"
            }
        }
        return returnString.substring(with: (returnString.startIndex ..< returnString.characters.index(returnString.endIndex, offsetBy: -1)))
    }
    
    
    func generateRadicalsString() -> String {
        
        let arr = self.radicals!.allObjects as! [Radical]
        return arr.map
            {
                (radical : Radical) -> String in radical.radical!
                
            }.reduce("")
                {
                    (base,append) in base + append
        }
    }
    
    func generateAdditionalKanjiString() -> String {
        
        if self.alternativeKanji != nil {
            return " \(self.alternativeKanji!)"
        } else {
            return ""
        }
    }
    
    func generateCommaSeparatedString(_ arrayOfReadings : [Reading]) -> String
    {
        var appStr : String = ""
        for i in 0..<arrayOfReadings.count
        {
            if i != arrayOfReadings.count-1
            {
                let str = arrayOfReadings[i].reading!.replaceBracketWithHalfWidth()+"　"
                appStr += str
            }
            else
            {
                appStr += arrayOfReadings[i].reading!
            }
        }
        return appStr
    }
}

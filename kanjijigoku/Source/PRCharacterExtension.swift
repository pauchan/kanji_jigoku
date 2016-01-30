//
//  PRKanjiExtension.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/13.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation

extension Kanji
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
                returnString += reading.reading! + "・"
            }
        }
        return returnString.substringWithRange(Range<String.Index>(start: returnString.startIndex, end: returnString.endIndex.advancedBy(-1)))
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
    
    func generateCommaSeparatedString(arrayOfReadings : [Reading]) -> String
    {
        var appStr : String = ""
        for i in 0..<arrayOfReadings.count
        {
            if i != arrayOfReadings.count-1
            {
                let str = arrayOfReadings[i].reading!+", "
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


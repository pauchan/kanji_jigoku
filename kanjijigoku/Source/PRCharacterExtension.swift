//
//  PRCharacterExtension.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/13.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation

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

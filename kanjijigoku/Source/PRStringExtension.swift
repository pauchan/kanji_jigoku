//
//  PRStringExtension.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/07/08.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation

extension String
{

func removeReferenceSubstring() -> String {
    
    let regex = NSRegularExpression(pattern: "\\|.*?\\|" , options: .CaseInsensitive, error: nil)
    let regex2 = NSRegularExpression(pattern: "[\\[\\]]" , options: .CaseInsensitive, error: nil)

    var  mutString : NSMutableString = NSMutableString(string: self)
    
    regex!.replaceMatchesInString(mutString, options: nil, range: NSMakeRange(0, count(self)), withTemplate: "")
    regex2!.replaceMatchesInString(mutString, options: nil, range: NSMakeRange(0, mutString.length), withTemplate: "")
    return mutString as String
    }
}
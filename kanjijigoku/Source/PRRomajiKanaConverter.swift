//
//  PRRomajiKanaConverter.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/07/23.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation

public enum AlphabetType: Int {
    
    case Romaji = 0, Hiragana, Katakana
}

public class PRRomajiKanaConverter {
    
    public lazy var referenceArray = Array<Array<String>>()
    
    class var sharedInstance: PRRomajiKanaConverter {
        struct Static {
            static var instance: PRRomajiKanaConverter?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = PRRomajiKanaConverter()
            
            let bundle = NSBundle.mainBundle()
            if let path = bundle.pathForResource("RomajiKanaConversionArray", ofType: "plist") {
                
                let rootArray = NSArray(contentsOfFile: path)!
                var tempArray = Array<Array<String>>()
                for child in rootArray {
                
                    tempArray.append(child as! Array<String>)
                }
                Static.instance!.referenceArray = tempArray
            }
        }
        
        return Static.instance!
    }
    
    public func convert(string: String, from: AlphabetType, to: AlphabetType) -> String {
        
        let fromIndex = from.rawValue
        let toIndex = to.rawValue
        var outString = string
        
        for conversion in PRRomajiKanaConverter.sharedInstance.referenceArray {
            
            outString = outString.stringByReplacingOccurrencesOfString(conversion[fromIndex], withString: conversion[toIndex], options: NSStringCompareOptions.CaseInsensitiveSearch)            
        }
        return outString
    }
    
}

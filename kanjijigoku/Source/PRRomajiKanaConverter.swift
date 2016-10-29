//
//  PRRomajiKanaConverter.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/07/23.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation

public enum AlphabetType: Int {
    
    case romaji = 0, hiragana, katakana
}

open class PRRomajiKanaConverter {
    
    static let sharedInstance = PRRomajiKanaConverter()
    
    init() {
        let bundle = Bundle.main
        if let path = bundle.path(forResource: "RomajiKanaConversionArray", ofType: "plist") {
            
            let rootArray = NSArray(contentsOfFile: path)!
            var tempArray = Array<Array<String>>()
            for child in rootArray {
                
                tempArray.append(child as! Array<String>)
            }
            referenceArray = tempArray
        }
    }
    
    open lazy var referenceArray = Array<Array<String>>()
    
    open func convert(_ string: String, from: AlphabetType, to: AlphabetType) -> String {
        
        let fromIndex = from.rawValue
        let toIndex = to.rawValue
        var outString = string
        
        for conversion in PRRomajiKanaConverter.sharedInstance.referenceArray {
            
            outString = outString.replacingOccurrences(of: conversion[fromIndex], with: conversion[toIndex], options: NSString.CompareOptions.caseInsensitive)            
        }
        return outString
    }
    
}

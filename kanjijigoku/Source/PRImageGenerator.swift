//
//  PRImageGenerator.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/04/21.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

func generateKanjiImage() -> UIImage {
    
    let font = UIFont(name: "Helvetica", size: 20.0)
    let kanji :NSAttributedString = NSAttributedString(string: "漢字", attributes: [NSFontAttributeName : font!])
    UIGraphicsBeginImageContextWithOptions(kanji.size(), false, 0.0)
    kanji.drawAtPoint(CGPointMake(0.0, 0.0)) //, withAttributes: [NSFontAttributeName : font!])
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img
    
}
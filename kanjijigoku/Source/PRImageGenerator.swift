//
//  PRImageGenerator.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/04/21.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

func generateKanjiImage(color: UIColor) -> UIImage {
    
    let kanji :NSAttributedString = NSAttributedString(string: "漢字", attributes: [NSFontAttributeName : UIFont().appFontOfSize(20.0), NSForegroundColorAttributeName : color])
    UIGraphicsBeginImageContextWithOptions(kanji.size(), false, 0.0)
    
    kanji.drawAtPoint(CGPointMake(0.0, 0.0))
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img
}


func generateCheckmarkImage() -> UIImage {

    let kanji :NSAttributedString = NSAttributedString(string: "\u{2713}", attributes: [NSFontAttributeName : UIFont().appFontOfSize(20.0), NSForegroundColorAttributeName : UIColor.blackColor()])
    UIGraphicsBeginImageContextWithOptions(kanji.size(), false, 0.0)
    
    kanji.drawAtPoint(CGPointMake(0.0, 0.0))
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img
    
    
}
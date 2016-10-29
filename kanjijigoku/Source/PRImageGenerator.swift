//
//  PRImageGenerator.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/04/21.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

func generateKanjiImage(_ color: UIColor) -> UIImage {
    
    let kanjiFont = UIFont(name: "HiraKakuProN-W3", size: 20.0)
    let kanji :NSAttributedString = NSAttributedString(string: "漢字", attributes: [NSFontAttributeName : kanjiFont!, NSForegroundColorAttributeName : color])
    UIGraphicsBeginImageContextWithOptions(kanji.size(), false, 0.0)
    
    kanji.draw(at: CGPoint(x: 0.0, y: 0.0))
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img!
}


func generateCheckmarkImage() -> UIImage {

    let kanji :NSAttributedString = NSAttributedString(string: "\u{2713}", attributes: [NSFontAttributeName : UIFont().appFontOfSize(20.0), NSForegroundColorAttributeName : UIColor.black])
    UIGraphicsBeginImageContextWithOptions(kanji.size(), false, 0.0)
    
    kanji.draw(at: CGPoint(x: 0.0, y: 0.0))
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img!
    
    
}

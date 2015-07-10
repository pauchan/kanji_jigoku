//
//  PRExampleExtension.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/07/09.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation

extension Example {
    
    func generateDescriptionString() -> NSAttributedString {
        
        var description = ""
        if self.code == 1 {
        
           description.append(kPRstarCharacter)
        }
        description += self.example
        
        var attributedText = NSMutableAttributedString(string: description, attributes: kPRKanjiJigokuAttributedBoldBig)
        let attributedText2 = NSAttributedString(string: " 【" + self.reading + "】", attributes: kPRKanjiJigokuAttributedSmall)
        attributedText.appendAttributedString(attributedText2)
        return attributedText
        
    }
    
}
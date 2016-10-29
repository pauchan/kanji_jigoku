//
//  Example.swift
//  
//
//  Created by Pawel Rusin on 1/30/16.
//
//

import Foundation
import CoreData


class Example: Testable {

    func generateDescriptionString() -> NSMutableAttributedString {
        
        let attributedText = NSMutableAttributedString(string: self.example!, attributes: kPRKanjiJigokuAttributedBoldBig)
        let attributedText2 = NSAttributedString(string: " 【" + self.reading! + "】", attributes: kPRKanjiJigokuAttributedSmall)
        
        attributedText.append(attributedText2)
        return attributedText
        
    }
    
    func markIfImportant(_ text: String) -> NSAttributedString {
        
        if self.code!.range(of: "1") != nil {
            
            let newString = String(kPRstarCharacter) + " " + text
            return NSMutableAttributedString(string: newString)
        } else {
            
            return NSAttributedString(string: text)
        }
    }
}

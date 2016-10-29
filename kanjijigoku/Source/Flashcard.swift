//
//  FlashcardSet.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/13.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation

enum FlashcardType: Int {
    
    case kunyomi = 0, onyomi, example, sentence
}

class Flashcard
{

    var text : String = ""
    var reading : String = ""
    var meaning : String = ""
    var furiganaReading : NSAttributedString!
    var type : FlashcardType

    init(text :String, reading: String, meaning: String, type: FlashcardType)
    {
        //self.init()
        self.text = text
        self.reading = reading
        self.meaning = meaning
        self.furiganaReading = NSAttributedString(string: self.reading)
        self.type = type
    }
    

}


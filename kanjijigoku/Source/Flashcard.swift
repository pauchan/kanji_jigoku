//
//  FlashcardSet.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/13.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation

class Flashcard
{

    var text : String = ""
    var reading : String = ""
    var meaning : String = ""
    var furiganaReading : NSAttributedString!

    init(text :String, reading: String, meaning: String)
    {
        //self.init()
        self.text = text
        self.reading = reading
        self.meaning = meaning
        self.furiganaReading = NSAttributedString(string: self.reading)
    }
    

}


//
//  Question.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/17.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import Foundation

class Question
{

    var question = ""
    var meaning = ""
    var options = [String]()
    var properAnswerIndex : Int = 0
    var questionSummaryString : NSMutableAttributedString = NSMutableAttributedString()
    
    init(question: String, correctOption: String, falseOptions: [String], meaning: String){
    
        self.properAnswerIndex = Int(arc4random_uniform(3))
        self.question = question
        self.meaning = meaning
        self.options = [String](repeating: correctOption, count: 4)
        var j = 0
        for i in 0...3
        {
            if i != self.properAnswerIndex
            {
                options[i] = falseOptions[j]
                j += 1
            }
        }
    }

}

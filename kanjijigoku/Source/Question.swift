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
    var options = [String]()
    var properAnswerIndex : Int = 0
    
    init(question: String, options: [String], properAnswerIndex : Int){
    
        self.question = question
        self.options = options
        self.properAnswerIndex = properAnswerIndex
    }

}
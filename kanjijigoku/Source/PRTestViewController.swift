//
//  PRTestViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/16.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRTestViewController: UIViewController {
    
    
    var questions : [Question]!
    
    @IBOutlet var testOptionButtons: [UIButton]!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var testProgressLabel: UIProgressView!
    @IBOutlet weak var answerLabel: UILabel!
    
}

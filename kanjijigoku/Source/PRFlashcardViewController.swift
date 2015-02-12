//
//  PRFlashcardViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/10.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit
import CoreData

class PRFlashcardViewController : UIViewController {

    var name = ""
    var reading = ""
    var meaning = ""
    
    
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    
    //var flashcard : Character = Character()
    
    var tapCount : Int = 0;
    
    override func viewDidLoad() {
        
        characterLabel?.text = "test" //name
        readingLabel?.text = "test" //name
        meaningLabel?.text = meaning
        //super.viewDidLoad()

    }
    
    @IBAction func tapReceived(sender: UITapGestureRecognizer) {
        
        tapCount++
        if tapCount == 1
        {
            readingLabel.hidden = false
        }
        else if tapCount == 2
        {
            readingLabel.hidden = false
        }
        else
        {
            // do nothing
        }
        
    }


}

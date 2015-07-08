//
//  PRFlashcardViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/10.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit
import CoreData

class PRFlashcardViewController : UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var characterLabel: UILabel!
    
    
    @IBOutlet weak var readingLabel: PRFuriganaLabel!
    
    
    @IBOutlet weak var meaningLabel: UILabel!
    
    var flashcard : Flashcard! 
    
    var tapCount : Int = 0;
    
    override func viewDidLoad() {
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapReceived:")
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        characterLabel?.adjustsFontSizeToFitWidth = true
        characterLabel?.text = flashcard.text
        readingLabel?.furiganaText = flashcard.furiganaReading
        meaningLabel?.text = flashcard.meaning

    }
    
    func tapReceived(sender: UITapGestureRecognizer) {
        
        tapCount++
        if tapCount == 1
        {
            readingLabel?.hidden = false
        }
        else if tapCount == 2
        {
            meaningLabel?.hidden = false
        }
        else
        {
            // do nothing
        }
        
    }


}

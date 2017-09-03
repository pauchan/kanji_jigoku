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
    
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var spellingLabel: UILabel!
    @IBOutlet weak var readingLabel: PRFuriganaLabel!
    @IBOutlet weak var meaningLabel: UILabel!
    
    var flashcard : Flashcard! 
    
    var tapCount : Int = 0;
    
    override func viewDidLoad() {
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PRFlashcardViewController.tapReceived(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        textLabel.text = flashcard.text
        spellingLabel.text = flashcard.reading
        readingLabel.furiganaText = flashcard.text.furiganaExtractedSentence()
        meaningLabel.text = flashcard.meaning
        
        if flashcard.type == .sentence {
            textLabel.isHidden = true
            spellingLabel.isHidden = true
        } else {
            readingLabel.removeFromSuperview()
        }
    }

    func tapReceived(_ sender: UITapGestureRecognizer) {
        
        tapCount += 1
        if tapCount == 1 {
            if flashcard.type == .sentence {
                //readingLabel?.furiganaText = flashcard.furiganaReading
                readingLabel?.furiganaText = flashcard.text.furiganaExplainedSentence()
                readingLabel?.setNeedsDisplay()
            } else {
                spellingLabel.isHidden = false
            }
        }
        else if tapCount == 2 {
            meaningLabel?.isHidden = false
        }
        else {
            // do nothing
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
//        characterLabel.font = characterLabel.fontSizeToFitView(UIFont().appFontOfSize(36.0), text: flashcard.text)
        meaningLabel?.font = meaningLabel.fontSizeToFitView(UIFont.systemFont(ofSize: 22.0), text: flashcard.meaning)

    }
    



}

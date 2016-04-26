//
//  PRInitController.swift
//  kanjijigoku
//
//  Created by Pawel Rusin on 7/18/15.
//  Copyright (c) 2015 Pawel Rusin. All rights reserved.
//

import UIKit

let kLabelHorizontalMargin: CGFloat = 10.0

protocol FinishedLoadingDelegate {
 
    func splashDidFinishLoading(message: String?)
}

class PRInitController: UIViewController {

    var delegate: FinishedLoadingDelegate?
    
    override func viewDidLoad() {
        
        let view = NSBundle.mainBundle().loadNibNamed("LaunchScreen", owner: self, options: nil).first! as! UIView
        let label = UILabel(frame: CGRectMake(kLabelHorizontalMargin, SCREEN_HEIGHT-100.0*scaleForDevice, SCREEN_WIDTH-2*kLabelHorizontalMargin, 30.0*scaleForDevice))
        label.text = "Trwa aktualizowanie danych..."
        label.font = UIFont().appFontOfSize(20.0)
        label.textAlignment = .Center
        
        UIView.animateWithDuration(3.0, delay: 0.0, options: [.Repeat, .Autoreverse] , animations: { () -> Void in
            
            label.alpha = 0.0
            }, completion: nil)

        view.addSubview(label)
        
        let explanationLabel = UILabel(frame: CGRectMake(kLabelHorizontalMargin, SCREEN_HEIGHT-50.0*scaleForDevice, SCREEN_WIDTH-2*kLabelHorizontalMargin, 40.0*scaleForDevice))
        explanationLabel.text = "(W zależności od połączenia internetowego ładowanie może potrwać do kilku minut)"
        explanationLabel.textAlignment = .Center
        explanationLabel.lineBreakMode = .ByWordWrapping
        explanationLabel.numberOfLines = 0
        explanationLabel.font = UIFont().appFontOfSize(10.0)
        view.addSubview(explanationLabel)
        
        self.view = view
    }
    
    override func viewDidAppear(animated: Bool) {
        
        var message: String?
        if NSUserDefaults.standardUserDefaults().objectForKey("PRKanjiJigokuAutoDbUpdate") == nil || NSUserDefaults.standardUserDefaults().objectForKey("PRKanjiJigokuAutoDbUpdate") as! Bool == true
        {
            debugLog("syncing database")
//            message = PRDatabaseHelper().syncDatabase()
            let operationQueue = NSOperationQueue()
            let importOperation = ImportOperation()
            importOperation.completionBlock = {
                
                // delegate method
                let stateSingleton : PRStateSingleton = PRStateSingleton.sharedInstance
                stateSingleton.levelArray = PRDatabaseHelper().getLevelArray()
                stateSingleton.lessonArray = PRDatabaseHelper().getLessonArray(stateSingleton.currentLevel)
                
                self.delegate?.splashDidFinishLoading(importOperation.updateMessage)
            }
            operationQueue.addOperation(importOperation)
        } else {
            debugLog("dont auto-update db...")
        }
    }
    
}

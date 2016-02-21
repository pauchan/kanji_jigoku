//
//  PRInitController.swift
//  kanjijigoku
//
//  Created by Pawel Rusin on 7/18/15.
//  Copyright (c) 2015 Pawel Rusin. All rights reserved.
//

import UIKit

protocol FinishedLoadingDelegate {
 
    func splashDidFinishLoading()
}

class PRInitController: UIViewController {

    var delegate: FinishedLoadingDelegate?
    
    override func viewDidLoad() {
        
        let view = NSBundle.mainBundle().loadNibNamed("LaunchScreen", owner: self, options: nil).first! as! UIView
        let label = UILabel(frame: CGRectMake(0.0, SCREEN_HEIGHT-100.0, SCREEN_WIDTH, 30.0))
        label.text = "Trwa aktualizowanie danych..."
        label.font = UIFont().appFontOfSize(20.0)
        label.textAlignment = .Center
        
        UIView.animateWithDuration(3.0, delay: 0.0, options: [.Repeat, .Autoreverse] , animations: { () -> Void in
            
            label.alpha = 0.0
            }, completion: nil)

        view.addSubview(label)
        
        let explanationLabel = UILabel(frame: CGRectMake(0.0, SCREEN_HEIGHT-50.0, SCREEN_WIDTH, 40.0))
        explanationLabel.text = "(W zależności od połączenia internetowego ładowanie może potrwać do kilku minut)"
        explanationLabel.textAlignment = .Center
        explanationLabel.lineBreakMode = .ByWordWrapping
        explanationLabel.numberOfLines = 0
        explanationLabel.font = UIFont().appFontOfSize(10.0)
        view.addSubview(explanationLabel)
        
        self.view = view
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if NSUserDefaults.standardUserDefaults().objectForKey("PRKanjiJigokuAutoDbUpdate") == nil || NSUserDefaults.standardUserDefaults().objectForKey("PRKanjiJigokuAutoDbUpdate") as! Bool == true
        {
            debugLog("syncing database")
            PRDatabaseHelper().syncDatabase()
        } else {
            debugLog("dont auto-update db...")
        }
        // delegate method
        let stateSingleton : PRStateSingleton = PRStateSingleton.sharedInstance
        stateSingleton.levelArray = PRDatabaseHelper().getLevelArray()
        stateSingleton.lessonArray = PRDatabaseHelper().getLessonArray(stateSingleton.currentLevel)
        
        delegate?.splashDidFinishLoading()
    }
    
}

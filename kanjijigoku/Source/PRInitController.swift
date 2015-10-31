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
        let label = UILabel(frame: CGRectMake(0.0, 500.0, SCREEN_WIDTH, 30.0))
        label.text = "Trwa ładowanie bazy danych..."
        label.textAlignment = .Center
        UIView.animateWithDuration(3.0, delay: 0.0,
            options: .Repeat, animations: {
                label.alpha = 0.0
                label.alpha = 1.0
            }, completion: nil)
        
        
        view.addSubview(label)
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
        delegate?.splashDidFinishLoading()
    }
    
}

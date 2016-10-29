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
 
    func splashDidFinishLoading(_ message: String?)
}

class PRInitController: UIViewController {

    var delegate: FinishedLoadingDelegate?
    
    override func viewDidLoad() {
        
        let view = Bundle.main.loadNibNamed("LaunchScreen", owner: self, options: nil)?.first! as! UIView
        let label = UILabel(frame: CGRect(x: kLabelHorizontalMargin, y: SCREEN_HEIGHT-100.0*scaleForDevice, width: SCREEN_WIDTH-2*kLabelHorizontalMargin, height: 30.0*scaleForDevice))
        label.text = "Trwa aktualizowanie danych..."
        label.font = UIFont().appFontOfSize(20.0)
        label.textAlignment = .center
        
        UIView.animate(withDuration: 3.0, delay: 0.0, options: [.repeat, .autoreverse] , animations: { () -> Void in
            
            label.alpha = 0.0
            }, completion: nil)

        view.addSubview(label)
        
        let explanationLabel = UILabel(frame: CGRect(x: kLabelHorizontalMargin, y: SCREEN_HEIGHT-50.0*scaleForDevice, width: SCREEN_WIDTH-2*kLabelHorizontalMargin, height: 40.0*scaleForDevice))
        explanationLabel.text = "(W zależności od połączenia internetowego ładowanie może potrwać do kilku minut)"
        explanationLabel.textAlignment = .center
        explanationLabel.lineBreakMode = .byWordWrapping
        explanationLabel.numberOfLines = 0
        explanationLabel.font = UIFont().appFontOfSize(10.0)
        view.addSubview(explanationLabel)
        
        self.view = view
    }
    
    override func viewDidAppear(_ animated: Bool) {
        

    }
    
}

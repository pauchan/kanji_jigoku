//
//  PRTestsViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/10.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRTestMenuViewController : UITableViewController
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "settings")
        self.navigationItem.title = "Kanji Jigoku"
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
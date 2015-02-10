//
//  ViewController.swift
//  kanjijigoku
//
//  Created by Pawel Rusin on 2/7/15.
//  Copyright (c) 2015 Pawel Rusin. All rights reserved.
//

import UIKit

class PRKanjiMenuViewController: UITableViewController
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



//let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//let managedContext = appDelegate.managedObjectContext!
//let fetchRequest = NSFetchRequest(entityName: "Character")
//
//var error : NSError?
//let fetchedRequest = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
//
//if let results = fetchedRequest as? [Character]
//{
//    println("succeeded")
//    println(results.count)
//    for ch in results
//    {
//        println(ch.kanji)
//    }
//}
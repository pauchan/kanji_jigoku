//
//  PRKanjiTableViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/19.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRKanjiTableViewController: UITableViewController {
    
    var kanji : Character!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PRKanjiCell")


    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        switch(section)
        {
        case 0:
            // TODO!!!!
            return 0
        case 1:
            if kanji.kunyomis.count > 0 && kanji.onyomis.count > 0
            {
                return 2
            }
            else
            {
                return 1
            }
        case 2:
            return kanji.examples.count
        case 3:
            // TODO!!!!
            return 0
        case 4:
            return kanji.sentences.count
        default:
            return 0
        
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch(indexPath.section)
        {
        case 0:
            
                return tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as UITableViewCell
            
        case 1:
            if indexPath.row == 0
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as UITableViewCell
                let arr = kanji.kunyomis.allObjects as [Kunyomi]
                cell.textLabel?.text = arr.map {
                    (kunyomi) -> String in kunyomi.reading
                    }.reduce(""){
                
                    (base,append) in base! + append
                }
            }
            else
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as UITableViewCell
                let arr = kanji.onyomis.allObjects as [Onyomi]
                cell.textLabel?.text = arr.map {
                    (onyomi) -> String in onyomi.reading
                    }.reduce(""){
                        
                        (base,append) in base! + append + ", "
                }
            }
        case 2:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as UITableViewCell
            let example = kanji.examples.allObjects as [Example]
            cell.textLabel?.text = example[indexPath.row].example
        case 3:
            return tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as UITableViewCell
        case 4:
            let cell = tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as UITableViewCell
            let sentence = kanji.sentences.allObjects as [Sentence]
            cell.textLabel?.text = sentence[indexPath.row].sentence
        default:
            return tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as UITableViewCell

        
        }
        return tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as UITableViewCell


    }
    
    
}

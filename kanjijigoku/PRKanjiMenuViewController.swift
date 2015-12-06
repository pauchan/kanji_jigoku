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
    var _headerCoordinator : PRHeaderCoordinator!
    var _kanjiTable : [Kanji]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "SettingsIcon"), style: .Plain,  target: self, action: "prKanjiJigokuRightBarItemShowSettings:")
        self.navigationItem.title = "Kanji Jigoku"
        
        let nib : UINib = UINib(nibName: "PRHeaderViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "PRHeaderViewCell")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PRKanjiCell")
        self.tableView.tableFooterView = UIView()
                
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "lessonUpdated:", name: "PRKanjiJigokuLessonUpdated", object: nil)
}

override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
{
    
    if indexPath.section == 0
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PRHeaderViewCell", forIndexPath: indexPath) as! PRHeaderViewCell
        _headerCoordinator = PRHeaderCoordinator(headerCell: cell)
        cell.contentView.userInteractionEnabled = false
        cell.selectionStyle = .None
        return cell
    }
    else
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) 
        cell.textLabel?.text = _kanjiTable[indexPath.row].kanji
        return cell
    }
}

override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
{
    if indexPath.section != 0
    {
        
        let vc = PRKanjiPageViewController()
        vc._kanjiTable = _kanjiTable
        vc._selectedIndex = indexPath.row
        navigationController?.pushViewController(vc, animated: false)
    }
    
}


override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
    if indexPath.section == 0 && indexPath.row == 0
    {
        return 90.0
    }
    else
    {
        return 45.0
    }
}

override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
{
    if(section == 0)
    {
        return 1
    }
    else
    {
        return _kanjiTable.count
    }
}
override func numberOfSectionsInTableView(tableView: UITableView) -> Int
{
    return 2
}

func lessonUpdated(notification: NSNotification)
{
        print("notification called")
        _kanjiTable = PRDatabaseHelper().getSelectedObjects("Kanji", level: PRStateSingleton.sharedInstance.currentLevel, lesson: PRStateSingleton.sharedInstance.currentLesson) as! [Kanji]
        self.tableView.reloadData()
}

    
}

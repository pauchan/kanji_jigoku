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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "SettingsIcon"), style: .plain,  target: self, action: "prKanjiJigokuRightBarItemShowSettings:")
        self.navigationItem.title = "Słownik"
        
        let nib : UINib = UINib(nibName: "PRHeaderViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "PRHeaderViewCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PRKanjiCell")
        self.tableView.tableFooterView = UIView()
                
        NotificationCenter.default.addObserver(self, selector: #selector(PRKanjiMenuViewController.lessonUpdated(_:)), name: NSNotification.Name(rawValue: "PRKanjiJigokuLessonUpdated"), object: nil)
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self._headerCoordinator?.updateHeaderState()
    }

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
{
    if (indexPath as NSIndexPath).section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PRHeaderViewCell", for: indexPath) as! PRHeaderViewCell
        _headerCoordinator = PRHeaderCoordinator(headerCell: cell)
        cell.contentView.isUserInteractionEnabled = false
        cell.selectionStyle = .none
        return cell
    } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PRKanjiCell", for: indexPath) 
        cell.textLabel?.text = _kanjiTable[(indexPath as NSIndexPath).row].kanji //  "\u{2B1B}"  //
        cell.textLabel?.font = UIFont().appFontOfSize(12.0)
        cell.selectionStyle = .none
        return cell
    }
}

override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
{
    if (indexPath as NSIndexPath).section != 0 {
        let vc = PRKanjiPageViewController()
        vc._kanjiTable = _kanjiTable
        vc._selectedIndex = (indexPath as NSIndexPath).row
        navigationController?.pushViewController(vc, animated: false)
    }
}


override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
{
    if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 0 {
        return 90.0 * scaleForDevice
    } else {
        return 45.0 * scaleForDevice
    }
}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
{
    if(section == 0) {
        return 1
    } else {
        return _kanjiTable.count
    }
}
override func numberOfSections(in tableView: UITableView) -> Int
{
    return 2
}

func lessonUpdated(_ notification: Notification)
{
        print("notification called")
        _kanjiTable = PRDatabaseHelper().getSelectedObjects("Kanji", level: PRStateSingleton.sharedInstance.currentLevel, lesson: PRStateSingleton.sharedInstance.currentLesson) as! [Kanji]
        self.tableView.reloadData()
}
    
}

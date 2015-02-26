//
//  PRSearchKanjiViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/25.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRSearchKanjiViewController: UIViewController, UITableViewDelegate, UITableViewDataSource


{
    @IBOutlet weak var kanjiSearchTable: UITableView!
    
    var kunyomiSearchArray : [Kunyomi]!
    var sentenceSearchArray : [Sentence]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        kanjiSearchTable.delegate = self
        kanjiSearchTable.dataSource = self

        // Do any additional setup after loading the view.
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as UITableViewCell
            //_headerCoordinator = PRHeaderCoordinator(headerCell: cell)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as UITableViewCell
            //cell.textLabel?.text = _kanjiTable[indexPath.row].kanji
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.section != 0
        {
            
            var vc = PRKanjiPageViewController()
            //vc._kanjiTable = _kanjiTable
            vc._selectedIndex = indexPath.row
            navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 60.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(section == 0)
        {
            return kunyomiSearchArray.count
        }
        else
        {
            return sentenceSearchArray.count
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }
    
    


}

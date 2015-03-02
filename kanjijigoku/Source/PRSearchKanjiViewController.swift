//
//  PRSearchKanjiViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/25.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRSearchKanjiViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    @IBOutlet weak var kanjiSearchTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var kunyomiSearchArray : [Kunyomi] = [Kunyomi]()
    var sentenceSearchArray : [Sentence] = [Sentence]()
 
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        kanjiSearchTable.delegate = self
        kanjiSearchTable.dataSource = self
        
        searchBar.delegate = self

        // Do any additional setup after loading the view.
        kanjiSearchTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PRKanjiCell")

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
            cell.textLabel.text = sentenceSearchArray[indexPath.row].sentence
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
        return 1
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        
        sentenceSearchArray = PRDatabaseHelper().fetchSentencesContainingKanji(searchBar.text)
        println("search array count \(sentenceSearchArray.count)")
        kanjiSearchTable.reloadData()
        
        
    }

}

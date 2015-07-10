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
    
    
    var characterSearchArray : [Kanji] = [Kanji]()
    var exampleSearchArray : [Example] = [Example]()
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "SettingsIcon"), style: .Plain,  target: self, action: "prKanjiJigokuRightBarItemShowSettings:")
        self.navigationItem.title = "Szukaj"
        
        kanjiSearchTable.delegate = self
        kanjiSearchTable.dataSource = self
        
        searchBar.delegate = self

        // Do any additional setup after loading the view.
        kanjiSearchTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PRKanjiCell")
        kanjiSearchTable.registerClass(PRDetailedKanjiCell.self, forCellReuseIdentifier: "PRDetailedKanjiCell")

        
        kanjiSearchTable.tableFooterView = UIView()


    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = characterSearchArray[indexPath.row].kanji
            return cell
        }
        else if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("PRDetailedKanjiCell", forIndexPath: indexPath) as! PRDetailedKanjiCell
            cell.textLabel?.attributedText = exampleSearchArray[indexPath.row].generateDescriptionString()
            cell.detailTextLabel?.text = exampleSearchArray[indexPath.row].meaning
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("PRDetailedKanjiCell", forIndexPath: indexPath) as! PRDetailedKanjiCell
            cell.textLabel?.text = sentenceSearchArray[indexPath.row].getExplainedSentence().string
            cell.detailTextLabel?.text = sentenceSearchArray[indexPath.row].meaning
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
        if section == 0
        {
            return characterSearchArray.count
        }
        else if section == 1
        {
            return exampleSearchArray.count
        }
        else
        {
            return sentenceSearchArray.count
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 3
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section
        {
        case 0:
            return "Kanji"
        case 1:
            return "Zlozenia"
        case 2:
            return "Zdania"
        default:
            return ""
        }
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        switch section
        {
        case 0:
            return characterSearchArray.count > 0 ? 30 : 0
        case 1:
            return exampleSearchArray.count > 0 ? 30 : 0
        case 2:
            return sentenceSearchArray.count > 0 ? 30 : 0
        default:
            return 0
        }
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        
        characterSearchArray = PRDatabaseHelper().fetchObjectsContainingPhrase("Kanji", phrase: searchBar.text) as! [Kanji]
        exampleSearchArray = PRDatabaseHelper().fetchObjectsContainingPhrase("Example", phrase: searchBar.text) as! [Example]
        sentenceSearchArray = PRDatabaseHelper().fetchObjectsContainingPhrase("Sentence", phrase: searchBar.text) as! [Sentence]
        println("character array count \(characterSearchArray.count)")
        println("example array count \(exampleSearchArray.count)")
        println("search array count \(sentenceSearchArray.count)")
        kanjiSearchTable.reloadData()
        searchBar.resignFirstResponder()
        
        
    }

}

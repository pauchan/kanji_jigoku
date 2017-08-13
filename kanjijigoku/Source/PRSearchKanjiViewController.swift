//
//  PRSearchKanjiViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/25.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRSearchKanjiViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    @IBOutlet weak var kanjiSearchTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var characterSearchArray : [Kanji] = [Kanji]()
    var exampleSearchArray : [Example] = [Example]()
    var sentenceSearchArray : [Sentence] = [Sentence]()
 
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "SettingsIcon"), style: .plain,  target: self, action: "prKanjiJigokuRightBarItemShowSettings:")
        self.navigationItem.title = "Szukaj"
        
        kanjiSearchTable.delegate = self
        kanjiSearchTable.dataSource = self
        
        kanjiSearchTable.emptyDataSetSource = self
        kanjiSearchTable.emptyDataSetDelegate = self
        
        searchBar.delegate = self

        // Do any additional setup after loading the view.
        kanjiSearchTable.register(UITableViewCell.self, forCellReuseIdentifier: "PRKanjiCell")
        kanjiSearchTable.register(PRDetailedKanjiCell.self, forCellReuseIdentifier: "PRDetailedKanjiCell")

        
        kanjiSearchTable.tableFooterView = UIView()


    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if (indexPath as NSIndexPath).section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PRKanjiCell", for: indexPath) 
            cell.textLabel?.text = characterSearchArray[(indexPath as NSIndexPath).row].kanji
            return cell
        }
        else if (indexPath as NSIndexPath).section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PRDetailedKanjiCell", for: indexPath) as! PRDetailedKanjiCell
            cell.textLabel?.attributedText = exampleSearchArray[(indexPath as NSIndexPath).row].generateDescriptionString()
            cell.detailTextLabel?.text = exampleSearchArray[(indexPath as NSIndexPath).row].meaning
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PRDetailedKanjiCell", for: indexPath) as! PRDetailedKanjiCell
            cell.textLabel?.text = sentenceSearchArray[(indexPath as NSIndexPath).row].replaceExplainedSentence()
            cell.detailTextLabel?.text = sentenceSearchArray[(indexPath as NSIndexPath).row].meaning
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var selectedKanji: Kanji? = nil
        if (indexPath as NSIndexPath).section == 0 // if its kanji, 
        {
            selectedKanji = characterSearchArray[(indexPath as NSIndexPath).row]
            
        } else if (indexPath as NSIndexPath).section == 1 {
        
            selectedKanji = exampleSearchArray[(indexPath as NSIndexPath).row].character
        }else if (indexPath as NSIndexPath).section == 2 {
            
            selectedKanji = sentenceSearchArray[(indexPath as NSIndexPath).row].character
        }
        let vc = PRKanjiPageViewController()
        vc._kanjiTable = PRDatabaseHelper().getSelectedObjects("Kanji", level: Int(selectedKanji!.level), lesson: Int(selectedKanji!.lesson)) as! [Kanji]
        vc._selectedIndex = vc._kanjiTable.index(of: selectedKanji!)!
        navigationController?.pushViewController(vc, animated: false)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath as NSIndexPath).section == 0 {
        
            return 30.0 * scaleForDevice
        } else {
        
            var text = ""
            var detailedText = ""
            if (indexPath as NSIndexPath).section == 1 {
                text = exampleSearchArray[(indexPath as NSIndexPath).row].generateDescriptionString().string
                detailedText = exampleSearchArray[(indexPath as NSIndexPath).row].meaning! + " " + exampleSearchArray[(indexPath as NSIndexPath).row].note!.removeReferenceSubstring()
            }
            else { // == .Sentences
                text = sentenceSearchArray[(indexPath as NSIndexPath).row].replaceExplainedSentence()
                detailedText = sentenceSearchArray[(indexPath as NSIndexPath).row].meaning!
            }
            
            let font = UIFont().appFontOfSize(15.0)
            let detailedFont = UIFont().appFontOfSize(12.0)
            let constraintsSize = CGSize(width: tableView.bounds.size.width, height: CGFloat(MAXFLOAT))
            let labelSize = text.boundingRect(with: constraintsSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
            let detailedLabelSize = detailedText.boundingRect(with: constraintsSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: detailedFont], context: nil)
            
            return labelSize.height + detailedLabelSize.height + 20.0
        
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
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
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
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
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
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
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        
        characterSearchArray = PRDatabaseHelper().fetchObjectsContainingPhrase("Kanji", phrase: searchBar.text!) as! [Kanji]
        exampleSearchArray = PRDatabaseHelper().fetchObjectsContainingPhrase("Example", phrase: searchBar.text!) as! [Example]
        sentenceSearchArray = PRDatabaseHelper().fetchObjectsContainingPhrase("Sentence", phrase: searchBar.text!) as! [Sentence]
        kanjiSearchTable.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Możliwe tryby wyszukiwania"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Wyszukiwanie znaków: 金, 食べる, 連絡 \n" +
        "Wyszukiwanie na postawie kany: かね, たべる, れんらく \n" +
        "Wyszukiwanie na podstawie czytania fonetycznego: kane, taberu, renraku \n" +
        "Wyszukiwanie znaczeń: pieniądze, jeść, kontakt \n"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }

}

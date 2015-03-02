//
//  PRKanjiTableViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/19.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

enum PRKanjiJigokuKanjiOptions : Int
{
    case RelatedKanijs=0, Summary, Notes , Kunyomi, Onyomi, Examples, AdditionalExamples, Sentences
}

class PRKanjiTableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var kanji : Character!
    var additionalExamples : [Example]!
    var relatedKanjis : [Character]!
    var tableView : UITableView!
    var pageControl : PRKanjiPageControl!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        println("navigation controller: \(self.navigationController?.description)")
        println("navigation controller: \(self.navigationItem.description)")
        println("navigation controller: \(self.navigationController?.navigationBar.description)")
        println("navigation controller: \(self.navigationController?.navigationBarHidden)")
        if self.navigationController != nil
        {
            self.tableView = UITableView(frame: CGRectMake(0, 0.0, self.view.frame.size.width, self.view.frame.size.height*0.85))
        }
        else
        {
            self.tableView = UITableView(frame: CGRectMake(0, 64.0, self.view.frame.size.width, self.view.frame.size.height*0.85))
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        pageControl.setupView(CGRectMake(0, self.view.frame.size.height*0.85, self.view.frame.size.width, self.view.frame.size.height*0.15))
        self.view.addSubview(pageControl)
        
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PRKanjiCell")
        
        let nib : UINib = UINib(nibName: "PRKanjiTableViewHeaderCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "PRKanjiHeaderCell")

        let nib2 : UINib = UINib(nibName: "PRRelatedKanjiCell", bundle: nil)
        self.tableView.registerNib(nib2, forCellReuseIdentifier: "PRRelatedKanjiCell")
        
        additionalExamples = PRDatabaseHelper().fetchAdditionalExamples(kanji.kanji)
        if kanji.relatedKanji.isEmpty
        {
            relatedKanjis = [Character]()
        }
        else
        {
            relatedKanjis = PRDatabaseHelper().fetchRelatedKanjis(kanji)
        }
        
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0.0, 0.0, self.view.frame.size.width, 45.0))
        //self.tableView.tableHeaderView = pageControl
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 8
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch(section)
        {
        case PRKanjiJigokuKanjiOptions.RelatedKanijs.rawValue:
            return relatedKanjis.count > 0 ? 1 : 0
        case PRKanjiJigokuKanjiOptions.Summary.rawValue:
            return 1
        case PRKanjiJigokuKanjiOptions.Notes.rawValue:
            return kanji.note.isEmpty ? 0 : 1
        case PRKanjiJigokuKanjiOptions.Kunyomi.rawValue:
            return kanji.kunyomis.count > 0  ? 1 : 0
        case PRKanjiJigokuKanjiOptions.Onyomi.rawValue:
            return kanji.onyomis.count > 0  ? 1 : 0
        case PRKanjiJigokuKanjiOptions.Examples.rawValue:
            return kanji.examples.count
        case PRKanjiJigokuKanjiOptions.AdditionalExamples.rawValue:
            return additionalExamples.count
        case PRKanjiJigokuKanjiOptions.Sentences.rawValue:
            return kanji.sentences.count
        default:
            return 0
        
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch(indexPath.section)
        {
        case PRKanjiJigokuKanjiOptions.RelatedKanijs.rawValue:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("PRRelatedKanjiCell", forIndexPath: indexPath) as PRRelatedKanjiCell
            cell.relatedKanjiCollectionview.delegate = self
            cell.relatedKanjiCollectionview.dataSource = self
            cell.relatedKanjiCollectionview.backgroundColor = UIColor.whiteColor()
            cell.relatedKanjiCollectionview.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
            return cell
            
        case PRKanjiJigokuKanjiOptions.Summary.rawValue:

            let headerCell = tableView.dequeueReusableCellWithIdentifier("PRKanjiHeaderCell", forIndexPath: indexPath) as PRKanjiTableViewHeaderCell
            headerCell.kanjiLabel.text = kanji.kanji
            
            var arr = kanji.radicals.allObjects as [Radical]  //.allObjects as [Radical]
            let radicalsString = arr.map
            {
                (radical : Radical) -> String in radical.radical
                
            }.reduce("")
            {
                    (base,append) in base + append
            }
            
            headerCell.detailsLabel.text = " \(kanji.strokeCount)画 【\(radicalsString)】"
            headerCell.explanationLabel.text = kanji.meaning
            return headerCell
            
        case PRKanjiJigokuKanjiOptions.Notes.rawValue:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = kanji.note
            return cell
            
        case PRKanjiJigokuKanjiOptions.Kunyomi.rawValue:


                let cell = tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as UITableViewCell
                let arr = kanji.kunyomis.allObjects as [Kunyomi]
                cell.textLabel?.text = arr.map {
                    (kunyomi) -> String in kunyomi.reading
                    }.reduce(""){
                
                    (base,append) in base! + append
                }
                return cell

        case PRKanjiJigokuKanjiOptions.Onyomi.rawValue:
                let cell = tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as UITableViewCell
                let arr = kanji.onyomis.allObjects as [Onyomi]
                cell.textLabel?.text = arr.map {
                    (onyomi) -> String in onyomi.reading
                    }.reduce(""){
                        
                        (base,append) in base! + append + ", "
                }
                return cell
            
        case PRKanjiJigokuKanjiOptions.Examples.rawValue:
            
            var cell  : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("PRKanjiCell2") as? UITableViewCell
            if cell == nil
            {
                cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "PRKanjiCell2")
                cell!.selectionStyle = UITableViewCellSelectionStyle.None;
            }
            let example = kanji.examples.allObjects as [Example]
            var attributedText = NSMutableAttributedString(string: example[indexPath.row].example, attributes: kPRKanjiJigokuHelveticaBoldTwenty)
            let attributedText2 = NSAttributedString(string: " 【" + example[indexPath.row].reading + "】", attributes: kPRKanjiJigokuHelveticaFourteen)
            attributedText.appendAttributedString(attributedText2)
            cell!.textLabel?.attributedText = attributedText
            cell!.detailTextLabel?.text = example[indexPath.row].meaning + " " + example[indexPath.row].note
            return cell!

        case PRKanjiJigokuKanjiOptions.AdditionalExamples.rawValue:
            var cell  : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("PRKanjiCell2") as? UITableViewCell
            if cell == nil
            {
                cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "PRKanjiCell2")
                cell!.selectionStyle = UITableViewCellSelectionStyle.None;
            }
            var attributedText = NSMutableAttributedString(string: additionalExamples[indexPath.row].example, attributes: kPRKanjiJigokuHelveticaBoldTwenty)
            let attributedText2 = NSAttributedString(string: " 【" + additionalExamples[indexPath.row].reading + "】", attributes: kPRKanjiJigokuHelveticaFourteen)
            attributedText.appendAttributedString(attributedText2)
            cell!.textLabel?.attributedText = attributedText
            cell!.detailTextLabel?.text = additionalExamples[indexPath.row].meaning + " " + additionalExamples[indexPath.row].note
            return cell!
            
        case PRKanjiJigokuKanjiOptions.Sentences.rawValue:
            var cell  : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("PRKanjiCell2") as? UITableViewCell
            if cell == nil
            {
                cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "PRKanjiCell2")
                cell!.selectionStyle = UITableViewCellSelectionStyle.None
                cell!.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
                cell!.textLabel?.numberOfLines = 0
                //cell!.detailTextLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
                //cell!.detailTextLabel?.numberOfLines = 0
                
            }
            let sentence = kanji.sentences.allObjects as [Sentence]
            cell!.textLabel?.text =  sentence[indexPath.row].getExplainedSentence().string
            cell!.detailTextLabel?.text = sentence[indexPath.row].meaning
            //cell!.textLabel?.sizeToFit()
            //cell!.detailTextLabel?.sizeToFit()
            return cell!
        default:
            return tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as UITableViewCell

        
        }
        //return tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as UITableViewCell

    }
    
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == PRKanjiJigokuKanjiOptions.AdditionalExamples.rawValue || section == PRKanjiJigokuKanjiOptions.Sentences.rawValue
        {
            return 30.0
        }
        else
        {
            return 0.0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == PRKanjiJigokuKanjiOptions.AdditionalExamples.rawValue
        {
            return "Material z innych lekcji"
        }
        else if section == PRKanjiJigokuKanjiOptions.Sentences.rawValue
        {
            return "Szukaj znaku w zdaniach"
        }
        else
        {
            return ""
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == PRKanjiJigokuKanjiOptions.RelatedKanijs.rawValue || indexPath.section == PRKanjiJigokuKanjiOptions.Notes.rawValue
        {
                return 30.0
        }
        if indexPath.section == PRKanjiJigokuKanjiOptions.Kunyomi.rawValue || indexPath.section == PRKanjiJigokuKanjiOptions.Onyomi.rawValue
        {
            return 45.0
        }
        else if indexPath.section == PRKanjiJigokuKanjiOptions.Summary.rawValue
        {
            return 100.0
        }
        else
        {
            return 60.0
//            let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
//            var newBounds = cell.bounds
//            newBounds.size.width = tableView.bounds.width
//            cell.bounds = newBounds
//            
//            cell.setNeedsLayout()
//            cell.layoutIfNeeded()
//            return cell.preferredView.bounds.height
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath) as UICollectionViewCell
        let label = UILabel(frame: CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height))
        label.text = relatedKanjis[indexPath.row].kanji
        
        let onyomiSet = kanji.onyomis.allObjects as [Onyomi]
        let onyomiSet2 = relatedKanjis[indexPath.row].onyomis.allObjects as [Onyomi]
        
        let test = onyomiSet.map({
        
            (onyomi) -> String in onyomi.reading
        })
        
        let testBool = onyomiSet2.filter({
        
            (onyomi : Onyomi) in contains(test, onyomi.reading)
        })
        

        println("\(test.description)")
        println("\(testBool.description)")
        
        label.textColor = testBool.count > 0 ? UIColor.redColor() : UIColor.blueColor()
        
        cell.addSubview(label)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return relatedKanjis.count
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        let vc = PRKanjiTableViewController()
        vc.kanji  = relatedKanjis[indexPath.row] as Character
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
}

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
    
    var kanji : Kanji!
    var additionalExamples : [Example]!
    var relatedKanjis : [Kanji]!
    var tableView : UITableView!
    var pageControl : PRKanjiPageControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        if self.parentViewController != nil
        {
            println("there is navigation controller")
            self.parentViewController?.navigationController?.navigationBarHidden = true
            self.tableView = UITableView(frame: CGRectMake(0, 0.0, self.view.frame.size.width, self.view.frame.size.height*0.85))
        }
        else
        {
            println("no navigation controller")
            //self.parentViewController?.navigationController?.navigationBarHidden = true
            self.tableView = UITableView(frame: CGRectMake(0, 64.0, self.view.frame.size.width, self.view.frame.size.height*0.85))
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        pageControl.setupView(CGRectMake(0, self.view.frame.size.height*0.85, self.view.frame.size.width, self.view.frame.size.height*0.15))
        self.view.addSubview(pageControl)
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PRKanjiCell")
        self.tableView.registerClass(PRDetailedKanjiCell.self, forCellReuseIdentifier: "PRKanjiCell2")

        let nib : UINib = UINib(nibName: "PRKanjiTableViewHeaderCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "PRKanjiHeaderCell")
        
        let nib2 : UINib = UINib(nibName: "PRRelatedKanjiCell", bundle: nil)
        self.tableView.registerNib(nib2, forCellReuseIdentifier: "PRRelatedKanjiCell")
        
        additionalExamples = PRDatabaseHelper().fetchAdditionalExamples(kanji.kanji)
        if kanji.relatedKanji.isEmpty
        {
            relatedKanjis = [Kanji]()
        }
        else
        {
            relatedKanjis = PRDatabaseHelper().fetchRelatedKanjis(kanji)
        }
        
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0.0, 0.0, self.view.frame.size.width, 45.0))
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 8
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let displaySection: PRKanjiJigokuKanjiOptions = PRKanjiJigokuKanjiOptions(rawValue: section)!
        switch(displaySection)
        {
        case .RelatedKanijs:
            return relatedKanjis.count > 0 ? 1 : 0
        case .Summary:
            return 1
        case .Notes:
            return kanji.note.isEmpty ? 0 : 1
        case .Kunyomi:
            return kanji.kunyomis.count > 0  ? 1 : 0
        case .Onyomi:
            return kanji.onyomis.count > 0  ? 1 : 0
        case .Examples:
            return kanji.examples.count
        case .AdditionalExamples:
            return additionalExamples.count
        case .Sentences:
            println("sentences count: \(kanji.sentences.count)")
            return kanji.sentences.count
        default:
            return 0
            
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let displaySection: PRKanjiJigokuKanjiOptions = PRKanjiJigokuKanjiOptions(rawValue: indexPath.section)!
        switch(displaySection)
        {
        case .RelatedKanijs:
            debugLog("related kanji")
            let cell = tableView.dequeueReusableCellWithIdentifier("PRRelatedKanjiCell", forIndexPath: indexPath) as! PRRelatedKanjiCell
            cell.relatedKanjiCollectionview.delegate = self
            cell.relatedKanjiCollectionview.dataSource = self
            cell.relatedKanjiCollectionview.backgroundColor = UIColor.whiteColor()
            cell.relatedKanjiCollectionview.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
            return cell
            
        case .Summary:
            debugLog("summary")
            let headerCell = tableView.dequeueReusableCellWithIdentifier("PRKanjiHeaderCell", forIndexPath: indexPath) as! PRKanjiTableViewHeaderCell
            headerCell.kanjiLabel.text = kanji.kanji
            headerCell.detailsLabel.text = " \(kanji.strokeCount)画 【\(kanji.generateRadicalsString())】"
            headerCell.explanationLabel.text = kanji.meaning
            return headerCell
            
        case .Notes:
            debugLog("notes")
            let cell = tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = kanji.note
            return cell
            
        case .Kunyomi:
            debugLog("kunyomi")
            let cell = tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as! UITableViewCell
            let arr = kanji.kunyomis.allObjects as! [Kunyomi]
            cell.textLabel?.text = kanji.generateCommaSeparatedString(arr)
            return cell
            
        case .Onyomi:
            let cell = tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as! UITableViewCell
            let arr = kanji.onyomis.allObjects as! [Onyomi]
            cell.textLabel?.text = kanji.generateCommaSeparatedString(arr)
            return cell
            
        case .Examples:
            debugLog("examples")
            var cell = tableView.dequeueReusableCellWithIdentifier("PRKanjiCell2") as? PRDetailedKanjiCell
            let example = kanji.examples.allObjects as! [Example]
            let descriptionString = example[indexPath.row].generateDescriptionString()
            cell!.textLabel?.attributedText =  (PRStateSingleton.sharedInstance.filterOn) ? self.filterOutAdvancedKanji(descriptionString.string) : descriptionString
            cell!.detailTextLabel?.text = example[indexPath.row].meaning + " " + example[indexPath.row].note.removeReferenceSubstring()
            return cell!
            
        case .AdditionalExamples:
            debugLog("additional examples")
            var cell = tableView.dequeueReusableCellWithIdentifier("PRKanjiCell2") as? PRDetailedKanjiCell
            let descriptionString = additionalExamples[indexPath.row].generateDescriptionString()
            cell!.textLabel?.attributedText = (PRStateSingleton.sharedInstance.filterOn) ? self.filterOutAdvancedKanji(descriptionString.string) : descriptionString
            cell!.detailTextLabel?.text = additionalExamples[indexPath.row].meaning + " " + additionalExamples[indexPath.row].note.removeReferenceSubstring()
            return cell!
            
        case .Sentences:
            debugLog("sentences")
            var cell = tableView.dequeueReusableCellWithIdentifier("PRKanjiCell2") as? PRDetailedKanjiCell
            let sentence = kanji.sentences.allObjects as! [Sentence]
            println("explanation: \(sentence[indexPath.row].getExplainedSentence())")
            
            cell!.textLabel?.attributedText = (PRStateSingleton.sharedInstance.filterOn) ? self.filterOutAdvancedKanji(sentence[indexPath.row].getExplainedSentence().string) : NSAttributedString(string: sentence[indexPath.row].getExplainedSentence().string)
            cell!.detailTextLabel?.text = sentence[indexPath.row].meaning
            return cell!
        default:
            return tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as! UITableViewCell
        }
    }
    
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let displaySection: PRKanjiJigokuKanjiOptions = PRKanjiJigokuKanjiOptions(rawValue: section)!
        if displaySection == .AdditionalExamples
        {
            return additionalExamples.count > 0 ? 30.0 : 0.0
        }
        else if displaySection == .Sentences
        {
            return kanji.sentences.count > 0 ? 30.0 : 0.0
        }
        else
        {
            return 0.0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let displaySection: PRKanjiJigokuKanjiOptions = PRKanjiJigokuKanjiOptions(rawValue: section)!
        if displaySection == .AdditionalExamples
        {
            return "Material z innych lekcji"
        }
        else if displaySection == .Sentences
        {
            return "Szukaj znaku w zdaniach"
        }
        else
        {
            return ""
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let displaySection: PRKanjiJigokuKanjiOptions = PRKanjiJigokuKanjiOptions(rawValue: indexPath.section)!
        if displaySection == .RelatedKanijs || displaySection == .Notes
        {
            return 30.0
        }
        if displaySection == .Kunyomi || displaySection == .Onyomi
        {
            return 45.0
        }
        else if displaySection == .Summary
        {
            return 100.0
        }
        else
        {
            // for examples and sentences adjust based on detailed height
            var text = ""
            var detailedText = ""
            if displaySection == .Examples {
                let example = kanji.examples.allObjects as! [Example]
                text = example[indexPath.row].generateDescriptionString().string
                detailedText = example[indexPath.row].meaning + " " + example[indexPath.row].note.removeReferenceSubstring()
            } else if displaySection == .AdditionalExamples {
                text = additionalExamples[indexPath.row].generateDescriptionString().string
                detailedText = additionalExamples[indexPath.row].meaning + " " + additionalExamples[indexPath.row].note.removeReferenceSubstring()
            } else { // == .Sentences
                let sentence = kanji.sentences.allObjects as! [Sentence]
                text = sentence[indexPath.row].getExplainedSentence().string
                detailedText = sentence[indexPath.row].meaning
            }
            
            let font = UIFont().appFontOfSize(15.0)
            let detailedFont = UIFont().appFont()
            let constraintsSize = CGSizeMake(tableView.bounds.size.width, CGFloat(MAXFLOAT))
            let labelSize = text.boundingRectWithSize(constraintsSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
            let detailedLabelSize = detailedText.boundingRectWithSize(constraintsSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: detailedFont], context: nil)
            
            //println("Cell height: \(labelSize.height + detailedLabelSize.height + 20.0)")
            return labelSize.height + detailedLabelSize.height + 20.0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath) as! UICollectionViewCell
        let label = UILabel(frame: CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height))
        label.text = relatedKanjis[indexPath.row].kanji
        
        let onyomiSet = kanji.onyomis.allObjects as! [Onyomi]
        let onyomiSet2 = relatedKanjis[indexPath.row].onyomis.allObjects as! [Onyomi]
        
        let test = onyomiSet.map({
            
            (onyomi) -> String in onyomi.reading
        })
        
        let testBool = onyomiSet2.filter({
            
            (onyomi : Onyomi) in contains(test, onyomi.reading)
        })
        
        
        debugLog("\(test.description)")
        debugLog("\(testBool.description)")
        
        label.textColor = testBool.count > 0 ? UIColor.redColor() : UIColor.blueColor()
        
        cell.addSubview(label)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return relatedKanjis.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        let vc = PRKanjiTableViewController()
        vc.kanji  = relatedKanjis[indexPath.row] as Kanji
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    func filterOutAdvancedKanji(text: String) -> NSAttributedString {
    
        let characters: [Character] = Array(text)
        let mappedString: NSAttributedString = characters.map{ (inputCharacter : Character) -> NSAttributedString in
            
            if self.characterIsKanji(inputCharacter) {
            
                // character is kanji so we can look it up in our database
                if let kanji = PRDatabaseHelper().fetchSingleKanji(String(inputCharacter)) {
                    if Int(kanji.level) > Int(PRStateSingleton.sharedInstance.filterLevel) && Int(kanji.lesson) > Int(PRStateSingleton.sharedInstance.filterLesson) {
                    
                        return NSAttributedString(string: String(inputCharacter), attributes: [NSForegroundColorAttributeName: UIColor.greenColor()])
                    }
                }
            }
            return NSAttributedString(string: String(inputCharacter))
        }.reduce(NSMutableAttributedString()) { $0.appendAttributedString($1); return $0 }
        
        return mappedString
    }
    
    func characterIsKanji(character: Character) -> Bool {
        
        let kanjicharacters = NSCharacterSet(range: NSMakeRange(0x4e00, 0x9faf))
        let s = String(character).unicodeScalars
        let uni = s[s.startIndex]
        
        return kanjicharacters.longCharacterIsMember(uni.value)
    }
}

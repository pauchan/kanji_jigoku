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
    case relatedKanijs=0, summary, notes , onyomi, kunyomi, examples, additionalExamples, sentences
}

class PRKanjiTableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var kanji : Kanji!
    var sameLessonKanjis: [Kanji]!
    var additionalExamples : [Example]!
    var relatedKanjis : [Kanji]!
    var tableView : UITableView!
    var pageControl : PRKanjiHeader!
    var currentPage: Int!
    weak var pageViewController : PRKanjiPageViewController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // TODO: make nice pagination for page control
        let pageControlHeight: CGFloat = (sameLessonKanjis.count < 15) ? 0.15 : 0.0
        
        pageControl = PRKanjiHeader(kanjis: sameLessonKanjis, frame: CGRect(x: 0, y: self.view.frame.size.height*(1-pageControlHeight), width: self.view.frame.size.width, height: self.view.frame.size.height*pageControlHeight))
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 64.0, width: self.view.frame.size.width, height: self.view.frame.size.height*(1-pageControlHeight)))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        pageControl.currentPage = self.currentPage
        self.navigationItem.title = kanji.kanji
        pageControl.setupView(CGRect(x: 0, y: self.view.frame.size.height*(1-pageControlHeight), width: self.view.frame.size.width, height: self.view.frame.size.height*pageControlHeight))
        self.view.addSubview(pageControl)
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PRKanjiCell")
        self.tableView.register(PRDetailedKanjiCell.self, forCellReuseIdentifier: "PRKanjiCell2")

        let nib : UINib = UINib(nibName: "PRKanjiTableViewHeaderCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "PRKanjiHeaderCell")
        
        let nib2 : UINib = UINib(nibName: "PRRelatedKanjiCell", bundle: nil)
        self.tableView.register(nib2, forCellReuseIdentifier: "PRRelatedKanjiCell")
        
        additionalExamples = PRDatabaseHelper().fetchAdditionalExamples(kanji.kanji!)
        if kanji.relatedKanji!.isEmpty {
            relatedKanjis = [Kanji]()
        } else {
            relatedKanjis = PRDatabaseHelper().fetchRelatedKanjis(kanji)
        }
        
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 90.0))    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let displaySection: PRKanjiJigokuKanjiOptions = PRKanjiJigokuKanjiOptions(rawValue: section)!
        switch(displaySection)
        {
        case .relatedKanijs:
            return relatedKanjis.count > 0 ? 1 : 0
        case .summary:
            return 1
        case .notes:
            return (kanji.note!.isEmpty || kanji.note == "0") ? 0 : 1
        case .kunyomi:
            return kanji.kunyomis!.count > 0  ? 1 : 0
        case .onyomi:
            return kanji.onyomis!.count > 0  ? 1 : 0
        case .examples:
            return kanji.examples!.count
        case .additionalExamples:
            return additionalExamples.count
        case .sentences:
            return kanji.sentences!.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let displaySection: PRKanjiJigokuKanjiOptions = PRKanjiJigokuKanjiOptions(rawValue: (indexPath as NSIndexPath).section)!
        switch(displaySection)
        {
        case .relatedKanijs:
            debugLog("related kanji")
            let cell = tableView.dequeueReusableCell(withIdentifier: "PRRelatedKanjiCell", for: indexPath) as! PRRelatedKanjiCell
            cell.relatedKanjiCollectionview.delegate = self
            cell.relatedKanjiCollectionview.dataSource = self
            cell.relatedKanjiCollectionview.backgroundColor = UIColor.white
            cell.relatedKanjiCollectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
            cell.selectionStyle = .none
            return cell
            
        case .summary:
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "PRKanjiHeaderCell", for: indexPath) as! PRKanjiTableViewHeaderCell
            headerCell.kanjiLabel.text = kanji.kanji
            headerCell.detailsLabel.text = " \(kanji.strokeCount)画 【\(kanji.generateRadicalsString())】\(kanji.generateAdditionalKanjiString())"
            headerCell.explanationLabel.text = kanji.meaning
            headerCell.explanationLabel.adjustsFontSizeToFitWidth = true
            //headerCell.explanationLabel.numberOfLines = 2
            //headerCell.explanationLabel.sizeToFit()
            headerCell.selectionStyle = .none
            return headerCell
            
        case .notes:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PRKanjiCell", for: indexPath)
            cell.textLabel?.text = kanji.note
            cell.selectionStyle = .none
            return cell
            
        case .kunyomi:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PRKanjiCell", for: indexPath)
            let arr = kanji.kunyomis!.allObjects as! [Kunyomi]
            cell.textLabel?.text = kanji.generateCommaSeparatedString(arr)
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.textLabel?.numberOfLines = 2
            cell.textLabel?.sizeToFit()
            cell.selectionStyle = .none
            return cell
            
        case .onyomi:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PRKanjiCell", for: indexPath) 
            let arr = kanji.onyomis!.allObjects as! [Onyomi]
            cell.textLabel?.text = kanji.generateCommaSeparatedString(arr)
            cell.selectionStyle = .none
            return cell
            
        case .examples:
            debugLog("examples")
            let cell = tableView.dequeueReusableCell(withIdentifier: "PRKanjiCell2") as? PRDetailedKanjiCell
            let example = kanji.examples!.allObjects as! [Example]
            let descriptionString = example[(indexPath as NSIndexPath).row].markIfImportant(example[(indexPath as NSIndexPath).row].generateDescriptionString().string)
            cell!.textLabel?.attributedText =  (PRStateSingleton.sharedInstance.filterOn) ? self.filterOutAdvancedKanji(descriptionString.string) : descriptionString
            cell!.detailTextLabel?.text = example[(indexPath as NSIndexPath).row].meaning! + " " + example[(indexPath as NSIndexPath).row].note!.removeReferenceSubstring()
            return cell!
            
        case .additionalExamples:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PRKanjiCell2") as? PRDetailedKanjiCell
            let descriptionString = additionalExamples[(indexPath as NSIndexPath).row].generateDescriptionString()
            cell!.textLabel?.attributedText = (PRStateSingleton.sharedInstance.filterOn) ? self.filterOutAdvancedKanji(descriptionString.string) : descriptionString
            cell!.detailTextLabel?.text = additionalExamples[(indexPath as NSIndexPath).row].meaning! + " " + additionalExamples[(indexPath as NSIndexPath).row].note!.removeReferenceSubstring()
            return cell!
            
        case .sentences:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PRKanjiCell2") as? PRDetailedKanjiCell
            let sentence = kanji.sentences!.allObjects as! [Sentence]
            cell!.textLabel?.attributedText = (PRStateSingleton.sharedInstance.filterOn) ? self.filterOutAdvancedKanji(sentence[(indexPath as NSIndexPath).row].replaceExplainedSentence()) : NSAttributedString(string: sentence[(indexPath as NSIndexPath).row].replaceExplainedSentence())
            cell!.detailTextLabel?.text = sentence[(indexPath as NSIndexPath).row].meaning
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let displaySection: PRKanjiJigokuKanjiOptions = PRKanjiJigokuKanjiOptions(rawValue: section)!
        if displaySection == .additionalExamples
        {
            return additionalExamples.count > 0 ? 30.0 : 0.0
        }
        else if displaySection == .sentences
        {
            return kanji.sentences!.count > 0 ? 30.0 : 0.0
        }
        else
        {
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let displaySection: PRKanjiJigokuKanjiOptions = PRKanjiJigokuKanjiOptions(rawValue: section)!
        if displaySection == .additionalExamples
        {
            return "Materiał z innych lekcji"
        }
        else if displaySection == .sentences
        {
            return "Szukaj znaku w zdaniach"
        }
        else
        {
            return ""
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let displaySection: PRKanjiJigokuKanjiOptions = PRKanjiJigokuKanjiOptions(rawValue: (indexPath as NSIndexPath).section)!
        if displaySection == .relatedKanijs || displaySection == .notes
        {
            return 30.0
        }
        if displaySection == .kunyomi || displaySection == .onyomi
        {
            return 45.0
        }
        else if displaySection == .summary
        {
            return 100.0
        }
        else {
            // for examples and sentences adjust based on detailed height
            var text = ""
            var detailedText = ""
            if displaySection == .examples {
                let example = kanji.examples!.allObjects as! [Example]
                text = example[(indexPath as NSIndexPath).row].generateDescriptionString().string
                detailedText = example[(indexPath as NSIndexPath).row].meaning! + " " + example[(indexPath as NSIndexPath).row].note!.removeReferenceSubstring()
            } else if displaySection == .additionalExamples {
                text = additionalExamples[(indexPath as NSIndexPath).row].generateDescriptionString().string
                detailedText = additionalExamples[(indexPath as NSIndexPath).row].meaning! + " " + additionalExamples[(indexPath as NSIndexPath).row].note!.removeReferenceSubstring()
            } else { // == .Sentences
                let sentence = kanji.sentences!.allObjects as! [Sentence]
                text = sentence[(indexPath as NSIndexPath).row].replaceExplainedSentence()
                detailedText = sentence[(indexPath as NSIndexPath).row].meaning!
            }
            
            let font = UIFont().appFontOfSize(15.0)
            let detailedFont = UIFont.systemFont(ofSize: 12.0)
            let constraintsSize = CGSize(width: tableView.bounds.size.width, height: CGFloat(MAXFLOAT))
            let labelSize = text.boundingRect(with: constraintsSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
            let detailedLabelSize = detailedText.boundingRect(with: constraintsSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: detailedFont], context: nil)
            
            return labelSize.height + detailedLabelSize.height + 20.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath) 
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
        label.text = relatedKanjis[(indexPath as NSIndexPath).row].kanji
        
        let onyomiSet = kanji.onyomis!.allObjects as! [Onyomi]
        let onyomiSet2 = relatedKanjis[(indexPath as NSIndexPath).row].onyomis!.allObjects as! [Onyomi]
        
        let test = onyomiSet.map({
            
            (onyomi) -> String in onyomi.reading!
        })
        
        let testBool = onyomiSet2.filter({
            
            (onyomi : Onyomi) in test.contains(onyomi.reading!)
        })
        
        
        debugLog("\(test.description)")
        debugLog("\(testBool.description)")
        
        label.textColor = testBool.count > 0 ? UIColor.red : UIColor.blue
        
        cell.addSubview(label)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return relatedKanjis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = PRKanjiTableViewController()
        let kanji = relatedKanjis[(indexPath as NSIndexPath).row] as Kanji
        vc.kanji  = kanji
        vc.sameLessonKanjis = []
        vc.currentPage = 0
        if self.pageViewController != nil {
        
            let vc = PRKanjiPageViewController()
            vc._kanjiTable = PRDatabaseHelper().getSelectedObjects("Kanji", level: Int(kanji.level), lesson: Int(kanji.lesson)) as! [Kanji]
            vc._selectedIndex = vc._kanjiTable.index(of: kanji)!
            pageViewController!.navigationController?.pushViewController(vc, animated: true)
        }
            //presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func filterOutAdvancedKanji(_ text: String) -> NSMutableAttributedString {
    
        let characters: [Character] = Array(text.characters)
        let mappedString: NSMutableAttributedString = characters.map{ (inputCharacter : Character) -> NSAttributedString in
            
            if self.characterIsKanji(inputCharacter) {
            
                // character is kanji so we can look it up in our database
                if let kanji = PRDatabaseHelper().fetchSingleKanji(String(inputCharacter)) {
                    if Int(kanji.level) > Int(PRStateSingleton.sharedInstance.filterLevel) && Int(kanji.lesson) > Int(PRStateSingleton.sharedInstance.filterLesson) {
                    
                        return NSAttributedString(string: String(inputCharacter), attributes: [NSForegroundColorAttributeName: UIColor.green])
                    }
                }
            }
            return NSAttributedString(string: String(inputCharacter))
        }.reduce(NSMutableAttributedString()) { $0.append($1); return $0 }
        
        return mappedString
    }
    
    func characterIsKanji(_ character: Character) -> Bool {
        
        let start = UnicodeScalar(0x4e00)!
        let stop = UnicodeScalar(0x9faf)!
        let kanjicharacters = CharacterSet(charactersIn: start..<stop)
        let s = String(character).unicodeScalars
        let uni = s[s.startIndex]
        
        return kanjicharacters.contains(UnicodeScalar(uni.value)!)
    }
}

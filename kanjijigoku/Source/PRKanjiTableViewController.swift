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
    case Summary = 0, Kunyomi, Onyomi, Examples, AdditionalExamples, Sentences
}

class PRKanjiTableViewController: UITableViewController {
    
    var kanji : Character!
    var additionalExamples : [Example]!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PRKanjiCell")
        let nib : UINib = UINib(nibName: "PRKanjiTableViewHeaderCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "PRKanjiHeaderCell")
        
        //additionalExamples = [Example]()
        additionalExamples = PRDatabaseHelper().fetchAdditionalExamples(kanji.kanji)



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
        case PRKanjiJigokuKanjiOptions.Summary.rawValue:
            // TODO!!!!
            return 3
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

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch(indexPath.section)
        {
        case PRKanjiJigokuKanjiOptions.Summary.rawValue:
            
            if indexPath.row == 0
            {
                return tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as UITableViewCell
            }
            else if indexPath.row == 1
            {
                let headerCell = tableView.dequeueReusableCellWithIdentifier("PRKanjiHeaderCell", forIndexPath: indexPath) as PRKanjiTableViewHeaderCell
                headerCell.kanjiLabel.text = kanji.kanji
                
                var arr = kanji.radicals.allObjects as [Radical]  //.allObjects as [Radical]
                let radicalsString = arr.map {
                    (radical : Radical) -> String in radical.radical
                    }.reduce(""){
                        
                        (base,append) in base + append
                }
                
                
                headerCell.detailsLabel.text = " \(kanji.strokeCount)画 【\(radicalsString)】"
                headerCell.explanationLabel.text = kanji.meaning
                return headerCell
            }
            else // indexPath.row == 2
            {
                return tableView.dequeueReusableCellWithIdentifier("PRKanjiCell", forIndexPath: indexPath) as UITableViewCell
            }
            
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
    
    
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == PRKanjiJigokuKanjiOptions.AdditionalExamples.rawValue || section == PRKanjiJigokuKanjiOptions.Sentences.rawValue
        {
            return 30.0
        }
        else
        {
            return 0.0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
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
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        return 60.0
        
    }
    
    
    
}

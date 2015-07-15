//
//  PRTestPageViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/16.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRTestResultsViewController: UITableViewController {

    
    var questions : [Question]!
    var correctAnswers : Int = 0
    var descriptionText = ""
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        self.navigationItem.title = "Wyniki testu"
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PRTestResultCell")
        self.tableView.tableFooterView = UIView()
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if(indexPath.section == 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("PRTestResultCell", forIndexPath: indexPath) as! UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.textLabel?.text = "\(descriptionText) : \(correctAnswers)/\(questions.count)"
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("PRTestResultCell", forIndexPath: indexPath) as! UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.textLabel?.attributedText = questions[indexPath.row].questionSummaryString
            return cell
        }
    }

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 60.0
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
            return questions.count
        }
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.navigationController?.popToRootViewControllerAnimated(false)
        super.viewWillDisappear(animated)
    }


}

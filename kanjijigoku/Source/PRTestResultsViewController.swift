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
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PRTestResultCell")
        self.tableView.tableFooterView = UIView()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if((indexPath as NSIndexPath).section == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PRTestResultCell", for: indexPath) 
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.textLabel?.text = "\(descriptionText) : \(correctAnswers)/\(questions.count)"
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PRTestResultCell", for: indexPath) 
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.textLabel?.attributedText = questions[(indexPath as NSIndexPath).row].questionSummaryString
            return cell
        }
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath as NSIndexPath).section == 0
        {
            return 60.0
        }
        else
        {
            return 45.0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.popToRootViewController(animated: false)
        super.viewWillDisappear(animated)
    }


}

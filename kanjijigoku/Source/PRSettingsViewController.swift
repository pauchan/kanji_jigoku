//
//  PRSettingsTableViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/25.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRSettingsViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: self.view.frame, style:  UITableViewStyle.Grouped)
        
        let nib = UINib(nibName: "PRFilterCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "PRFilterCell")
        
        self.navigationItem.title = "Ustawienia"
        
        //self.tableView.registerClass(UITableViewCell.self, forHeaderFooterViewReuseIdentifier: "PRSettingsCell")
        
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0
        {
            return 3
        }
        else
        {
            return 1
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0
        {
            return "Baza danych"
        }
        else
        {
            return "Filtr"
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("PRFilterCell", forIndexPath: indexPath) as UITableViewCell
            return cell
            
        }
        else
        {
            switch(indexPath.row)
            {
            case 0:
                var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("PRSettingsCell") as? UITableViewCell
                if cell == nil
                {
                    cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "PRSettingsCell")
                    cell!.selectionStyle = UITableViewCellSelectionStyle.None
                    cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                    cell!.textLabel?.text = "Aktualizacja bazy danych"
                }
                return cell!
            case 1:
                var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("PRSettingsCell") as? UITableViewCell
                if cell == nil
                {
                    cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "PRSettingsCell")
                    cell!.selectionStyle = UITableViewCellSelectionStyle.None
                    cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
                    cell!.textLabel?.text = "Automatyczne aktualizacje"
                    cell!.detailTextLabel?.text = "Automatycznie sprawdzaj aktualizacje bazy po uruchomieniu aplikacji, jesli urzadzenie jest polaczone z internetem."
                    cell!.detailTextLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
                    cell!.detailTextLabel?.numberOfLines = 0
                }
                return cell!
            case 2:
                var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("PRSettingsCell") as? UITableViewCell
                if cell == nil
                {
                    cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "PRSettingsCell")
                    cell!.selectionStyle = UITableViewCellSelectionStyle.None
                    cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                    cell!.textLabel?.text = "Reset Aplikacji"
                    cell!.detailTextLabel?.text = "Ustawienia aplikacji zostana zresetowane, a baza danych ponownie zaladowana do sieci."
                    cell!.detailTextLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
                    cell!.detailTextLabel?.numberOfLines = 0
                }
                return cell!
            default:
                var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("PRSettingsCell") as? UITableViewCell
                return cell!
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        if indexPath.section == 0
        {
            return 70.0
        }
        else
        {
            return 160.0
        }
    }




    
}

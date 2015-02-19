//
//  PRKanjiPageViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/19.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRKanjiPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource
{
    
    var _kanjiTable : NSArray = [Character]()
    var _selectedIndex : Int = 0
    
    override func viewDidLoad()
    {
        self.navigationItem.title = "Kanji"
        
        //self.dataSource = self
        
        let vc = PRKanjiTableViewController()
        vc.kanji = _kanjiTable[_selectedIndex] as Character
        var vcArray = [vc] as [AnyObject]
        self.setViewControllers(vcArray, direction: .Forward, animated: false, completion: nil)
        
        
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if _selectedIndex == 0
        {
            return nil
        }
        else
        {
            _selectedIndex--
            let vc = PRKanjiTableViewController()
            vc.kanji  = _kanjiTable[_selectedIndex] as Character
            return vc
        }
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if _selectedIndex == _kanjiTable.count - 1
        {
            return nil
        }
        else
        {
            _selectedIndex++
            let vc = PRKanjiTableViewController()
            vc.kanji  = _kanjiTable[_selectedIndex] as Character
            return vc
        }
    }
    
    //func page
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return _kanjiTable.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return _selectedIndex
    }
}




//
//  PRKanjiPageViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/19.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

let kKanjiPageIndicatorWidth : CGFloat = 300.0
let kKanjiPageIndicatorHeight : CGFloat = 50.0

class PRKanjiPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource
{
    
    var _kanjiTable : [Character] = [Character]()
    var _selectedIndex : Int = 0
    
    override func viewDidLoad()
    {
        self.navigationItem.title = "Kanji"
        
        //self.dataSource = self
        
        let vc = PRKanjiTableViewController()
        vc.kanji = _kanjiTable[_selectedIndex] as Character
        var vcArray = [vc] as [AnyObject]
        
        
        let pageControl: PRKanjiPageControl = PRKanjiPageControl(kanjis: _kanjiTable,  frame: CGRectMake(self.view.center.x - (kKanjiPageIndicatorWidth/2.0), self.view.frame.origin.y + 0.0, kKanjiPageIndicatorWidth, kKanjiPageIndicatorHeight))
        println("Center x: \(self.view.center.x)")
        //pageControl.frame =  CGRectMake(self.view.center.x - (kKanjiPageIndicatorWidth/2.0), self.view.frame.origin.y + 30.0, kKanjiPageIndicatorWidth, kKanjiPageIndicatorHeight)
        //        self.view.addSubview(pageControl)
        
        vc.tableView.tableHeaderView = pageControl
        
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
            
//            let pageControl: PRKanjiPageControl = PRKanjiPageControl(kanjis: _kanjiTable)
//            pageControl.frame = CGRectMake(self.view.center.x - (kKanjiPageIndicatorWidth/2.0), self.view.frame.origin.y , kKanjiPageIndicatorWidth, kKanjiPageIndicatorHeight)
//            //        self.view.addSubview(pageControl)
//            
//            vc.tableView.tableFooterView = pageControl
            
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
            
//            let pageControl: PRKanjiPageControl = PRKanjiPageControl(kanjis: _kanjiTable)
//            pageControl.frame = CGRectMake(self.view.center.x - (kKanjiPageIndicatorWidth/2.0), self.view.frame.origin.y , kKanjiPageIndicatorWidth, kKanjiPageIndicatorHeight)
//            //        self.view.addSubview(pageControl)
//            
//            vc.tableView.tableFooterView = pageControl
            
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




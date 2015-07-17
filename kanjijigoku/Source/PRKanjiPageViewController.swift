//
//  PRKanjiPageViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/19.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRKanjiPageViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource
{
    
    var _kanjiTable : [Kanji] = [Kanji]()
    var _selectedIndex : Int = 0
    var pageViewController : UIPageViewController!
    
    override func viewDidLoad()
    {
        
        pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.PageCurl, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
    
        let vc = PRKanjiTableViewController()
        vc.kanji = _kanjiTable[_selectedIndex] as Kanji
        vc.sameLessonKanjis = _kanjiTable

        var vcArray = [vc] as [AnyObject]
        
        self.navigationItem.title = vc.kanji.kanji
        
        pageViewController.setViewControllers(vcArray, direction: .Forward, animated: false, completion: nil)
        self.view.addSubview(pageViewController.view)

        
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
            vc.kanji  = _kanjiTable[_selectedIndex] as Kanji
            vc.sameLessonKanjis = _kanjiTable
            self.navigationItem.title = vc.kanji.kanji
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
            vc.kanji  = _kanjiTable[_selectedIndex] as Kanji
            vc.sameLessonKanjis = _kanjiTable
            self.navigationItem.title = vc.kanji.kanji
            return vc
        }
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return _kanjiTable.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return _selectedIndex
    }
    
}




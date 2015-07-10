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

class PRKanjiPageViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource
{
    
    var _kanjiTable : [Kanji] = [Kanji]()
    var _selectedIndex : Int = 0
    var _pageControl : PRKanjiPageControl!
    var pageViewController : UIPageViewController!
    
    override func viewDidLoad()
    {
        
        pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.PageCurl, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
    
        let vc = PRKanjiTableViewController()
        vc.kanji = _kanjiTable[_selectedIndex] as Kanji
        var vcArray = [vc] as [AnyObject]
        
        self.navigationItem.title = vc.kanji.kanji
        
        _pageControl = PRKanjiPageControl(kanjis: _kanjiTable, frame: CGRectMake(0, self.view.frame.size.height*0.85, self.view.frame.size.width, self.view.frame.size.height*0.15))
        _pageControl.numberOfPages = _kanjiTable.count
        vc.pageControl = _pageControl
        _pageControl.currentPage = _selectedIndex
        
        pageViewController.setViewControllers(vcArray, direction: .Forward, animated: false, completion: nil)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)

        
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if _selectedIndex == 0
        {
            return nil
        }
        else
        {
            _pageControl.currentPage = --_selectedIndex
            let vc = PRKanjiTableViewController()
            vc.kanji  = _kanjiTable[_selectedIndex] as Kanji
            self.navigationItem.title = vc.kanji.kanji
            vc.pageControl = _pageControl
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
            _pageControl.currentPage = ++_selectedIndex
            let vc = PRKanjiTableViewController()
            vc.kanji  = _kanjiTable[_selectedIndex] as Kanji
            self.navigationItem.title = vc.kanji.kanji
            vc.pageControl = _pageControl
            
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




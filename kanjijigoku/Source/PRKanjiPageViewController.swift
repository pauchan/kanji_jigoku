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
        vc.currentPage = _selectedIndex
        vc.pageViewController = self
        vc.sameLessonKanjis = _kanjiTable
        
        let vcArray = [vc] as [UIViewController]?
        
        self.navigationItem.title = vc.kanji.kanji
        
        pageViewController.setViewControllers(vcArray, direction: .Forward, animated: false, completion: nil)
        self.view.addSubview(pageViewController.view)
        
        self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
        
        // Remove tap recoginzer
        var tapRecognizer: UIGestureRecognizer
        for  recognizer in self.pageViewController.gestureRecognizers {
            if  recognizer is UITapGestureRecognizer {
                tapRecognizer = recognizer 
                self.view.removeGestureRecognizer(tapRecognizer)
                self.pageViewController.view.removeGestureRecognizer(tapRecognizer)
                
            }
        }
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if _selectedIndex == 0
        {
            return nil
        }
        else
        {
            let vc = PRKanjiTableViewController()
            vc.kanji  = _kanjiTable[_selectedIndex-1] as Kanji
            vc.sameLessonKanjis = _kanjiTable
            vc.currentPage = _selectedIndex-1
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
            let vc = PRKanjiTableViewController()
            vc.kanji  = _kanjiTable[_selectedIndex+1] as Kanji
            vc.sameLessonKanjis = _kanjiTable
            vc.currentPage = _selectedIndex+1
            return vc
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        let nextKanjiPage = pendingViewControllers[0] as! PRKanjiTableViewController
        self.navigationItem.title = nextKanjiPage.kanji.kanji
        _selectedIndex = nextKanjiPage.currentPage
        nextKanjiPage.pageViewController = self
        print("called")
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        print("called")
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return _kanjiTable.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return _selectedIndex
    }
    
}




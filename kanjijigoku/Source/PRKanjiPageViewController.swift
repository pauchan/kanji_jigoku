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
    
    var _kanjiTable : [Character] = [Character]()
    var _selectedIndex : Int = 0
    //var inactiveImagesArray : [UIImage] = [UIImage]()
    var _pageControl : PRKanjiPageControl!
    var pageViewController : UIPageViewController!
    
    override func viewDidLoad()
    {
        self.navigationItem.title = "Kanji"
        
        pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.PageCurl, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
    
        let vc = PRKanjiTableViewController()
        vc.kanji = _kanjiTable[_selectedIndex] as Character
        var vcArray = [vc] as [AnyObject]
        
        _pageControl = PRKanjiPageControl(kanjis: _kanjiTable, frame: CGRectMake(0, self.view.frame.size.height*0.85, self.view.frame.size.width, self.view.frame.size.height*0.15))
         //,  frame: CGRectMake(self.view.center.x - (kKanjiPageIndicatorWidth/2.0), self.view.frame.origin.y + 0.0, kKanjiPageIndicatorWidth, kKanjiPageIndicatorHeight
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
            _pageControl.currentPage = ++_selectedIndex
            let vc = PRKanjiTableViewController()
            vc.kanji  = _kanjiTable[_selectedIndex] as Character
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
            _pageControl.currentPage = --_selectedIndex
            let vc = PRKanjiTableViewController()
            vc.kanji  = _kanjiTable[_selectedIndex] as Character
            vc.pageControl = _pageControl
            
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
    
//    func generateKanjiPageController(kanjis: [Character])
//    {
//    
//        for ch in kanjis
//        {
//            let font = UIFont(name: "Helvetica", size: 17.0)
//            let kanji :NSAttributedString = NSAttributedString(string: ch.kanji, attributes: [NSFontAttributeName : font!])
//            
//            UIGraphicsBeginImageContextWithOptions(kanji.size(), false, 0.0)
//            kanji.drawAtPoint(CGPointMake(0.0, 0.0)) //, withAttributes: [NSFontAttributeName : font!])
//            inactiveImagesArray.append(UIGraphicsGetImageFromCurrentImageContext())
//            UIGraphicsEndImageContext()
//            
//        }
//    }
    
}




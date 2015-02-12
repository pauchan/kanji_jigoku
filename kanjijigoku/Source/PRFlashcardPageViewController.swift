//
//  PRFlashcardPageViewController.swift
//  kanjijigoku
//
//  Created by Paweł Rusin on 2015/02/10.
//  Copyright (c) 2015年 Pawel Rusin. All rights reserved.
//

import UIKit

class PRFlashcardPageViewController : UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource
{
    var _flashcardSet : NSArray = [Character]()
    var _selectedIndex : Int = 0
    
    override func viewDidLoad() {
        
        //let flashcard =

        let vc = PRFlashcardViewController()
        vc.flashcard  = _flashcardSet[0] as Character
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
            let vc = PRFlashcardViewController()
            vc.flashcard = _flashcardSet[_selectedIndex] as Character
            return vc
        }
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if _selectedIndex == _flashcardSet.count
        {
            return nil
        }
        else
        {
            _selectedIndex++
            let vc = PRFlashcardViewController()
            vc.flashcard = _flashcardSet[_selectedIndex] as Character
            return vc
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return _flashcardSet.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return _selectedIndex
    }
}

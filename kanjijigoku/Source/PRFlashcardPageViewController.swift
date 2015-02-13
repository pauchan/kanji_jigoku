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
    var _flashcardSet : NSArray = [Flashcard]()
    var _selectedIndex : Int = 0
    
    override func viewDidLoad()
    {
        
        self.dataSource = self
        
        if _flashcardSet.count == 0
        {
            let vc = UIViewController()
            var vcArray = [vc] as [AnyObject]
            self.setViewControllers(vcArray, direction: .Forward, animated: false, completion: nil)
        }
        else
        {
            let vc = PRFlashcardViewController(nibName: "PRFlashcardViewController", bundle: nil)
            vc.flashcard = _flashcardSet[0] as Flashcard
            var vcArray = [vc] as [AnyObject]
            self.setViewControllers(vcArray, direction: .Forward, animated: false, completion: nil)
        }
        
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if _selectedIndex == 0
        {
            return nil
        }
        else
        {
            _selectedIndex--
            let vc = PRFlashcardViewController(nibName: "PRFlashcardViewController", bundle: nil)
            vc.flashcard  = _flashcardSet[_selectedIndex] as Flashcard
            return vc
        }
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if _selectedIndex == _flashcardSet.count - 1 
        {
            return nil
        }
        else
        {
            _selectedIndex++
            let vc = PRFlashcardViewController(nibName: "PRFlashcardViewController", bundle: nil)
            vc.flashcard  = _flashcardSet[_selectedIndex] as Flashcard
            return vc
        }
    }
    
    //func page
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return _flashcardSet.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return _selectedIndex
    }
}

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
        
        let bla = _flashcardSet[0] as Character
        println("test \(bla.kanji)")
        
        self.dataSource = self
        
        //let flashcard =

        let vc = PRFlashcardViewController()
        vc.view.backgroundColor = UIColor.whiteColor()
        let character = _flashcardSet[0] as Character
        vc.name  = character.kanji
        

        
        var vcArray = [vc] as [AnyObject]
        self.setViewControllers(vcArray, direction: .Forward, animated: false, completion: nil)
        
        
    }
    
    //func viewCo
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if _selectedIndex == 0
        {
            return nil
        }
        else
        {
            _selectedIndex--
            let vc = PRFlashcardViewController()
            //vc.flashcard = _flashcardSet[_selectedIndex] as Character
            
            //let vc = PRFlashcardViewController()
            var character = _flashcardSet[_selectedIndex] as Character
            vc.characterLabel.text  = character.kanji
            
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
            var character = _flashcardSet[_selectedIndex] as Character
            vc.characterLabel.text  = character.kanji
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

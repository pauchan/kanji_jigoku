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
    let flashcardSet: [Flashcard]
    var flashcardViewControllers = [PRFlashcardViewController]()
    
    init(flashcardSet : [Flashcard]) {
        self.flashcardSet = flashcardSet
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = "Fiszki"
        self.dataSource = self
        
        for flashcard in self.flashcardSet {
            let vc = PRFlashcardViewController(nibName: "PRFlashcardViewController", bundle: nil)
            vc.flashcard = flashcard
            self.flashcardViewControllers.append(vc)
        }
        self.setViewControllers([self.flashcardViewControllers.first!], direction: .forward, animated: false, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if var pageIndex = self.flashcardViewControllers.index(of: viewController as! PRFlashcardViewController) {
            if pageIndex == 0 {
                return nil
            } else {
                pageIndex -= 1
                return self.flashcardViewControllers[pageIndex]
            }
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if var pageIndex = self.flashcardViewControllers.index(of: viewController as! PRFlashcardViewController) {
            if pageIndex == self.flashcardSet.count - 1 {
                return nil
            } else {
                pageIndex += 1
                return self.flashcardViewControllers[pageIndex]
            }
        } else {
            return nil
        }
    }
}

//
//  AppDelegate.swift
//  kanjijigoku
//
//  Created by Pawel Rusin on 2/7/15.
//  Copyright (c) 2015 Pawel Rusin. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, FinishedLoadingDelegate, UITabBarControllerDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        Fabric.sharedSDK().debug = true
        
        Chameleon.setGlobalThemeUsingPrimaryColor(appColor, withContentStyle: UIContentStyle.Dark)
        
        UITabBar.appearance().barTintColor = appColor
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState: UIControlState.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Selected)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let viewContr = PRInitController()
        viewContr.delegate = self
        self.window?.rootViewController = viewContr
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func splashDidFinishLoading()
    {
        let tabBarController : UITabBarController = UITabBarController()
        tabBarController.delegate = self
        
        let kanjiViewController = PRKanjiMenuViewController()
        kanjiViewController._kanjiTable = PRDatabaseHelper().getSelectedObjects("Kanji", level: PRStateSingleton.sharedInstance.currentLevel, lesson: PRStateSingleton.sharedInstance.currentLesson) as! [Kanji]
        
        let kanjiNavigationController : UINavigationController = UINavigationController(rootViewController: kanjiViewController)
        let searchNavigationController : UINavigationController = UINavigationController(rootViewController: PRSearchKanjiViewController(nibName: "PRSearchKanjiViewController" ,bundle: nil))
        let testsNavigationController : UINavigationController = UINavigationController(rootViewController: PRTestMenuViewController())
        let flashcardController : UINavigationController = UINavigationController(rootViewController: PRFlashcardMenuViewController(style: UITableViewStyle.Plain))
        
        kanjiNavigationController.tabBarItem = UITabBarItem(title: "Lekcja", image: generateKanjiImage(UIColor.blackColor()).imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal) , tag: 0)
        kanjiNavigationController.tabBarItem.selectedImage = generateKanjiImage(UIColor.whiteColor()).imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        searchNavigationController.tabBarItem = UITabBarItem(title: "Szukaj", image: UIImage(named: "SearchIcon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), tag: 1)
        searchNavigationController.tabBarItem.selectedImage = UIImage(named: "SearchIconWhite")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        testsNavigationController.tabBarItem = UITabBarItem(title: "Testy", image: UIImage(named: "TestIcon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), tag: 2)
        testsNavigationController.tabBarItem.selectedImage = UIImage(named: "TestIconWhite")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        flashcardController.tabBarItem = UITabBarItem(title: "Fiszki", image: UIImage(named: "FlashcardIcon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), tag: 3)
        flashcardController.tabBarItem.selectedImage = UIImage(named: "FlashcardIconWhite")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        tabBarController.viewControllers = [kanjiNavigationController, searchNavigationController, testsNavigationController, flashcardController]
        
        for vc in tabBarController.viewControllers as! [UINavigationController] {
            if vc.respondsToSelector("interactivePopGestureRecognizer") {
                vc.interactivePopGestureRecognizer!.enabled = false
            }
        }
        
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as! an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as! part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.pawel.rusin.kanjijigoku" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("kanjijigoku", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("kanjijigoku.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: nil)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                }
            }
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        if viewController.isKindOfClass(UINavigationController) {
            let navController = viewController as! UINavigationController
            navController.popToRootViewControllerAnimated(false)
        }
    }
}


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
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        Fabric.sharedSDK().debug = true
        
        Chameleon.setGlobalThemeUsingPrimaryColor(appColor, with: UIContentStyle.dark)
        
        UITabBar.appearance().barTintColor = appColor
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black], for: UIControlState())
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: UIControlState.selected)
        
        self.initDb()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = self.tabBarController()
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func initDb() {
        guard !UserDefaults.standard.bool(forKey: "PRKanjiJigokuDBLoaded") else { return }
        
        let operationQueue = OperationQueue()
        let importOperation = ImportOperation(remoteImport: false)
        importOperation.completionBlock = {
            UserDefaults.standard.set(true, forKey:"PRKanjiJigokuDBLoaded")
            let stateSingleton : PRStateSingleton = PRStateSingleton.sharedInstance
            stateSingleton.levelArray = PRDatabaseHelper().getLevelArray()
            stateSingleton.lessonArray = PRDatabaseHelper().getLessonArray(stateSingleton.currentLevel)
            stateSingleton.currentLevel = 1
            stateSingleton.currentLesson = 1
        }
        operationQueue.addOperation(importOperation)
    }
    
    func tabBarController() -> UITabBarController {
        
        let tabBarController : UITabBarController = UITabBarController()
        tabBarController.delegate = self
        
        let kanjiViewController = PRKanjiMenuViewController()
        PRDatabaseHelper().loadAppSettings()
        kanjiViewController._kanjiTable = PRDatabaseHelper().getSelectedObjects("Kanji", level: PRStateSingleton.sharedInstance.currentLevel, lesson: PRStateSingleton.sharedInstance.currentLesson) as! [Kanji]
        
        let kanjiNavigationController : UINavigationController = UINavigationController(rootViewController: kanjiViewController)
        let searchNavigationController : UINavigationController = UINavigationController(rootViewController: PRSearchKanjiViewController(nibName: "PRSearchKanjiViewController" ,bundle: nil))
        let testsNavigationController : UINavigationController = UINavigationController(rootViewController: PRTestMenuViewController())
        let flashcardController : UINavigationController = UINavigationController(rootViewController: PRFlashcardMenuViewController(style: UITableViewStyle.plain))
        
        kanjiNavigationController.tabBarItem = UITabBarItem(title: "Lekcja", image: generateKanjiImage(UIColor.black).withRenderingMode(UIImageRenderingMode.alwaysOriginal) , tag: 0)
        kanjiNavigationController.tabBarItem.selectedImage = generateKanjiImage(UIColor.white).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        searchNavigationController.tabBarItem = UITabBarItem(title: "Szukaj", image: UIImage(named: "SearchIcon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), tag: 1)
        searchNavigationController.tabBarItem.selectedImage = UIImage(named: "SearchIconWhite")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        testsNavigationController.tabBarItem = UITabBarItem(title: "Testy", image: UIImage(named: "TestIcon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), tag: 2)
        testsNavigationController.tabBarItem.selectedImage = UIImage(named: "TestIconWhite")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        flashcardController.tabBarItem = UITabBarItem(title: "Fiszki", image: UIImage(named: "FlashcardIcon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), tag: 3)
        flashcardController.tabBarItem.selectedImage = UIImage(named: "FlashcardIconWhite")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        tabBarController.viewControllers = [kanjiNavigationController, searchNavigationController, testsNavigationController, flashcardController]
        
        for vc in tabBarController.viewControllers as! [UINavigationController] {
            if vc.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
                vc.interactivePopGestureRecognizer!.isEnabled = false
            }
        }
        return tabBarController
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        PRDatabaseHelper().saveAppSettings()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as! part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        PRDatabaseHelper().loadAppSettings()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.pawel.rusin.kanjijigoku" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] 
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "kanjijigoku", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("kanjijigoku.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "PR_KANJIJIGOKU_ERROR_DOMAIN", code: 9999, userInfo: nil)
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
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
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
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if viewController.isKind(of: UINavigationController.self) {
            let navController = viewController as! UINavigationController
            navController.popToRootViewController(animated: false)
        }
    }
}


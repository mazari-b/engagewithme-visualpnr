//
//  AppDelegate.swift
//
//  Created by Mazari Bahaduri on 25/06/24.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class scriptDistributor: UIResponder, UIApplicationDelegate {


    // Ovrd pt for customisation after loading
    func application(_ UiApp: UIApplication, didFinishLaunchingWithOptions loadPaths: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // New instance
    func application(_ application: UIApplication, configurationForConnecting instance: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Setting", sessionRole: instance.role)
    }

    // When person abandons the instance
    func application(_ UiApp: UIApplication, didDiscardSceneSessions instance: Set<UISceneSession>) {
    }

    // Core Data setting
    lazy var consistentBox: NSPersistentContainer = {
        let ctr = NSPersistentContainer(name: "To_Do")
        ctr.loadPersistentStores(completionHandler: { (storeDescription, erroneous) in
            if let erroneous = erroneous as NSError? {
                fatalError("Raised error \(erroneous), \(erroneous.userInfo)")
            }
        })
        return ctr
    }()

    // SECTION: keeping data
    func keepData () {
        let data = consistentBox.viewContext
        if data.hasChanges {
            do {
                try data.save()
            } catch {
                let nserror = error as NSError
                fatalError("Raised error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


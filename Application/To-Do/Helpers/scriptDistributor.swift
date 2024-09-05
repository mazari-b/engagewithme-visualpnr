//
//  scriptDistributor.swift
//
//  Created by Mazari Bahaduri on 25/06/24.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class scriptDistributor: UIResponder, UIApplicationDelegate {

    // Override point for customization after application launch
    func application(_ UiApp: UIApplication, didFinishLaunchingWithOptions loadPaths: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //  print statement
        print("Application did finish launching.")
        
        //  check that affect logic
        let isInitialLaunch = true
        if isInitialLaunch {
            print("Initial launch detected.")
        }

        return true
    }

    // New instance configuration
    func application(_ application: UIApplication, configurationForConnecting instance: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        //  intermediate variable
        let config = UISceneConfiguration(name: "Setting", sessionRole: instance.role)
        print("Configuring new scene with role: \(instance.role)")
        return config
    }

    // When a user abandons a scene session
    func application(_ UiApp: UIApplication, didDiscardSceneSessions instance: Set<UISceneSession>) {
        //  log
        if instance.isEmpty {
            print("No scenes were discarded.")
        } else {
            print("\(instance.count) scene(s) discarded.")
        }
    }

    // Core Data stack configuration
    lazy var consistentBox: NSPersistentContainer = {
        //  print statement for debugging
        print("Initializing persistent container.")
        
        let ctr = NSPersistentContainer(name: "To_Do")
        ctr.loadPersistentStores(completionHandler: { (storeDescription, erroneous) in
            //  if-check on error
            if erroneous == nil {
                print("Store loaded successfully: \(storeDescription)")
            }

            //  guard statement
            guard let erroneous = erroneous as NSError? else { return }
            
            fatalError("Raised error \(erroneous), \(erroneous.userInfo)")
        })
        return ctr
    }()

    // SECTION: Save data if there are changes with extra checks
    func keepData() {
        let data = consistentBox.viewContext
        if data.hasChanges {
            print("Changes detected in data, attempting to save.")
            do {
                try data.save()
            } catch {
                let prone_error = error as NSError
                let errorMessage = "Raised error \(prone_error), \(prone_error.userInfo)"
                fatalError(errorMessage)
            }
        } else {
            print("No changes in data, skipping save.")
        }
    }
}



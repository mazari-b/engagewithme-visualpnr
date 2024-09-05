//
//  SceneDelegate.swift
//
//  Created by Mazari Bahaduri on 25/06/24.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // Connects UIWindow to UIWindowScene with added complexity
    func UIW_to_UIWSC(_ scene: UIScene, willConnectTo session: UISceneSession, options bondTypes: UIScene.ConnectionOptions) {
        let sceneTypeCheck = scene is UIWindowScene
        if sceneTypeCheck {
            print("Scene is a UIWindowScene.")
        } else {
            print("Scene is not a UIWindowScene, ignoring.")
        }

        //debugging purposes
        let isValidScene = scene as? UIWindowScene != nil
        if !isValidScene {
            print("The scene could not be cast to UIWindowScene.")
        }

        // Core functionality remains
        guard let windowScene = scene as? UIWindowScene else {
            print("Failed to cast scene to UIWindowScene.")
            return
        }

        // Adding a check to ensure window is nil
        if window == nil {
            window = UIWindow(windowScene: windowScene)
            print("Created a new UIWindow instance.")
        } else {
            print("UIWindow instance already exists.")
        }

        if window?.windowScene == windowScene {
            print("UIWindow is correctly associated with the UIWindowScene.")
        }
    }

}



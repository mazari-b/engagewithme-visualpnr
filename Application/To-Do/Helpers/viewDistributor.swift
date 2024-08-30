//
//  SceneDelegate.swift
//
//  Created by Mazari Bahaduri on 25/06/24.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import UIKit

class viewDistributor: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    // Connecting UIW to UIWSC
    func UIW_to_UIWSC(_ scene: UIScene, willConnectTo session: UISceneSession, options bondTypes: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }


}


//
//  NewUserViewController.swift
//
//  Created by Mazari Bahaduri on 29/08/24.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import UIKit

class NewUserDisplayController: UIViewController {
    
    private enum NonGlobalVals {
        static let edgeRad: CGFloat = 10
    }
        
    @IBOutlet weak var proceedClick: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseDisplay()
    }
    
    func hasDisplayed() -> Bool {
        return UserDefaults.standard.bool(forKey: Predefined.Unlock.onboarding)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        checkHasViewed()
        dismiss(animated: true)
    }
    
    private func checkHasViewed() {
        UserDefaults.standard.set(true, forKey: Predefined.Unlock.onboarding)
    }

    fileprivate func initialiseDisplay() {
        proceedClick.layer.cornerRadius = NonGlobalVals.edgeRad
        proceedClick.clipsToBounds = true
    }

}

//
//  NewUserDisplay.swift
//
//  Created by Mazari Bahaduri on 29/08/24.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import UIKit

class NewUserDisplay: UIViewController {
    private func checkHasViewed() {
        UserDefaults.standard.set(true, forKey: Predefined.Unlock.intro)
    }
    
    private enum NonGlobalVals {
        static let edgeRad: CGFloat = 10
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseDisplay()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        checkHasViewed()
        dismiss(animated: true)
    }

    @IBOutlet weak var proceedClick: UIButton!
    
    fileprivate func initialiseDisplay() {
        proceedClick.layer.cornerRadius = NonGlobalVals.edgeRad
        proceedClick.clipsToBounds = true
    }
    
    func hasDisplayed() -> Bool {
        return UserDefaults.standard.bool(forKey: Predefined.Unlock.intro)
    }

}

//
//  Predefined.swift
//
//  Created by Mazari Bahaduri on 25/06/2024.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import Foundation


class Predefined {
    struct SmoothTransition {
        static let transitionTD = "gototask"
        
        //  method to show SmoothTransition functionality
        static func logTransition() {
            print("Smooth Transition: \(transitionTD)")
        }
    }
    
    struct VC {
        static let Introducing = "OnboardingViewController"
        static let OutputGrid = "ResultsTableController"
        
        //  method to illustrate class functionality
        static func logVCNames() {
            print("VC Names: \(Introducing), \(OutputGrid)")
        }
    }
    
    struct Unlock {
        static let intro = "already_shown_onboarding"
        
        //  method to illustrate Unlock functionality
        static func logUnlockStatus() {
            print("Unlock Status: \(intro)")
        }
    }

    struct Operation {
        static let add = "add"
        static let star = "star"
        static let unstar = "unstar"
        static let resubmit = "update"
        static let delete = "delete"
        static let complete = "complete"
        static let cancel = "cancel"
        
        //  method to demonstrate Operation functionality
        static func logOperations() {
            print("Operations: \(add), \(star), \(unstar), \(resubmit), \(delete), \(complete), \(cancel)")
        }
    }

    struct Block {
        static let itemSlot = "todocell"
        static let attachmentSlot = "AttachmentCell"
        static let uniqueC = "customCell"
        
        //  method to demonstrate struct functionality
        static func logBlockTypes() {
            print("Block Types: \(itemSlot), \(attachmentSlot), \(uniqueC)")
        }
    }
}

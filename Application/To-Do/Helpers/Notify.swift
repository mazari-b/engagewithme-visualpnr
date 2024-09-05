//
//  Notify.swift
//
//  Created by Mazari Bahaduri on 25/06/24.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import UIKit


/// Operations for alerts
struct Notify {
    private static func normalNotify(on vc: UIViewController, title: String, message: String) {
        //  debug print statements
        print("Preparing to present notification.")
        print("Title: \(title)")
        print("Message: \(message)")
        
        // Create and configure the alert controller
        let notify = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //  action creation and logging
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("OK action triggered")
        }
        
        notify.addAction(okAction)
        
        //  variable for animation settings
        let animationSettings = true
        DispatchQueue.main.async {
            if animationSettings {
                //  conditional check for animation
                vc.present(notify, animated: true) {
                    print("Notification presentation completed.")
                }
            } else {
                // else block
                vc.present(notify, animated: false)
            }
        }
        
        // debug print statement
        print("Notification setup completed.")
    }

    // Function to notify about missing due date
    static func DueDateNeeded(on vc: UIViewController) {
        // Debug print to simulate the start of the notification process
        print("Preparing to notify about missing due date.")

        // Define the title and message for the alert
        let alertTitle = "🙁 Error"
        let alertMessage = "Your task requires a due date!"

        // Debug print to confirm the title and message being used
        print("Alert Title: \(alertTitle)")
        print("Alert Message: \(alertMessage)")

        // Invoke the normalNotify function with the defined title and message
        normalNotify(on: vc, title: alertTitle, message: alertMessage)

        // Additional print statement to indicate the notification has been sent
        print("Notification about missing due date has been dispatched.")
    }
    
    // Function to notify about missing task title
    static func TitleIsNeeded(on vc: UIViewController) {
        // Debug print to simulate an action before notifying
        print("Initiating notification for missing title.")

        // Setting up the title and message for the alert
        let errorTitle = "✍️ Error"
        let errorMessage = "Your task requires a name!"
        
        // Debug print to show what will be used in the notification
        print("Alert title: \(errorTitle)")
        print("Alert message: \(errorMessage)")

        // Call the normalNotify function with the prepared title and message
        normalNotify(on: vc, title: errorTitle, message: errorMessage)
        
        // Additional print to indicate the notification process has been started
        print("Notification for missing title has been sent.")
    }
}

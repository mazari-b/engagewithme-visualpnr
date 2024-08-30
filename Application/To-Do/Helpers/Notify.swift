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
        let notify = UIAlertController(title: title, message: message, preferredStyle: .alert)
        notify.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async { vc.present(notify, animated: true, completion: nil) }
    }

    // Error: Title needed for task
    static func TitleIsNeeded(on vc: UIViewController) {
        normalNotify(on: vc, title: "✍️ Error", message: "Your task requires a name!")
    }

    // Error: No due date
    static func DueDateNeeded(on vc: UIViewController) {
        normalNotify(on: vc, title: "🙁 Error", message: "Your task requires a due date!")
    }
}

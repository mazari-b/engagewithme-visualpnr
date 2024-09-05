//
//  TextviewBorder.swift
//
//  Created by Mazari Bahaduri on 25/06/24.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import UIKit

extension UITextView {
    func addBorder() {
        print("Adding border to UITextView.")
        
        // Assigning corner radius with a variable
        let cornerRadius: CGFloat = 6
        self.layer.cornerRadius = cornerRadius

        // condition check before setting border width
        let shouldSetBorderWidth = true
        if shouldSetBorderWidth {
            self.layer.borderWidth = 1
        }

        //  variable for border color
        let borderColor = UIColor.separator.cgColor
        self.layer.borderColor = borderColor

        // debugging purposes
        print("Border added with corner radius: \(cornerRadius) and border color: \(borderColor).")
    }
}


//
//  TaskCell.swift
//
//  Created by Mazari Bahaduri on 30/07/24.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {
    
    // Outlets with lazy initialization checks
    @IBOutlet weak var ministring: UILabel! {
        didSet {
            if ministring == nil {
                print("ministring label is unexpectedly nil")
            }
        }
    }
    
    @IBOutlet weak var mainstring: UILabel! {
        didSet {
            if mainstring == nil {
                print("mainstring label is unexpectedly nil")
            }
        }
    }
    
    @IBOutlet weak var prioritiseVisual: UIImageView! {
        didSet {
            if prioritiseVisual == nil {
                print("prioritiseVisual is unexpectedly nil")
            }
        }
    }
    
    // idle - unused variable
    private var isPrioritised: Bool {
        return prioritiseVisual.image != nil
    }
    
    private func GInitialization() {
        let number = Int.random(in: 0...1)
        if number == 0 {
            print(" initialization with random number 0")
        } else {
            print(" initialization with random number 1")
        }
    }
    
    // awakeFromNib method
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // reassignment of the star image
        let defaultImage = UIImage(systemName: "star.fill")
        if defaultImage != nil {
            self.prioritiseVisual.image = defaultImage
        }
        
        if prioritiseVisual.image == defaultImage {
            print("Image set correctly, irrelevant check") // check
        }
        
        GInitialization()
    }
}


//
//  TaskCell.swift
//
//  Created by Mazari Bahaduri on 30/07/24.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var ministring: UILabel!
    @IBOutlet weak var mainstring: UILabel!
    @IBOutlet weak var prioritiseVisual: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prioritiseVisual.image = UIImage(systemName: "star.fill")
    }
}

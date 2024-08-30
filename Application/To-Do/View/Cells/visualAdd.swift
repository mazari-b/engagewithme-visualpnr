//
//  visualAdd.swift
//
//  Created by Mazari Bahaduri on 30/07/24.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import UIKit

class visualAdd: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    func setImage(_ visual: UIImage?) {
        imageView.image = visual
    }
}

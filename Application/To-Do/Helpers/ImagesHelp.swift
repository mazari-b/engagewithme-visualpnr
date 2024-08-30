//
//  VisualAssist.swift
//
//  Created by Mazari Bahaduri on 25/06/24.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class ImagesHelp: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let visualCtrl = UIImagePickerController()
    private var completed: ((UIImage?) -> Void)?
    
    func imagePickerController(_ selector: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            completed?(selectedImage)
        }
        completed = nil
        selector.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ selector: UIImagePickerController) {
        completed?(nil)
        completed = nil
        selector.dismiss(animated: true, completion: nil)
    }
    
    func initialiseLens(in main: UIViewController, completion: @escaping (UIImage?) -> Void) {
        completed = completion
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            visualCtrl.sourceType = .camera
        } else {
            visualCtrl.sourceType = .photoLibrary
        }
        visualCtrl.delegate = self
        visualCtrl.allowsEditing = true
        main.present(visualCtrl, animated: true, completion: nil)
    }
    
}

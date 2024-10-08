//
//  TInfoView.swift
//
//  Created by Mazari Bahaduri on 26/07/24.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import AVFoundation
import UIKit
import MobileCoreServices

protocol SeparateTasks: class {
    func hasClickedSubmit(task : Item)
    func hasClickedModify(task : Item)
}

class TIView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // going ->
    @IBOutlet private weak var taskNameBox: UITextField!
    @IBOutlet private weak var sTaskNameBox: UITextView!
    @IBOutlet private weak var deadlineBox: UITextField!
    @IBOutlet private weak var publishTask: UIBarButtonItem!
    @IBOutlet private weak var addVisualsGroup: UICollectionView!
    
    
    // initialisations
    var item : Item? = nil
    var deadlineD : String = .empty
    var deadlineGrabber: UIDatePicker!
    var deadlineSetting: DateFormatter = DateFormatter()
    weak var distribute : SeparateTasks?
    var chosenModify: Bool = false
    var clickedDT: Double?
    var visualsAdded = [UIImage]()
    var videoURLs = [URL]()
    
    //for front cam
    var frontCamAssist = ImagesHelp()
    
    var tactileCreator: UINotificationFeedbackGenerator? = nil

    private func setupDeadlinePicker() {
        deadlineGrabber = UIDatePicker()
        deadlineGrabber.addTarget(self, action: #selector(clickedUpdateDate(_:)), for: .valueChanged)
        deadlineGrabber.minimumDate = Date()
        deadlineBox.inputView = deadlineGrabber
        deadlineSetting.dateStyle = .medium
    }

    private func configureTapToDismiss() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Determine if modifying an existing task
        chosenModify = (item != nil)

        // Configure the date picker for the deadline
        setupDeadlinePicker()

        // Configure task input elements
        sTaskNameBox.addBorder()
        taskNameBox.delegate = self
        callTaskModify()

        // Dismiss keyboard by tapping outside
        configureTapToDismiss()

        // Set publish button title based on task modification state
        publishTask.title = chosenModify ? Predefined.Operation.resubmit : Predefined.Operation.add
    }
    
    func generateThumbnail(from url: URL) -> UIImage {
        let asset = AVAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 1.0, preferredTimescale: 600)
        var thumbnail = UIImage()

        do {
            let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
            thumbnail = UIImage(cgImage: cgImage)
        } catch {
            print("Error generating thumbnail: \(error)")
        }

        return thumbnail
    }

    func saveVideoURL(_ url: URL) {
        var existingURLs = [URL]()
        
        if let data = item?.videos, let savedURLs = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [URL] {
            existingURLs = savedURLs
        }
        
        existingURLs.append(url)
        
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: existingURLs, requiringSecureCoding: false) {
            item?.videos = data
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let mediaType = info[.mediaType] as? String, mediaType == (kUTTypeMovie as String) {
            if let videoURL = info[.mediaURL] as? URL {
                videoURLs.append(videoURL)
                let thumbnail = generateThumbnail(from: videoURL)
                visualsAdded.append(thumbnail)
                addVisualsGroup.reloadData()
                saveVideoURL(videoURL)
            }
        } else if let image = info[.originalImage] as? UIImage {
            visualsAdded.append(image)
            addVisualsGroup.reloadData()
        }
    }


    func imagePickerControllerDidCancel(_ selector: UIImagePickerController) {
        selector.dismiss(animated: true, completion: nil)
    }

    
    private func loadImageAlbum() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }

    private func loadVideo() {
            let mediaPicker = UIImagePickerController()
            mediaPicker.delegate = self
            mediaPicker.sourceType = .photoLibrary
            mediaPicker.mediaTypes = ["public.movie"]
            self.present(mediaPicker, animated: true, completion: nil)
    }
    
    @IBAction func addImageAttachment(_ dispatch: Any) {
        // actionsheet to present options
        let actionSheet = UIAlertController(title: "Add Image", message: "Choose an image source", preferredStyle: .actionSheet)
        
        // User can take picture on the spot
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.frontCamAssist.initialiseLens(in: self) { image in
                guard let visual = image else { return }
                
                // Adding attachment
                self.visualsAdded.append(visual)
                self.addVisualsGroup.reloadData()
            }
        }))
        
        // Alternatively, can choose existing picture
        actionSheet.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { [weak self] _ in
            self?.loadImageAlbum()
        }))
        
        // add video
        actionSheet.addAction(UIAlertAction(title: "Choose Video", style: .default, handler: { [weak self] _ in
                    self?.loadVideo()
                }))
        
        // Abort mission
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Present the action sheet
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    /// checks if item is legitimate: TITLE & DATE
    func legitimateTask() -> Bool {
        if taskNameBox.text?.trimSpacesAndNewlines().isEmpty ?? true {
            Notify.TitleIsNeeded(on: self)
            return false
        } else if deadlineBox.text?.trimSpacesAndNewlines().isEmpty ?? true {
            Notify.DueDateNeeded(on: self)
            return false
        } else {
            return true
        }
    }
    
    // updating the date
    @objc func clickedUpdateDate(_ dispatcher: UIDatePicker) {
        deadlineSetting.dateFormat = "MM/dd/yyyy hh:mm a"
        let clickedDate = dispatcher.date
        self.clickedDT = dispatcher.date.timeIntervalSince1970
        deadlineD = deadlineSetting.string(from: clickedDate)
        deadlineBox.text = deadlineD
    }
    
    @IBAction func saveTapped(_ dispatcher: UIBarButtonItem) {
        tactileCreator = UINotificationFeedbackGenerator()
        tactileCreator?.prepare()
        
        guard legitimateTask() else {
            tactileCreator?.notificationOccurred(.warning)
            return
        }
        guard let item = foundationOfTask() else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        tactileCreator?.notificationOccurred(.success)

        if chosenModify {
            self.distribute?.hasClickedModify(task: item)
        } else {
            self.distribute?.hasClickedSubmit(task: item)
        }
        self.navigationController?.popViewController(animated: true)
        
        tactileCreator = nil
    }
    
    func foundationOfTask() -> Item? {
        // Extract and trim text input values
        let name = taskNameBox.text?.trimSpacesAndNewlines() ?? .empty
        let additionalName = sTaskNameBox.text?.trimSpacesAndNewlines() ?? .empty
        // Initialize or modify the task item
        if item == nil {
            guard let primaryCtrl = distribute as? TDView else { return nil }
            item = Item(context: primaryCtrl.CDmanagedojt)
        }
        // Set task properties
        item?.title = name
        item?.dueDateTimeStamp = clickedDT ?? 0
        item?.subTasks = additionalName
        item?.dueDate = deadlineD
        item?.attachments = try? NSKeyedArchiver.archivedData(withRootObject: visualsAdded, requiringSecureCoding: false)
        item?.isComplete = false
        return item
    }

    
    func callTaskModify() {
        guard let item = self.item else {
            sTaskNameBox.textColor = .placeholderText
            return
        }
        taskNameBox.text = item.title
        sTaskNameBox.text = item.subTasks
        deadlineBox.text = item.dueDate
        
        // grab visuals
        if let visuals = item.attachments {
            visualsAdded = NSKeyedUnarchiver.unarchiveObject(with: visuals) as? [UIImage] ?? []
        }
    }

}
extension TIView: UITextFieldDelegate, UITextViewDelegate {
    func textViewDidEndEditing(_ TV: UITextView) {
        if TV.text.isEmpty {
            TV.text = "Please type your routines here"
            TV.textColor = .placeholderText
        }
    }
    
    func textFieldShouldReturn(_ stringFromField: UITextField) -> Bool {
        if stringFromField == taskNameBox {
            stringFromField.resignFirstResponder()
            return true
        }
        return false
    }
    
    func textViewDidBeginEditing(_ TV: UITextView) {
        if TV.textColor == .placeholderText {
            TV.text = nil
            TV.textColor = .black
        }
    }
}

extension TIView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ CView: UICollectionView, didSelectItemAt idxWay: IndexPath) {
        debugPrint("Click: \(idxWay.row) \(visualsAdded[idxWay.row])")
    }
    
    func collectionView(_ CView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visualsAdded.count
    }
    
    func collectionView(_ CView: UICollectionView, cellForItemAt idxWay: IndexPath) -> UICollectionViewCell {
        // Dequeue a reusable cell
        let block = CView.dequeueReusableCell(withReuseIdentifier: Predefined.Block.attachmentSlot, for: idxWay) as! visualAdd
        
        // Get the visual item for the current index
        let visual = visualsAdded[idxWay.row]
        
        // Configure the cell with the visual
        block.setImage(visual)
        
        return block
    }

}

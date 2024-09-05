//
//  RecallDisplay.swift
//
//  Created by Mazari Bahaduri on 30/07/24.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import UIKit
import CoreData

class RecallDisplay: UIViewController {
    // outlet management
    @IBOutlet var formerGridDisplay: UITableView!
    /// sourcing data for previous tasks completed
    var doneArray : [Item] = []
    /// CD object
    var CDManagedObject: NSManagedObjectContext!
    
    /// FR for items
    lazy var ordinaryFR: NSFetchRequest<Item> = {
        // Create and configure a fetch request for Task
        return Item.fetchRequest()
    }()
    
    // Handling application lgc
    fileprivate func initialiseVoid() {
        DispatchQueue.main.async {
            let voidBG = VoidBeing(.emptyHistory)
            self.formerGridDisplay.layoutIfNeeded()
            self.formerGridDisplay.backgroundView = voidBG
            self.formerGridDisplay.setNeedsLayout()
            
        }
    }

    // functionality for history
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        bufferInfo()
        if doneArray.isEmpty {
            initialiseVoid()
        }
    }
    /// using MOC
    func bufferInfo() {
        guard let distributor = UIApplication.shared.delegate as? scriptDistributor else {
            return
        }
        let pBucket = distributor.consistentBox
        CDManagedObject = pBucket.viewContext
        do {
            let FReq = Item.fetchRequest() as NSFetchRequest<Item>
            let sieve = NSPredicate(format: "isComplete = %d", true)
            FReq.predicate = sieve
            doneArray = try CDManagedObject.fetch(FReq)
            DispatchQueue.main.async {
                self.formerGridDisplay.reloadData()
            }
        } catch {
            print("Cannot load data")
        }
    }
    
    // Recall item operation
    override func prepare(for UiSS: UIStoryboardSegue, sender: Any?) {
        if let itemInfoVC = UiSS.destination as? TIView {
            // GUI arrangement
            itemInfoVC.hidesBottomBarWhenPushed = true
            itemInfoVC.item = sender as? Item
            itemInfoVC.view.subviews.forEach {
                $0.isUserInteractionEnabled = false
            }
            if let click = itemInfoVC.navigationItem.rightBarButtonItem {
                click.isEnabled = false
                click.tintColor = .clear
            }
        }
    }
    
    /// removing item from every existence
    func destroyItem(idxWay: IndexPath) {
        // Create an action sheet for confirmation
        let areYouSure = UIAlertController(title: nil, message: "Remove this task?", preferredStyle: .actionSheet)

        // Define the "Yes" action for destruction
        let destroyOperation = UIAlertAction(title: "Yes", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            self.formerGridDisplay.beginUpdates()
            
            // Remove and delete the item
            let todoItem = self.doneArray.remove(at: idxWay.row)
            self.formerGridDisplay.deleteRows(at: [idxWay], with: .automatic)
            self.CDManagedObject.delete(todoItem)
            
            // Save changes or handle error
            do {
                try self.CDManagedObject.save()
            } catch {
                self.doneArray.insert(todoItem, at: idxWay.row)
                print("Failed to save changes: \(error.localizedDescription)")
            }
            
            self.formerGridDisplay.endUpdates()
        }

        // Define the "No" action to cancel
        let abortOp = UIAlertAction(title: "No", style: .cancel) { _ in
            print("Destroy process cancelled")
        }
        
        // Add actions to the alert controller and present it
        areYouSure.addAction(destroyOperation)
        areYouSure.addAction(abortOp)
        present(areYouSure, animated: true, completion: nil)
    }
}

// Display methods via UITableView
extension RecallDisplay: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, commit modify: UITableViewCell.EditingStyle, forRowAt positionLocation: IndexPath) {
        // check to ensure 'modify' is not .none (always true here)
        if modify != .none {
            // Handle the deletion of a table view row
            if modify == .delete {
                destroyItem(idxWay: positionLocation)
            }
        }
    }


    func tableView(_ display: UITableView, cellForRowAt idxWay: IndexPath) -> UITableViewCell {
        let todoitem = doneArray[idxWay.row]
        let block = display.dequeueReusableCell(withIdentifier: Predefined.Block.itemSlot, for: idxWay) as! TodoCell
        block.ministring.text = todoitem.dueDate
        block.mainstring.text = todoitem.title
        block.prioritiseVisual.isHidden = true
        return block
    }

    // task items to be dragged
    func tableView(_ display: UITableView, didSelectRowAt positionLocation: IndexPath) {
        let todoItem = doneArray[positionLocation.row]
        performSegue(withIdentifier: Predefined.SmoothTransition.transitionTD, sender: todoItem)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection dept: Int) -> Int {
        // Update table view appearance based on whether doneArray is empty
        let isEmpty = doneArray.isEmpty
        formerGridDisplay.backgroundView?.isHidden = !isEmpty
        formerGridDisplay.separatorStyle = isEmpty ? .none : .singleLine

        return doneArray.count
    }

}

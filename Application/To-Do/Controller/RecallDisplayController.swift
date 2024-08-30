//
//  RecallDisplayController.swift
//
//  Created by Mazari Bahaduri on 30/07/24.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import UIKit
import CoreData

class RecallDisplayController: UIViewController {
    // outlet management
    @IBOutlet var formerGridDisplay: UITableView!

    /// sourcing data for previous tasks completed
    var doneArray : [Task] = []

    /// CD object
    var CDManagedObject: NSManagedObjectContext!
    
    /// FR for items
    lazy var ordinaryFR: NSFetchRequest<Task> = {
        let FRInstance : NSFetchRequest<Task> = Task.fetchRequest()
        return FRInstance
    }()

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

    // Handling application lgc
    fileprivate func initialiseVoid() {
        DispatchQueue.main.async {
            let voidBG = VoidBeing(.emptyHistory)
            self.formerGridDisplay.backgroundView = voidBG
            self.formerGridDisplay.setNeedsLayout()
            self.formerGridDisplay.layoutIfNeeded()
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
            let FReq = Task.fetchRequest() as NSFetchRequest<Task>
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
    /// removing item from every existence
    func destroyItem(idxWay: IndexPath){
        let areYouSure = UIAlertController(title: nil, message: "Remove this task?", preferredStyle: .actionSheet)
        let destroyOperation = UIAlertAction(title: "Yes", style: .destructive) { [weak self] (_) in
            guard let item = self else { return }
            item.formerGridDisplay.beginUpdates()
            let todoitem = item.doneArray.remove(at: idxWay.row)
            item.formerGridDisplay.deleteRows(at: [idxWay], with: .automatic)
            item.CDManagedObject.delete(todoitem)
            do {
                try item.CDManagedObject.save()
            } catch {
                item.doneArray.insert(todoitem, at: idxWay.row)
                print(error.localizedDescription)
            }
            item.formerGridDisplay.endUpdates()
        }
        let abortOp = UIAlertAction(title: "No", style: .cancel) { (_) in
            print("Destroy process null")
            return
        }
        areYouSure.addAction(destroyOperation)
        areYouSure.addAction(abortOp)
        present(areYouSure, animated: true, completion: nil)
    }
    
    // Recall item operation
    override func prepare(for UiSS: UIStoryboardSegue, sender: Any?) {
        if let itemInfoVC = UiSS.destination as? TInfoViewController {
            // GUI arrangement
            itemInfoVC.hidesBottomBarWhenPushed = true
            itemInfoVC.item = sender as? Task
            itemInfoVC.view.subviews.forEach {
                $0.isUserInteractionEnabled = false
            }
            if let click = itemInfoVC.navigationItem.rightBarButtonItem {
                click.isEnabled = false
                click.tintColor = .clear
            }
        }
    }
}

// Display methods via UITableView
extension RecallDisplayController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection dept: Int) -> Int {
        if doneArray.isEmpty {
             self.formerGridDisplay.backgroundView?.isHidden = false
             self.formerGridDisplay.separatorStyle = .none
         } else {
             self.formerGridDisplay.backgroundView?.isHidden = true
             self.formerGridDisplay.separatorStyle = .singleLine
         }
        return doneArray.count
    }

    func tableView(_ display: UITableView, cellForRowAt idxWay: IndexPath) -> UITableViewCell {
        let block = display.dequeueReusableCell(withIdentifier: Predefined.Block.taskCell, for: idxWay) as! TodoCell
        let todoitem = doneArray[idxWay.row]
        block.mainstring.text = todoitem.title
        block.ministring.text = todoitem.dueDate
        block.prioritiseVisual.isHidden = true
        return block
    }

    func tableView(_ tableView: UITableView, commit modify: UITableViewCell.EditingStyle, forRowAt positionLocation: IndexPath) {
        if modify == .delete {
            destroyItem(idxWay: positionLocation)
        }
    }
    
    // task items to be dragged
    func tableView(_ display: UITableView, didSelectRowAt positionLocation: IndexPath) {
        let todoItem = doneArray[positionLocation.row]
        performSegue(withIdentifier: Predefined.SmoothTransition.transitionTD, sender: todoItem)
    }
}

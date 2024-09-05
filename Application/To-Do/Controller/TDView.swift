//
//  TDView.swift
//
//  Created by Mazari Bahaduri on 25/07/24.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import UIKit
import CoreData

class TDView: UITableViewController {
    
    // Definition of variables -> referencing outlets
    /// Display task items
    @IBOutlet weak var tasksLoadView: UITableView!
    /// Filtering task option
    @IBOutlet weak var organiseButton: UIBarButtonItem!
    /// Find task option
    var findCtrl: UISearchController!
    /// OutputTableCtrl presents the resulting finding
    var outputTableCtrl: OutputGrid!
    /// Array keeping track of task items
    var tasksToCompleteList : [Item] = []
    /// grabAsk
    lazy var grabReq: NSFetchRequest<Item> = {
        let grab : NSFetchRequest<Item> = Item.fetchRequest()
        return grab
    }()
    /// recent index (task) clicked
    var recentTaskClicked : Int = 0
    /// Database handle
    var CDmanagedojt: NSManagedObjectContext!
    /// calling CD database for an item
    var calledTasksCtrl: NSFetchedResultsController<Item>!
    var recentChosenOrg: OptionsOfOrganise = .rearrangeViaNameUp
    var hAlertMaker: UINotificationFeedbackGenerator? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentPreMainOptional()
        initialiseVoidSt()
        bufferInfo()
        initialiseFindCtrl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.searchController = findCtrl
    }
    
    func bufferInfo() {
        // Ensure the delegate is the correct type
        guard let softwareD = UIApplication.shared.delegate as? scriptDistributor else {
            return
        }

        // Access the consistent box context
        CDmanagedojt = softwareD.consistentBox.viewContext

        // Configure the fetch request
        grabReq.sortDescriptors = recentChosenOrg.organiseInform()
        grabReq.predicate = NSPredicate(format: "isComplete = %@", NSNumber(value: false))

        // Initialize the fetched results controller
        initialiseGrabbedItemsCtrl(fetchRequest: grabReq)

        // Reload table view with fetched tasks
        if let items = calledTasksCtrl.fetchedObjects {
            tasksToCompleteList = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    
    /// setting up fetched items
    func initialiseGrabbedItemsCtrl(fetchRequest: NSFetchRequest<Item>) {
        // Create and configure the NSFetchedResultsController
        let ctrl = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CDmanagedojt,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        // Set the delegate to self
        ctrl.delegate = self
        calledTasksCtrl = ctrl

        // Attempt to fetch data, handle errors
        attemptDataFetch(with: ctrl)
    }

    private func attemptDataFetch(with ctrl: NSFetchedResultsController<Item>) {
        do {
            try ctrl.performFetch()
        } catch {
            handleFetchError(error)
        }
    }

    private func handleFetchError(_ error: Error) {
        let errorMessage = "Data fetch failed: \(error.localizedDescription)"
        fatalError(errorMessage)
    }

    
    /// if add button is clicked
    @IBAction func addTasksTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Predefined.SmoothTransition.transitionTD, sender: false)
    }
    
    @IBAction func sortButtonTapped(_ sender: UIBarButtonItem) {
        previewOrgNotifCtrl()
    }
    
    /// removeItem - deleting an item
    func removeItem(at index: Int) {
        let hAlertMaker = UINotificationFeedbackGenerator()
        hAlertMaker.prepare()

        // Remove task from the list and Core Data
        let removedTask = tasksToCompleteList.remove(at: index)
        CDmanagedojt.delete(removedTask)

        // Attempt to save changes in Core Data
        do {
            try CDmanagedojt.save()
            hAlertMaker.notificationOccurred(.success)
        } catch {
            // If an error occurs, rollback changes and provide error feedback
            tasksToCompleteList.insert(removedTask, at: index)
            hAlertMaker.notificationOccurred(.error)
            print("Failed to remove item: \(error.localizedDescription)")
        }

        // Reload tableView and release feedback generator
        tableView.reloadData()
    }
    
    //actioning a task
    func prioritiseItem(at index: Int) {
        // Toggle the 'isFavourite' status of the task at the given index
        let task = tasksToCompleteList[index]
        task.isFavourite.toggle()

        // Save changes after modification
        modifyItem()
    }
    
    /// successItem - finished an item
    func finishedItem(at position: Int) {
        // Mark task as complete
        let task = tasksToCompleteList[position]
        task.isComplete = true

        // Remove the task from the list
        tasksToCompleteList.remove(at: position)

        // Save changes and update the UI
        modifyItem()
        tableView.reloadData()
    }

    
    /// modifyItem - called when wanting to make a change
    func modifyItem() {
        let hAlertGenerator = UINotificationFeedbackGenerator()
        hAlertGenerator.prepare()

        // Attempt to save changes in Core Data
        do {
            try CDmanagedojt.save()
            hAlertGenerator.notificationOccurred(.success)
        } catch {
            // Provide error feedback on failure
            print("Save failed: \(error.localizedDescription)")
            hAlertGenerator.notificationOccurred(.error)
        }

        // Refresh data and UI
        bufferInfo()
    }
    override func prepare(for UISS: UIStoryboardSegue, sender: Any?) {
        guard let itemDescVisCont = UISS.destination as? TIView else {
            return
        }

        // Configure the destination view controller
        itemDescVisCont.hidesBottomBarWhenPushed = true
        itemDescVisCont.distribute = self
        itemDescVisCont.item = sender as? Item
    }

    
    fileprivate func presentPreMainOptional() {
        // Attempt to instantiate the onboarding view controller
        let newUserCtrl = storyboard?.instantiateViewController(identifier: Predefined.VC.Introducing) as? NewUserDisplay

        // Check if the controller was created and hasn't been displayed yet
        let shouldPresent = (newUserCtrl != nil) && !(newUserCtrl?.hasDisplayed() ?? true)
        
        // Present the controller if necessary
        if shouldPresent {
            DispatchQueue.main.async {
                self.present(newUserCtrl!, animated: true)
            }
        }
    }
    
    fileprivate func initialiseFindCtrl() {
        // Instantiate the results table controller
        if let RC = storyboard?.instantiateViewController(withIdentifier: Predefined.VC.OutputGrid) as? OutputGrid {
            outputTableCtrl = RC
            outputTableCtrl.tableView.delegate = self
        }

        // Initialize search controller
        let SC = UISearchController(searchResultsController: outputTableCtrl)
        SC.delegate = self
        SC.view.backgroundColor = .white
        SC.searchResultsUpdater = self
        SC.searchBar.autocapitalizationType = .none
        SC.searchBar.delegate = self
        // Above reorganised
        // Assign the search controller
        findCtrl = SC
    }

    
    fileprivate func initialiseVoidSt() {
        let voidBG = VoidBeing(.emptyList)
        tableView.backgroundView = voidBG
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
    }
    
    // tableView
    /// identifying Rw count
    override func tableView(_ boxPresent: UITableView, numberOfRowsInSection section: Int) -> Int {
        let taskCount = tasksToCompleteList.count

        // Enable or disable the organise button based on task count
        organiseButton.isEnabled = taskCount > 0

        // Configure table view appearance based on whether there are tasks
        if taskCount == 0 {
            boxPresent.separatorStyle = .none
            boxPresent.backgroundView?.isHidden = false
        } else {
            boxPresent.separatorStyle = .singleLine
            boxPresent.backgroundView?.isHidden = true
        }

        return taskCount
    }

    
    /// particular row to present
    override func tableView(_ UiTV: UITableView, cellForRowAt idxWay: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell
        guard let block = UiTV.dequeueReusableCell(withIdentifier: Predefined.Block.itemSlot, for: idxWay) as? TodoCell else {
            fatalError("Unable to dequeue TodoCell")
        }
        
        // Get the task for the current index
        let item = tasksToCompleteList[idxWay.row]
        
        // Configure the cell's text and visual properties
        block.mainstring.text = item.title
        block.ministring.text = item.dueDate
        block.prioritiseVisual.isHidden = !item.isFavourite

        return block
    }

    /// remove or priorise option
    override func tableView(_ UiTV: UITableView, trailingSwipeActionsConfigurationForRowAt idxWay: IndexPath) -> UISwipeActionsConfiguration? {
        
        let perform = Predefined.Operation.self
        
        let remove = UIContextualAction(style: .destructive, title: perform.delete) { _,_,_ in
            self.removeItem(at: idxWay.row)
        }
        
        let prioritise = UIContextualAction(style: .normal, title: .empty) { _,_,_ in
            self.prioritiseItem(at: idxWay.row)
        }
        prioritise.backgroundColor = .orange
        prioritise.title = tasksToCompleteList[idxWay.row].isFavourite ? perform.unstar : perform.star
        
        let LorRoperation = UISwipeActionsConfiguration(actions: [remove,prioritise])
        return LorRoperation
    }
    
    override func tableView(_ UiTV: UITableView, didSelectRowAt idxWay: IndexPath) {
        recentTaskClicked = idxWay.row
        let item = tasksToCompleteList[idxWay.row]
        performSegue(withIdentifier: Predefined.SmoothTransition.transitionTD, sender: item)
    }
    
    /// viewFtr
    override func tableView(_ UiTV: UITableView, viewForFooterInSection sgment: Int) -> UIView? {
        return UIView()
    }
    
    //finished item
    override func tableView(_ UiTV: UITableView, leadingSwipeActionsConfigurationForRowAt idxWay: IndexPath) -> UISwipeActionsConfiguration? {
        let finishedItem = UIContextualAction(style: .normal, title: .empty) {  (_, _, _) in
            self.finishedItem(at: idxWay.row)
        }
        finishedItem.title = Predefined.Operation.complete
        finishedItem.backgroundColor = .systemGreen
        let LorRoperation = UISwipeActionsConfiguration(actions: [finishedItem])
        return LorRoperation
    }
}

extension TDView: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ remote: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ remote: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ remote: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange item: Any,
                    at idxWay: IndexPath?,
                    for category: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch category {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [idxWay!], with: .fade)
        case .update:
            tableView.reloadRows(at: [idxWay!], with: .fade)
        case .move:
            break
        @unknown default:
            break
        }
    }
}

/// submit or edit items
extension TDView : SeparateTasks{
    func hasClickedSubmit(task: Item) {
        tasksToCompleteList.append(task)
        do {
            try CDmanagedojt.save()
        } catch {
            tasksToCompleteList.removeLast()
            print(error.localizedDescription)
        }
        bufferInfo()
    }
    
    func hasClickedModify(task: Item) {
        modifyItem()
    }
    
    
}

//searching
extension TDView: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for findCtrl: UISearchController) {
        guard let searchText = findCtrl.searchBar.text?.lowercased(), !searchText.isEmpty,
              let outcomeCtrl = findCtrl.searchResultsController as? OutputGrid else {
            tableView.reloadData()
            return
        }

        // Filter tasks based on title or subtasks
        outcomeCtrl.itemsArray = tasksToCompleteList.filter { task in
            let titleMatch = task.title?.lowercased().contains(searchText) ?? false
            let subTasksMatch = task.subTasks?.lowercased().contains(searchText) ?? false
            return titleMatch || subTasksMatch
        }

        // Prepare a fetch request to filter Core Data tasks
        let grabAsk: NSFetchRequest<Item> = Item.fetchRequest()
        grabAsk.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        grabAsk.predicate = NSPredicate(format: "title contains[c] %@", searchText)
        
        // Initialize the fetched results controller
        initialiseGrabbedItemsCtrl(fetchRequest: grabAsk)

        // Reload the search results table
        outcomeCtrl.tableView.reloadData()
    }

    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
}

// organise
extension TDView {
    
    func previewOrgNotifCtrl() {
        let notifier = UIAlertController(title: nil, message: "Choose sort type", preferredStyle: .actionSheet)
        
        OptionsOfOrganise.allCases.forEach { (sortType) in
            let operation = UIAlertAction(title: sortType.typeOfOrganise(), style: .default) { (_) in
                self.recentChosenOrg = sortType
                self.bufferInfo()
            }
            notifier.addAction(operation)
        }
        
        let abortAct = UIAlertAction(title: Predefined.Operation.cancel, style: .cancel, handler: nil)
        notifier.addAction(abortAct)
        self.present(notifier, animated: true)
    }
}

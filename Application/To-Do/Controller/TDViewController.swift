//
//  TDViewController.swift
//
//  Created by Mazari Bahaduri on 25/07/24.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import UIKit
import CoreData

class TDViewController: UITableViewController {
    
    // Definition of variables -> referencing outlets
    /// Display task items
    @IBOutlet weak var tasksLoadView: UITableView!
    
    /// Filtering task option
    @IBOutlet weak var organiseButton: UIBarButtonItem!
    
    /// Find task option
    var findCtrl: UISearchController!
    
    /// OutputTableCtrl presents the resulting finding
    var outputTableCtrl: OutputGridController!
    
    /// Array keeping track of task items
    var tasksToCompleteList : [Task] = []
    
    /// recent index (task) clicked
    var recentTaskClicked : Int = 0
    
    /// Database handle
    var CDmanagedojt: NSManagedObjectContext!

    /// calling CD database for an item
    var calledTasksCtrl: NSFetchedResultsController<Task>!
    
    /// grabAsk
    lazy var grabReq: NSFetchRequest<Task> = {
        let grab : NSFetchRequest<Task> = Task.fetchRequest()
        return grab
    }()
    
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
        guard let softwareD = UIApplication.shared.delegate as? scriptDistributor else { return }
        let constantBucket = softwareD.consistentBox
        CDmanagedojt = constantBucket.viewContext
        grabReq.sortDescriptors = recentChosenOrg.organiseInform()
        grabReq.predicate = NSPredicate(format: "isComplete = %d", false)
        initialiseGrabbedItemsCtrl(fetchRequest: grabReq)
        if let items = calledTasksCtrl.fetchedObjects {
            self.tasksToCompleteList = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    /// setting up fetched items
    func initialiseGrabbedItemsCtrl(fetchRequest: NSFetchRequest<Task>) {
        calledTasksCtrl = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CDmanagedojt, sectionNameKeyPath: nil, cacheName: nil)
        calledTasksCtrl.delegate = self
        do {
            try calledTasksCtrl.performFetch()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    /// if add button is clicked
    @IBAction func addTasksTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Predefined.SmoothTransition.transitionTD, sender: false)
    }
    
    @IBAction func sortButtonTapped(_ sender: UIBarButtonItem) {
        previewOrgNotifCtrl()
    }
    
    //actioning a task
    func prioritiseItem(at index : Int){
        tasksToCompleteList[index].isFavourite = tasksToCompleteList[index].isFavourite ? false : true
        modifyItem()
    }
    
    /// removeItem - deleting an item
    func removeItem(at index : Int){
        hAlertMaker = UINotificationFeedbackGenerator()
        hAlertMaker?.prepare()
        
        let item = tasksToCompleteList.remove(at: index) /// removes task at index
        CDmanagedojt.delete(item) /// deleting the object from core data
        do {
            try CDmanagedojt.save()
            hAlertMaker?.notificationOccurred(.success)
        } catch {
            tasksToCompleteList.insert(item, at: index)
            print(error.localizedDescription)
            hAlertMaker?.notificationOccurred(.error)
        }
        tableView.reloadData() /// Reload tableview with remaining data
        hAlertMaker = nil
    }
    
    /// successItem - finished an item
    func finishedItem(at index : Int){
        tasksToCompleteList[index].isComplete = true
        tasksToCompleteList.remove(at: index) /// removes task at index
        modifyItem()
        tableView.reloadData()
    }
    
    /// modifyItem - called when wanting to make a change
    func modifyItem(){
        hAlertMaker = UINotificationFeedbackGenerator()
        hAlertMaker?.prepare()
        
        do {
            try CDmanagedojt.save()
            hAlertMaker?.notificationOccurred(.success)
        } catch {
            print(error.localizedDescription)
            hAlertMaker?.notificationOccurred(.error)
        }
        bufferInfo()
        hAlertMaker = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let itemDescVisCont = segue.destination as? TInfoViewController {
            itemDescVisCont.hidesBottomBarWhenPushed = true
            itemDescVisCont.distribute = self
            itemDescVisCont.item = sender as? Task
        }
    }
    
    fileprivate func presentPreMainOptional() {
        guard let newUserCtrl = self.storyboard?.instantiateViewController(identifier: Predefined.VC.Onboarding) as? NewUserDisplayController else { return }
        
        if !newUserCtrl.hasDisplayed() {
            DispatchQueue.main.async {
                self.present(newUserCtrl, animated: true)
            }
        }
    }
    
    fileprivate func initialiseFindCtrl() {
        outputTableCtrl =
            self.storyboard?.instantiateViewController(withIdentifier: Predefined.VC.ResultsTable) as? OutputGridController
        outputTableCtrl.tableView.delegate = self
        findCtrl = UISearchController(searchResultsController: outputTableCtrl)
        findCtrl.delegate = self
        findCtrl.searchResultsUpdater = self
        findCtrl.searchBar.autocapitalizationType = .none
        findCtrl.searchBar.delegate = self
        findCtrl.view.backgroundColor = .white
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
        self.organiseButton.isEnabled = self.tasksToCompleteList.count > 0
        
        if tasksToCompleteList.isEmpty {
            boxPresent.separatorStyle = .none
            boxPresent.backgroundView?.isHidden = false
        } else {
            boxPresent.separatorStyle = .singleLine
            boxPresent.backgroundView?.isHidden = true
            
        }
        
        return tasksToCompleteList.count
    }
    
    /// particular row to present
    override func tableView(_ UiTV: UITableView, cellForRowAt idxWay: IndexPath) -> UITableViewCell {
        let block = UiTV.dequeueReusableCell(withIdentifier: Predefined.Block.taskCell, for: idxWay) as! TodoCell
        let item = tasksToCompleteList[idxWay.row]
        block.mainstring.text = item.title
        block.ministring.text = item.dueDate
        block.prioritiseVisual.isHidden = tasksToCompleteList[idxWay.row].isFavourite ? false : true
        return block
    }
    
    override func tableView(_ UiTV: UITableView, didSelectRowAt idxWay: IndexPath) {
        recentTaskClicked = idxWay.row
        let item = tasksToCompleteList[idxWay.row]
        performSegue(withIdentifier: Predefined.SmoothTransition.transitionTD, sender: item)
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
    
    //finished item
    override func tableView(_ UiTV: UITableView, leadingSwipeActionsConfigurationForRowAt idxWay: IndexPath) -> UISwipeActionsConfiguration? {
        let finishedItem = UIContextualAction(style: .normal, title: .empty) {  (_, _, _) in
            self.finishedItem(at: idxWay.row)
        }
        finishedItem.backgroundColor = .systemGreen
        finishedItem.title = Predefined.Operation.complete
        let LorRoperation = UISwipeActionsConfiguration(actions: [finishedItem])
        return LorRoperation
    }
    
    /// viewFtr
    override func tableView(_ UiTV: UITableView, viewForFooterInSection sgment: Int) -> UIView? {
        return UIView() ///
    }
}

extension TDViewController: NSFetchedResultsControllerDelegate {
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
extension TDViewController : SeparateTasks{
    func hasClickedSubmit(task: Task) {
        tasksToCompleteList.append(task)
        do {
            try CDmanagedojt.save()
        } catch {
            tasksToCompleteList.removeLast()
            print(error.localizedDescription)
        }
        bufferInfo()
    }
    
    func hasClickedModify(task: Task) {
        modifyItem()
    }
    
    
}

//searching
extension TDViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for findCtrl: UISearchController) {
        if let text: String = findCtrl.searchBar.text?.lowercased(), text.count > 0, let outcomeCtrl = findCtrl.searchResultsController as? OutputGridController {
            outcomeCtrl.itemsArray = tasksToCompleteList.filter({ (task) -> Bool in
                if task.title?.lowercased().contains(text) == true || task.subTasks?.lowercased().contains(text) == true {
                    return true
                }
                return false
            })
            let grabAsk : NSFetchRequest<Task> = Task.fetchRequest()
            grabAsk.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            grabAsk.predicate = NSPredicate(format: "title contains[c] %@", text)
            initialiseGrabbedItemsCtrl(fetchRequest: grabAsk)
            outcomeCtrl.tableView.reloadData()
        } else {
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
}

// organise
extension TDViewController {
    
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

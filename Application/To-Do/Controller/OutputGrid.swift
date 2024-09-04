//
//  OutputTable.swift
//
//  Created by Mazari Bahaduri on 29/08/24.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import UIKit

class OutputGrid: UITableViewController {
    var itemsArray = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseVoid()
    }
    
    fileprivate func initialiseVoid() {
        let void = VoidBeing(.emptySearch)
        self.tableView.backgroundView = void
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
    }
    //UITV - Data
    
    override func tableView(_ UITV: UITableView, numberOfRowsInSection dept: Int) -> Int {
        if itemsArray.isEmpty {
            self.tableView.separatorStyle = .none
            self.tableView.backgroundView?.isHidden = false
            
        } else {
            self.tableView.separatorStyle = .singleLine
            self.tableView.backgroundView?.isHidden = true
        }
        return itemsArray.count
    }
    
    override func tableView(_ TV: UITableView, cellForRowAt idxWay: IndexPath) -> UITableViewCell {
        let block = UITableViewCell(style: .subtitle, reuseIdentifier: Predefined.Block.taskCell)
        let item = itemsArray[idxWay.row]
        block.textLabel?.text = item.title
        block.detailTextLabel?.text = item.dueDate
        return block
    }
    
}

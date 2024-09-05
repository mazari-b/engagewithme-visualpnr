//
//  OutputTable.swift
//
//  Created by Mazari Bahaduri on 29/08/24.
//  Copyright © 2024 Mazari Bahaduri. All rights reserved.
//

import UIKit

class OutputGrid: UITableViewController {
    var itemsArray = [Item]()
    
    override func tableView(_ TV: UITableView, cellForRowAt idxWay: IndexPath) -> UITableViewCell {
        let block = UITableViewCell(style: .subtitle, reuseIdentifier: Predefined.Block.taskCell)
        let item = itemsArray[idxWay.row]
        block.textLabel?.text = item.title
        block.detailTextLabel?.text = item.dueDate
        return block
    }
    
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
        // Configure table view appearance based on whether itemsArray is empty
        let isEmpty = itemsArray.isEmpty
        UITV.separatorStyle = isEmpty ? .none : .singleLine
        UITV.backgroundView?.isHidden = !isEmpty

        return itemsArray.count
    }

    
    
    
}

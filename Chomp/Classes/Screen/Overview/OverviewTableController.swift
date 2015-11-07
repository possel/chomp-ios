//
// Created by Sky Welch on 07/10/2015.
// Copyright (c) 2015 Sky Welch. All rights reserved.
//

import Foundation
import UIKit

class OverviewTableController: NSObject {
    private let tableView: UITableView

    private (set) weak var delegate: OverviewTableControllerDelegate?

    init(tableView: UITableView, delegate: OverviewTableControllerDelegate) {
        self.tableView = tableView
        self.delegate = delegate
        
        super.init()
        
        self.setupTableView()
    }

    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.tableView.registerNib(UINib(nibName: "OverviewTableViewCell", bundle: nil), forCellReuseIdentifier: OverviewTableViewCell.cellReuseIdentifier)
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
}

extension OverviewTableController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let delegate = self.delegate {
            return delegate.numberOfItemsInSection(section)
        }

        return 0
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let delegate = self.delegate {
            return delegate.numberOfSections()
        }

        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let delegate = self.delegate {
            return delegate.titleForSection(section)
        }
        
        return ""
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var labelText = ""
        if let (_, itemLabelText) = self.delegate?.itemAtIndexPath(indexPath) {
            labelText = itemLabelText
        }

        let cell = tableView.dequeueReusableCellWithIdentifier(OverviewTableViewCell.cellReuseIdentifier, forIndexPath: indexPath) as! OverviewTableViewCell

        cell.setLabelText(labelText)

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let (id, _) = self.delegate?.itemAtIndexPath(indexPath) {
            self.delegate?.onBufferTapped(id)

            return
        }
        
        print("tapped an invalid buffer")
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.min
        }
        
        return tableView.sectionHeaderHeight
    }
}

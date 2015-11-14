//
// Created by Sky Welch on 14/11/2015.
// Copyright (c) 2015 Sky Welch. All rights reserved.
//

import UIKit

class BufferTableController: NSObject {
    private let tableView: UITableView

    private (set) weak var delegate: BufferTableControllerDelegate?

    init(tableView: UITableView, delegate: BufferTableControllerDelegate) {
        self.tableView = tableView
        self.delegate = delegate

        super.init()

        self.setupTableView()
    }

    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        self.tableView.registerNib(UINib(nibName: "BufferTableViewCell", bundle: nil), forCellReuseIdentifier: BufferTableViewCell.cellReuseIdentifier)
    }

    func scrollToBottom() {
        if let numberOfItems = delegate?.numberOfItems(0) where numberOfItems > 0 {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: numberOfItems - 1, inSection: 0), atScrollPosition: .Bottom, animated: true)
        }
    }

    func reloadData() {
        self.tableView.reloadData()
    }
}

extension BufferTableController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let delegate = self.delegate {
            return delegate.numberOfItems(section)
        }

        return 0
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var nicknameText = ""
        var contentText = ""
        if let (_, nickname, content) = self.delegate?.itemAtIndexPath(indexPath) {
            nicknameText = "<" + nickname + ">"
            contentText = content
        }

        let cell = tableView.dequeueReusableCellWithIdentifier(BufferTableViewCell.cellReuseIdentifier, forIndexPath: indexPath) as! BufferTableViewCell
        cell.setNickname(nicknameText)
        cell.setContent(contentText)

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let (id, _, _) = self.delegate?.itemAtIndexPath(indexPath) {
            self.delegate?.onBufferRowTapped(id)

            return
        }

        print("tapped an invalid buffer row")
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
}

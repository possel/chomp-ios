//
//  OverviewViewController.swift
//  Chomp
//
//  Created by Sky Welch on 05/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import UIKit

class OverviewViewController: ChompViewController, OverviewView {
    private let user: User
    private let session: SessionManager
    private let websocket: ChompWebsocket
    
    var presenter: OverviewPresenter!
    var tableController: OverviewTableController!

    @IBOutlet weak var overviewTable: UITableView!
    
    init(user: User, session: SessionManager, websocket: ChompWebsocket) {
        self.user = user
        self.session = session
        self.websocket = websocket
        super.init(nibName: "OverviewViewController", bundle: nil)
        self.presenter = OverviewPresenter(view: self, user: self.user, session: self.session, websocket: self.websocket)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not NSCoder compliant")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("OverviewViewController viewDidLoad")
        
        self.title = "Overview"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .Plain, target: self, action: "backTapped")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        self.setupTableView()
        
        presenter.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedIndexPath = self.overviewTable.indexPathForSelectedRow {
            self.overviewTable.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.presenter.viewWillDisappear()
    }

    func setupTableView() {
        self.tableController = OverviewTableController(tableView: self.overviewTable, delegate: self.presenter)
        self.presenter.tableController = self.tableController
    }
    
    func backTapped() {
        session.onRequestFailedDueToAuthentication()
    }
    
    // MARK: OverviewView
    
    func showFetchServersFailure() {
        print("Failed to fetch servers")
    }
    
    func showFetchBuffersFailure() {
        print("Failed to fetch buffers")
    }
    
    func showFetchUserFailure() {
        print("Failed to fetch users")
    }
    
    func pushBufferView(buffer: BufferEntity) {
        self.navigationController?.pushViewController(BufferViewController(user: self.user, session: self.session, websocket: self.websocket, buffer: buffer), animated: true)
    }
}


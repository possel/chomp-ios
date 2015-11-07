//
//  OverviewPresenter.swift
//  Chomp
//
//  Created by Sky Welch on 04/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import Foundation

class OverviewPresenter {
    private let view: OverviewView
    private let user: User
    private let session: SessionManager
    private var interactor: OverviewInteractor?

    var tableController: OverviewTableController?

    var bufferViewModels: [BufferEntity] = []
    var serverViewModels: [ServerEntity] = []
    var serverBufferViewModels = [Int : [BufferEntity]]()
    var userViewModels = [Int: UserEntity]()
    
    required init(view: OverviewView, user: User, session: SessionManager, websocket: ChompWebsocket) {
        self.view = view
        self.user = user
        self.session = session

        self.interactor = OverviewInteractor(presenter: self, session: session, websocket: websocket)
    }
    
    func viewDidLoad() {
        print("OverviewPresenter viewDidLoad")

        self.interactor?.loadOverview()
        self.interactor?.listenToWebsocket()
    }
    
    func viewWillDisappear() {
        print("OverviewPresenter viewWillDisappear")

        self.interactor?.stopListeningToWebsocket()
    }

    func loadingOverviewFailed() {
        print("interactor notified of overview loading failure")
    }

    func loadedOverview(servers: [ServerEntity], buffers: [BufferEntity], users: [UserEntity]) {
        serverViewModels = servers
        bufferViewModels = buffers

        constructServerBufferViewModels(servers, buffers: buffers)
        constructUserViewModels(users)

        self.tableController?.reloadData()
    }

    private func constructServerBufferViewModels(servers: [ServerEntity], buffers: [BufferEntity]) {
        for _ in servers {
            for buffer in buffers {
                let bufferServerMapping = buffer.server ?? 0

                if serverBufferViewModels[bufferServerMapping] == nil {
                    serverBufferViewModels[bufferServerMapping] = []
                }

                serverBufferViewModels[bufferServerMapping]?.append(buffer)
            }
        }
    }

    private func constructUserViewModels(users: [UserEntity]) {
        for user in users {
            userViewModels[user.id] = user
        }
    }
}

extension OverviewPresenter: OverviewTableControllerDelegate {
    func numberOfSections() -> Int {
        return serverBufferViewModels.count
    }
    
    func titleForSection(section: Int) -> String {
        if section <= 0 {
            return ""
        }
        
        let serverSection = section - 1
        if serverSection < serverViewModels.count {
            let server = serverViewModels[serverSection]
            let nick = userViewModels[server.user]?.nick ?? "?"
            return "\(nick) @ \(server.host):\(server.port)"
        }
        
        return ""
    }

    func numberOfItemsInSection(section: Int) -> Int {
        if let buffersForServer = serverBufferViewModels[section] {
            return buffersForServer.count
        }
        
        return 0
    }

    func itemAtIndexPath(indexPath: NSIndexPath) -> (Int, String)? {
        if let bufferAtIndexPath = serverBufferViewModels[indexPath.section]?[indexPath.row] {
            return (bufferAtIndexPath.id, bufferAtIndexPath.name)
        }

        return nil
    }
    
    func onBufferTapped(id: Int) {
        if let buffer = bufferViewModels.filter({ $0.id == id }).first {
            self.view.pushBufferView(buffer)
            
            return
        }
        
        print("couldn't find buffer with id \(id) in buffer models")
    }
}
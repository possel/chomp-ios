//
// Created by Sky Welch on 31/10/2015.
// Copyright (c) 2015 Sky Welch. All rights reserved.
//

import Foundation

class OverviewInteractor: FetchServersServiceListener, FetchBuffersServiceListener, FetchUsersServiceListener, ChompWebsocketListener {
    private let presenter: OverviewPresenter
    private let session: SessionManager
    private let websocket: ChompWebsocket

    var serverModels: [ServerEntity] = []
    var bufferModels: [BufferEntity] = []
    var userModels: [UserEntity] = []

    var loadingServers = false
    var loadingBuffers = false
    var loadingUsers = false

    init(presenter: OverviewPresenter, session: SessionManager, websocket: ChompWebsocket) {
        self.presenter = presenter
        self.session = session
        self.websocket = websocket

        print("OverviewInteractor telling websocket to connect")
        websocket.connect()
    }

    func loadOverview() {
        if (loadingServers || loadingBuffers || loadingUsers) {
            print("already loading overview data - not starting new services")
            return
        }

        loadingServers = true
        loadingBuffers = true
        loadingUsers = true

        FetchServersService(session: self.session, delegate: self).fetchServers()
        FetchBuffersService(session: self.session, delegate: self).fetchBuffers()
        FetchUsersService(session: self.session, delegate: self).fetchUser("all")
    }

    func listenToWebsocket() {
        websocket.addListener(self)
    }

    func stopListeningToWebsocket() {
        websocket.removeListener(self)
    }

    func onLoadedData() {
        if !loadingServers && !loadingBuffers && !loadingUsers {
            presenter.loadedOverview(serverModels, buffers: bufferModels, users: userModels)
        }
    }

    // MARK: FetchServersServiceListener

    func onFetchServersCompleted(servers: [ServerEntity]) {
        self.serverModels = servers

        loadingServers = false
        onLoadedData()
    }

    func onFetchServersFailed() {
        presenter.loadingOverviewFailed()
    }

    // MARK: FetchBuffersServiceListener

    func onFetchBuffersCompleted(buffers: [BufferEntity]) {
        bufferModels = buffers

        loadingBuffers = false
        onLoadedData()
    }

    func onFetchBuffersFailed() {
        presenter.loadingOverviewFailed()
    }

    // MARK: FetchUsersServiceListener

    func onFetchUserCompleted(users: [UserEntity]) {
        userModels = users

        loadingUsers = false
        onLoadedData()
    }

    func onFetchUserFailed() {
        presenter.loadingOverviewFailed()
    }

    // MARK: ChompWebsocketListener

    func onReceivedLineForBuffer(id: Int, line: LineEntity) {
        print("OverviewInteractor got line for buffer \(id): \(line)")
    }
}

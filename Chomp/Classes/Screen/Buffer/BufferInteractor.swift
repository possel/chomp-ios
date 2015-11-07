//
// Created by Sky Welch on 31/10/2015.
// Copyright (c) 2015 Sky Welch. All rights reserved.
//

import Foundation

class BufferInteractor: FetchLinesServiceListener, ChompWebsocketListener, SendLineServiceListener {
    let presenter: BufferPresenter
    let websocket: ChompWebsocket
    let buffer: BufferEntity
    let session: SessionManager

    init(presenter: BufferPresenter, websocket: ChompWebsocket, buffer: BufferEntity, session: SessionManager) {
        self.presenter = presenter
        self.websocket = websocket
        self.buffer = buffer
        self.session = session
    }

    func listenToWebsocket() {
        websocket.addListener(self)
    }

    func stopListeningToWebsocket() {
        websocket.removeListener(self)
    }

    func loadBufferHistory(lines: Int) {
        FetchLinesService(session: self.session, delegate: self, buffer: buffer.id).fetchLastLines(lines)
    }
    
    func sendLine(line: String) {
        SendLineService(session: self.session, delegate: self, buffer: buffer.id).sendLine(line)
    }

    // MARK: ChompWebsocketListener

    func onReceivedLineForBuffer(id: Int, line: LineEntity) {
        if self.buffer.id == id {
            print("BufferInteractor got line for presented buffer \(id): \(line)")

            presenter.loadedLines([line])
        } else {
            print("BufferInteractor ignoring line \(line.id)")
        }
    }

    // MARK: FetchLinesServiceListener

    func onFetchLinesCompleted(buffer: Int, lines: [LineEntity]) {
        print("BufferInteractor got lines for buffer \(buffer): \(lines)")

        presenter.loadedLines(lines)
    }

    func onFetchLinesFailed() {
        print("BufferInteractor failed to fetch lines for overview")
    }
    
    // MARK: SendLineServiceListener
    
    func onSendLineCompleted(line: String) {
        print("buffer interactor sent line: \(line)")
    }
    
    func onSendLineFailed(line: String) {
        print("buffer interactor failed to send line: \(line)")
    }
}

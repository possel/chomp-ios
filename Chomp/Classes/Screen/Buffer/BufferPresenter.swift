//
//  BufferPresenter.swift
//  Chomp
//
//  Created by Sky Welch on 17/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import Foundation

class BufferPresenter {
    private let view: BufferView
    private let buffer: BufferEntity
    private let websocket: ChompWebsocket
    private let session: SessionManager

    var interactor: BufferInteractor?
    var tableController: BufferTableController?
    var lines: [LineEntity] = []
    
    required init(view: BufferView, websocket: ChompWebsocket, buffer: BufferEntity, session: SessionManager) {
        self.view = view
        self.websocket = websocket
        self.buffer = buffer
        self.session = session

        self.interactor = BufferInteractor(presenter: self, websocket: websocket, buffer: buffer, session: session)
    }
    
    func viewDidLoad() {
        print("BufferPresenter viewDidLoad with buffer \(self.buffer)")
        
        interactor?.listenToWebsocket()
        interactor?.loadBufferHistory(100)
    }
    
    func viewWillDisappear() {
        interactor?.stopListeningToWebsocket()
    }

    func loadedLines(lines: [LineEntity]) {
        let reversedLines: [LineEntity] = lines.reverse()
        self.lines.appendContentsOf(reversedLines)

        tableController?.reloadData()
        tableController?.scrollToBottom()
    }
    
    func sendLineTapped(line: String) {
        interactor?.sendLine(line)
        
        view.clearLineInput()
    }
}

extension BufferPresenter: BufferTableControllerDelegate {
    func numberOfItems(section: Int) -> Int {
        return self.lines.count
    }

    func itemAtIndexPath(indexPath: NSIndexPath) -> (Int, String, String)? {
        if indexPath.row >= lines.count {
            return nil
        }
        
        let line = lines[indexPath.row]
        return (indexPath.row, line.nick, line.content)
    }

    func onBufferRowTapped(id: Int) {
        print("tapped buffer row \(id)_")
    }
}
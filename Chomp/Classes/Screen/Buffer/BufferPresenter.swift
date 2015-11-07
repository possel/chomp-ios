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
        for line in lines.reverse() {
            self.view.addLineToView(line)
        }
    }
    
    func sendLineTapped(line: String) {
        interactor?.sendLine(line)
        
        view.clearLineInput()
    }
}
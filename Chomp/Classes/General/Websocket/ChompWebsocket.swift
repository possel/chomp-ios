//
//  ChompWebsocket.swift
//  Chomp
//
//  Created by Sky Welch on 11/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import Foundation
import Starscream
import SwiftyJSON

class ChompWebsocket: WebSocketDelegate, FetchLinesServiceListener {
    private var socket: WebSocket?
    private let session: SessionManager
    private let authManager: AuthManager
    private var listeners: [ChompWebsocketListener] = []
    
    init(session: SessionManager, authManager: AuthManager) {
        self.session = session
        self.authManager = authManager
    }
    
    func addListener(listener: ChompWebsocketListener) {
        print("Adding \(listener) to websocket listeners")
        listeners.append(listener)
    }
    
    func removeListener(listener: ChompWebsocketListener) {
        print("Removing \(listener) from websocket listeners")
        listeners = listeners.filter({ $0 !== listener })
    }
    
    func connect() {
        if let socket = self.socket {
            socket.disconnect()
            self.socket = nil
        }
        
        let url = NSURL(string: "\(session.currentBaseWebsocketUrl)/push")!
        
        self.socket = WebSocket(url: url)

        print("populating websocket connection with auth cookie")
        
        if let authCookie = self.authManager.constructAuthCookie() {
            let headers = NSHTTPCookie.requestHeaderFieldsWithCookies([authCookie]);
            for (key, value) in headers {
                print("setting \(key) to \(value)")
                self.socket?.headers[key] = value
            }
        } else {
            print("failed to construct auth cookie, not setting")
        }
        
        self.socket?.delegate = self
        self.socket?.connect()
    }
    
    func disconnect() {
        self.socket?.disconnect()
    }
    
    // MARK: WebSocketDelegate
    
    func websocketDidConnect(socket: WebSocket) {
        print("websocket connected")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("websocket disconnected \(error), reconnecting...")
        
        self.socket?.connect()
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        guard let data = text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) else {
            print("failed to convert json text to data: \(text)")
            return
        }
        
        let json = JSON(data: data)
        if let type = json["type"].string {
            if type == "line" {
                if let lineId = json["line"].int, bufferId = json["buffer"].int {
                    FetchLinesService(session: self.session, delegate: self, buffer: bufferId).fetchLine(lineId)
                } else {
                    print("websocket got malformed line: \(text)")
                }
            } else {
                print("websocket got unknown message: \(text)")
            }
        } else {
            print("failed to parse websocket message: \(text)")
        }
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("websocket got data: \(data)")
    }
    
    // MARK: FetchLinesInteractorListener
    
    func onFetchLinesCompleted(buffer: Int, lines: [LineEntity]) {
        if lines.isEmpty {
            print("got empty lines back")
            return
        }
        
        for line in lines {
            print("\(line)")

            for listener in self.listeners {
                listener.onReceivedLineForBuffer(buffer, line: line)
            }
        }
    }
    
    func onFetchLinesFailed() {
        print("failed to grab line")
    }
}
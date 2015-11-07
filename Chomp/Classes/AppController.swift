//
//  AppController.swift
//  Chomp
//
//  Created by Sky Welch on 05/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import UIKit

public class AppController: SessionManagerListener {
    static var currentDomain = "127.0.0.1"
    static var currentPort = "8081"
    static var currentURL = ""
    
    let rootNavigationManager: RootNavigationManager
    let session: SessionManager
    let authManager: AuthManager
    let websocket: ChompWebsocket
    
    var window: UIWindow?
    
    init() {
        let session = SessionManager()
        let authManager = AuthManager(session: session)
        let websocket = ChompWebsocket(session: session, authManager: authManager)
        let rootNavigationManager = RootNavigationManager(authManager: authManager, session: session, websocket: websocket)

        session.reconfigureSession(authManager)
        authManager.delegate = session

        self.authManager = authManager
        self.session = session
        self.websocket = websocket
        self.rootNavigationManager = rootNavigationManager

        AppController.constructURLFromDomainAndPort("127.0.0.1", port: "8081")

        session.delegate = self
    }
    
    static func constructURLFromDomainAndPort(domain: String, port: String) {
        AppController.currentDomain = domain
        AppController.currentPort = port
        AppController.currentURL = "http://\(AppController.currentDomain):\(AppController.currentPort)"
    }

    // MARK: SessionManagerListener

    func onNewSession() {
        print("AppController notified of new session")

        self.rootNavigationManager.makeControllers()
        window?.rootViewController = self.rootNavigationManager.rootNavigationController
    }

    func onSessionInvalidated() {
        print("AppController notified that the current session has been invalidated")

        self.rootNavigationManager.makeControllers()
        window?.rootViewController = self.rootNavigationManager.rootNavigationController
    }
}

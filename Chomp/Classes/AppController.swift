//
//  AppController.swift
//  Chomp
//
//  Created by Sky Welch on 05/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import UIKit

public class AppController: SessionManagerListener {
    let rootNavigationManager: RootNavigationManager
    let configuration: ChompConfiguration
    let session: SessionManager
    let authManager: AuthManager
    let websocket: ChompWebsocket
    
    var window: UIWindow?
    
    init() {
        let configuration = ChompConfiguration()
        let session = SessionManager(configuration: configuration)
        let authManager = AuthManager(session: session)
        let websocket = ChompWebsocket(session: session, authManager: authManager)
        let rootNavigationManager = RootNavigationManager(authManager: authManager, session: session, websocket: websocket)

        session.reconfigureSession(authManager)
        authManager.delegate = session

        self.configuration = configuration
        self.authManager = authManager
        self.session = session
        self.websocket = websocket
        self.rootNavigationManager = rootNavigationManager

        session.addListener(self)
    }

    deinit {
        session.removeListener(self)
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

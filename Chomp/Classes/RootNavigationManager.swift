//
//  RootNavigationManager.swift
//  Chomp
//
//  Created by Sky Welch on 09/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import UIKit

class RootNavigationManager {
    let authManager: AuthManager
    let session: SessionManager
    let websocket: ChompWebsocket
    var rootNavigationController: UINavigationController?
    
    init(authManager: AuthManager, session: SessionManager, websocket: ChompWebsocket) {
        self.authManager = authManager
        self.session = session
        self.websocket = websocket
        self.makeControllers()
    }
    
    func makeControllers() {
        var rootViewController: UIViewController
        
        if self.authManager.doesUserHaveTokenStored() {
            print("user has token stored, setting root view controller to overview")
            
            rootViewController = self.constructOverviewViewController()
        } else {
            print("user has no token stored, setting root view controller to login")

            rootViewController = self.constructLoginViewController()
        }
        
        self.rootNavigationController = UINavigationController(rootViewController: rootViewController)
        Styling.styleNavigationBar(self.rootNavigationController!.navigationBar)
    }
    
    func constructOverviewViewController() -> OverviewViewController {
        let (user, token) = self.authManager.getUserAndToken()!
        return OverviewViewController(user: User(id: 1, name: user, token: token), session: self.session, websocket: self.websocket)
    }
    
    func constructLoginViewController() -> LoginViewController {
        return LoginViewController(session: session)
    }
}
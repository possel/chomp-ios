//
// Created by Sky Welch on 06/11/2015.
// Copyright (c) 2015 Sky Welch. All rights reserved.
//

import Foundation
import Alamofire

class SessionManager: AuthManagerListener {
    var currentDomain = ""
    var currentUser = ""
    var currentBaseUrl = ""
    var currentBaseHttpUrl: String {
        get {
            return "http://\(currentBaseUrl)"
        }
    }

    var currentBaseWebsocketUrl: String {
        get {
            return "ws://\(currentBaseUrl)"
        }
    }

    private let configuration: ChompConfiguration

    private var listeners: [SessionManagerListener] = []
    private var authManager: AuthManager?
    private var session: Alamofire.Manager?

    init(configuration: ChompConfiguration) {
        self.configuration = configuration

        self.currentDomain = configuration.apiDomain
        self.currentUser = configuration.apiUser
    }

    func addListener(listener: SessionManagerListener) {
        listeners.append(listener)
    }

    func removeListener(listener: SessionManagerListener) {
        listeners = listeners.filter({ $0 !== listener })
    }

    func createNewSession(domain: String, port: String, user: String, password: String) -> Bool {
        configuration.apiDomain = domain
        configuration.apiPort = port
        configuration.apiUser = user

        setCurrentSessionDetails(domain, port: port, user: user)

        return self.authManager?.requestLoginToken(user, password: password) ?? false
    }
    
    func setCurrentSessionDetails(domain: String, port: String, user: String) {
        currentDomain = domain
        currentUser = user

        constructBaseUrlFromDomainAndPort(domain, port: port)
    }

    func reconfigureSession(authManager: AuthManager) {
        self.authManager = authManager
        self.authManager?.delegate = self

        session = self.configureNewSession()
    }

    func currentSession() -> Alamofire.Manager {
        if let currentSession = session {
            return currentSession
        }

        return configureNewSession()
    }

    private func configureNewSession() -> Alamofire.Manager {
        let cfg = NSURLSessionConfiguration.defaultSessionConfiguration()
        cfg.timeoutIntervalForRequest = 5
        cfg.HTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()

        for cookie in (cfg.HTTPCookieStorage?.cookies)! {
            cfg.HTTPCookieStorage?.deleteCookie(cookie)
        }

        if let authCookie = authManager?.constructAuthCookie() {
            cfg.HTTPCookieStorage?.setCookie(authCookie)
        }

        print("cookies for request: \(cfg.HTTPCookieStorage?.cookies)")

        let newSession = Alamofire.Manager(configuration: cfg)
        session = newSession
        
        setCurrentSessionDetails(configuration.apiDomain, port: configuration.apiPort, user: configuration.apiUser)

        return newSession
    }

    private func constructBaseUrlFromDomainAndPort(domain: String, port: String) {
        currentBaseUrl = "\(domain):\(port)"
    }

    func onRequestFailedDueToAuthentication() {
        authManager?.clearUserTokens()

        onAuthFailed()
    }

    // MARK: AuthManagerListener

    func onAuthSucceeded() {
        for listener in listeners {
            listener.onNewSession()
        }
    }

    func onAuthFailed() {
        for listener in listeners {
            listener.onSessionInvalidated()
        }
    }
}

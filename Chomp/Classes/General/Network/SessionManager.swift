//
// Created by Sky Welch on 06/11/2015.
// Copyright (c) 2015 Sky Welch. All rights reserved.
//

import Foundation
import Alamofire

class SessionManager: AuthManagerListener {
    weak var delegate: SessionManagerListener?

    private var authManager: AuthManager?
    private var session: Alamofire.Manager?

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

        return newSession
    }

    func onRequestFailedDueToAuthentication() {
        authManager?.clearUserTokens()

        self.delegate?.onSessionInvalidated()
    }

    // MARK: AuthManagerListener

    func onAuthSucceeded() {
        delegate?.onNewSession()
    }

    func onAuthFailed() {
        delegate?.onSessionInvalidated()
    }
}

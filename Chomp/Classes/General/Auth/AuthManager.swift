//
//  AuthManager.swift
//  Chomp
//
//  Created by Sky Welch on 05/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import Foundation
import Alamofire

class AuthManager: AuthServiceListener {
    var currentAuthedSession: Alamofire.Manager?
    
    let tokenStore: TokenStore
    var authInteractor: AuthService?
    var currentUser: String?
    weak var delegate: AuthManagerListener?

    private let session: SessionManager

    private let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    
    init(session: SessionManager) {
        self.session = session

        self.tokenStore = TokenStore()
        
        if self.doesUserHaveTokenStored() {
            if let (user, _) = self.getUserAndToken() {
                self.currentUser = user
            }
        }
    }
    
    func doesUserHaveTokenStored() -> Bool {
        return self.tokenStore.loginUsername != nil && self.tokenStore.loginToken != nil
    }
    
    func getUserAndToken() -> (user: String, token: String)? {
        if let user = self.tokenStore.loginUsername, let token = self.tokenStore.loginToken {
            return (user, token)
        } else {
            return nil
        }
    }
    
    func requestLoginToken(user: String, password: String) -> Bool {
        if self.authInteractor == nil {
            self.currentUser = user
            self.authInteractor = AuthService(session: self.session, delegate: self)
            self.authInteractor!.requestNewTokenForUser(self.currentUser!, password: password)
            return true
        } else {
            print("authInteractor interactor already running")
            return false
        }
    }

    func constructAuthCookie(token: String) -> NSHTTPCookie {
        let cookieProperties = [
            NSHTTPCookieDomain: session.currentDomain,
            NSHTTPCookiePath: "/",
            NSHTTPCookieName: "token",
            NSHTTPCookieValue: token,
            NSHTTPCookieExpires: NSDate(timeIntervalSinceNow: 60 * 60 * 24 * 10)
        ]
        
        return NSHTTPCookie(properties: cookieProperties)!
    }

    func constructAuthCookie() -> NSHTTPCookie? {
        var token = ""
        if let (_, authToken) = self.getUserAndToken() {
            token = authToken
        } else {
            return nil
        }

        return self.constructAuthCookie(token)
    }

    private func cookiesForAPI() -> [NSHTTPCookie] {
        if let cookies = self.cookieStorage.cookiesForURL(NSURL(string: "\(session.currentBaseHttpUrl)/")!) {
            print(cookies)
            return cookies
        }

        return []
    }

    private func clearCookiesForAPI() {
        for cookie in self.cookiesForAPI() {
            self.cookieStorage.deleteCookie(cookie)
        }
    }

    func clearUserTokens() {
        if let validCurrentUser = self.currentUser {
            self.tokenStore.clearTokensForUser(validCurrentUser)
        }

        self.currentAuthedSession = nil
    }

    // MARK: AuthInteractorListener
    
    func onAuthSucceededWithToken(token: String) {
        self.tokenStore.setLoginToken(self.currentUser!, token: token)
        print("successfully got token, store in keychain for user: \(self.currentUser!): \(token)")
        
        self.authInteractor = nil
        
        self.delegate?.onAuthSucceeded()
    }
    
    func onAuthFailed() {
        print("failed to authenticate")
        
        self.authInteractor = nil
        self.currentAuthedSession = nil
        
        self.delegate?.onAuthFailed()
    }
}
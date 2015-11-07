//
//  AuthService.swift
//  Chomp
//
//  Created by Sky Welch on 04/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    private weak var delegate: AuthServiceListener?
    private let session: SessionManager
    private let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    
    required init(session: SessionManager, delegate: AuthServiceListener) {
        self.session = session
        self.delegate = delegate
    }
    
    func requestNewTokenForUser(user: String, password: String) {
        let parameters = [
            "username": user,
            "password": password
        ]
        
        session.currentSession().request(.POST, "\(AppController.currentURL)/session", parameters: parameters, encoding: .JSON)
            .responseJSON { request, response, result in
                guard let strongDelegate = self.delegate else {
                    print("delegate not set, bailing data parsing")
                    return
                }
                
                switch (result) {
                case .Success(_):
//                    print(response)
                    let cookies = self.cookiesForAPI()
                    
                    var longestLivedTokenCookie: NSHTTPCookie?
                    
                    for cookie in cookies {
                        if cookie.name == "token" {
                            print("found token cookie: \(cookie.value)")
                            
                            if longestLivedTokenCookie == nil {
                                longestLivedTokenCookie = cookie
                            }
                            
                            if let longestExpiry = longestLivedTokenCookie?.expiresDate, let currentCookieExpiry = cookie.expiresDate {
                                if currentCookieExpiry.timeIntervalSinceReferenceDate > longestExpiry.timeIntervalSinceReferenceDate {
                                    longestLivedTokenCookie = cookie
                                }
                            }
                        }
                    }
                    
                    if let tokenCookie = longestLivedTokenCookie {
                        strongDelegate.onAuthSucceededWithToken(tokenCookie.value)
                        
//                        print(self.cookiesForAPI())
                    } else {
                        print("failed to extract token cookie from response cookies")
                        strongDelegate.onAuthFailed()
                    }
                case .Failure(let data, let error):
                    if data != nil {
                        if let string = String(data: data!, encoding: NSUTF8StringEncoding) {
                            print(string)
                        }
                    }
                    print(error)
                    strongDelegate.onAuthFailed()
                }
        }
    }

    private func cookiesForAPI() -> [NSHTTPCookie] {
        if let cookies = self.cookieStorage.cookiesForURL(NSURL(string: "\(AppController.currentURL)/")!) {
            print(cookies)
            return cookies
        }

        return []
    }
}
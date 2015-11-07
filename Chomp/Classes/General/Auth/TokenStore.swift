//
//  TokenStore.swift
//  Chomp
//
//  Created by Sky Welch on 05/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import Foundation
import SSKeychain

class TokenStore {
    let keychainService: String
    
    var loginUsername: String?
    var loginToken: String?
    
    init() {
        self.keychainService = "TokenStore"
        
        self.retrieveUserDetailsFromKeychain()
    }
    
    func retrieveUserDetailsFromKeychain() {
        let accounts = SSKeychain.accountsForService(self.keychainService)
        if accounts != nil && accounts.count > 0 {
            let credentials = accounts[accounts.count - 1]
            let accountName = credentials[kSSKeychainAccountKey] as? String
            let accountToken = SSKeychain.passwordForService(self.keychainService, account: accountName)
            
            if accountName != nil && accountToken != nil {
                self.loginUsername = accountName
                self.loginToken = accountToken
            }
        }
    }
    
    func setLoginToken(user: String, token: String) {
        do {
            try SSKeychain.deletePasswordForService(self.keychainService, account: user, error: ())
        } catch let error as NSError {
            print("error deleting token from keychain: \(error)")
        }
        
        SSKeychain.setPassword(token, forService: self.keychainService, account: user)
        self.loginUsername = user
        self.loginToken = token
    }
    
    func clearTokensForUser(user: String) {
        do {
            try SSKeychain.deletePasswordForService(self.keychainService, account: user, error: ())
        } catch let error as NSError {
            print("error deleting token from keychain: \(error)")
        }
        
        self.loginUsername = nil
        self.loginToken = nil
    }
}
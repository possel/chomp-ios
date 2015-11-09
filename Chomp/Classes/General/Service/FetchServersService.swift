//
//  FetchServersService.swift
//  Chomp
//
//  Created by Sky Welch on 03/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FetchServersService {
    private weak var delegate: FetchServersServiceListener?
    private let session: SessionManager
    
    required init(session: SessionManager, delegate: FetchServersServiceListener) {
        self.session = session
        self.delegate = delegate
    }
    
    func fetchServers() {
        session.currentSession().request(.GET, "\(session.currentBaseHttpUrl)/server/all")
            .responseJSON { request, response, result in
                guard let strongDelegate = self.delegate else {
                    print("delegate not set, bailing data parsing")
                    return
                }
                
                switch (result) {
                case .Success(let value):
                    let json = JSON(value)
                    if let serverModels: [ServerEntity] = JsonTypedArray.decodeTypedArray(json) {
                        strongDelegate.onFetchServersCompleted(serverModels)
                    } else {
                        print("Failed to parse server models from Possel response")
                        strongDelegate.onFetchServersFailed()
                    }
                case .Failure(let data, let error):
                    if response?.statusCode == 401 {
                        print("fetching servers failed due to authentication failure")
                        
                        self.session.onRequestFailedDueToAuthentication()
                    } else {
                        if data != nil {
                            if let string = String(data: data!, encoding: NSUTF8StringEncoding) {
                                print(string)
                            }
                        }
                        print(error)
                    }
                    
                    strongDelegate.onFetchServersFailed()
                }
            }
    }
}
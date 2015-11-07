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

class FetchBuffersService {
    private weak var delegate: FetchBuffersServiceListener?
    private let session: SessionManager
    
    required init(session: SessionManager, delegate: FetchBuffersServiceListener) {
        self.session = session
        self.delegate = delegate
    }
    
    func fetchBuffers() {
        session.currentSession().request(.GET, "\(AppController.currentURL)/buffer/all")
            .responseJSON { request, response, result in
                guard let strongDelegate = self.delegate else {
                    print("delegate not set, bailing data parsing")
                    return
                }
                
                switch (result) {
                case .Success(let value):
                    let json = JSON(value)
                    if let bufferModels: [BufferEntity] = JsonTypedArray.decodeTypedArray(json) {
                        strongDelegate.onFetchBuffersCompleted(bufferModels)
                    } else {
                        print("Failed to parse buffer models from Possel response")
                        strongDelegate.onFetchBuffersFailed()
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
                    
                    strongDelegate.onFetchBuffersFailed()
                }
            }
    }
}
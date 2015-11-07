//
//  FetchLinesService.swift
//  Chomp
//
//  Created by Sky Welch on 11/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FetchLinesService {
    private weak var delegate: FetchLinesServiceListener?
    private let session: SessionManager
    private let buffer: Int
    
    required init(session: SessionManager, delegate: FetchLinesServiceListener, buffer: Int) {
        self.session = session
        self.delegate = delegate
        self.buffer = buffer
    }
    
    func fetchLine(line: Int) {
        let requestURL = "\(AppController.currentURL)/line?id=\(line)"
        doRequest(requestURL)
    }
    
    func fetchLastLines(numberOfLines: Int) {
        let requestURL = "\(AppController.currentURL)/line?last=\(numberOfLines)&buffer=\(self.buffer)"
        doRequest(requestURL)
    }
    
    func doRequest(requestURL: String) {
        session.currentSession().request(.GET, requestURL)
            .responseJSON { request, response, result in
                guard let strongDelegate = self.delegate else {
                    print("delegate not set, bailing data parsing")
                    return
                }
                
                switch (result) {
                case .Success(let value):
                    let json = JSON(value)
                    if let serverLines: [LineEntity] = JsonTypedArray.decodeTypedArray(json) {
                        strongDelegate.onFetchLinesCompleted(self.buffer, lines: serverLines)
                    } else {
                        print("Failed to parse server models from Possel response")
                        strongDelegate.onFetchLinesFailed()
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

                    strongDelegate.onFetchLinesFailed()
                }
        }
    }
}
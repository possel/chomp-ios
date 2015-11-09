//
//  FetchUserInteractor
//  Chomp
//
//  Created by Sky Welch on 03/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SendLineService {
    private weak var delegate: SendLineServiceListener?
    private let session: SessionManager
    private let buffer: Int
    
    required init(session: SessionManager, delegate: SendLineServiceListener, buffer: Int) {
        self.session = session
        self.delegate = delegate
        self.buffer = buffer
    }
    
    func sendLine(line: String) {
        let parameters = [
                "buffer": String(buffer),
                "content": line
        ]

        session.currentSession().request(.POST, "\(session.currentBaseHttpUrl)/line", parameters: parameters, encoding: .JSON)
            .responseJSON { request, response, result in
                guard let strongDelegate = self.delegate else {
                    print("delegate not set, bailing data parsing")
                    return
                }
                
                switch (result) {
                case .Success(let value):
                    let json = JSON(value)
                    print(json)
                    strongDelegate.onSendLineCompleted(line)
                case .Failure(let data, let error):
                    if response?.statusCode == 401 {
                        print("sending line failed due to authentication failure")
                        
                        self.session.onRequestFailedDueToAuthentication()
                    } else {
                        if data != nil {
                            if let string = String(data: data!, encoding: NSUTF8StringEncoding) {
                                print(string)
                            }
                        }
                        print(error)
                    }
                    
                    strongDelegate.onSendLineFailed(line)
                }
            }
    
    }
}
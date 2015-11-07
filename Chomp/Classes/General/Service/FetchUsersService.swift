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

class FetchUsersService {
    private weak var delegate: FetchUsersServiceListener?
    private let session: SessionManager
    
    required init(session: SessionManager, delegate: FetchUsersServiceListener) {
        self.session = session
        self.delegate = delegate
    }
    
    func fetchUser(id: String) {
        session.currentSession().request(.GET, "\(AppController.currentURL)/user/\(id)")
            .responseJSON { request, response, result in
                guard let strongDelegate = self.delegate else {
                    print("delegate not set, bailing data parsing")
                    return
                }
                
                switch (result) {
                case .Success(let value):
                    let json = JSON(value)
                    if let userModels: [UserEntity] = JsonTypedArray.decodeTypedArray(json) {
                        strongDelegate.onFetchUserCompleted(userModels)
                    } else {
                        print("Failed to parse user models from Possel response")
                        strongDelegate.onFetchUserFailed()
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
                    
                    strongDelegate.onFetchUserFailed()
                }
            }
    
    }
}
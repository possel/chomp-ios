//
//  LoginViewController.swift
//  Chomp
//
//  Created by Sky Welch on 05/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import UIKit

class LoginViewController: ChompViewController {
    let authManager: AuthManager
    
    @IBOutlet weak var serverTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    init(authManager: AuthManager) {
        self.authManager = authManager
        super.init(nibName: "LoginViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LoginViewController viewDidLoad")
        
        self.title = "Chomp"
    }
    
    @IBAction func onLoginTouchUpInside(sender: AnyObject) {
        if let server = serverTextField.text, let username = usernameTextField.text, let password = passwordTextField.text {
            print("form input set")
            
            AppController.constructURLFromDomainAndPort(server, port: "8081")
            if self.authManager.requestLoginToken(username, password: password) {
                self.loginButton.setTitle("Logging in...", forState: UIControlState.Normal)
                
                return
            }
        }
        
        print("server: \(serverTextField.text) username: \(usernameTextField.text) password: \(passwordTextField.text)")
    }
}

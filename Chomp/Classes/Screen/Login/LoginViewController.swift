//
//  LoginViewController.swift
//  Chomp
//
//  Created by Sky Welch on 05/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import UIKit

class LoginViewController: ChompViewController, SessionManagerListener {
    private let session: SessionManager
    
    @IBOutlet weak var serverTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    init(session: SessionManager) {
        self.session = session
        super.init(nibName: "LoginViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LoginViewController viewDidLoad")
        
        self.title = "Chomp"
        
        Styling.styleActionButton(loginButton)

        serverTextField.text = session.currentDomain
        usernameTextField.text = session.currentUser
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        session.addListener(self)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        print("LoginViewController viewWillDisappear")

        session.removeListener(self)
    }
    
    @IBAction func onLoginTouchUpInside(sender: AnyObject) {
        if let server = serverTextField.text, let username = usernameTextField.text, let password = passwordTextField.text {
            print("form input set")


            if session.createNewSession(server, port: "8081", user: username, password: password) {
                loginButton.setTitle("Logging in...", forState: UIControlState.Normal)
            }
        }
        
        print("server: \(serverTextField.text) username: \(usernameTextField.text) password: \(passwordTextField.text)")
    }

    // MARK: SessionManagerListener

    func onNewSession() {
        print("LoginViewController notified of new session")
    }

    func onSessionInvalidated() {
        loginButton.setTitle("Login failed", forState: UIControlState.Normal)
    }
}

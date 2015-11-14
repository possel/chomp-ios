//
//  BufferViewController.swift
//  Chomp
//
//  Created by Sky Welch on 17/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import UIKit

class BufferViewController: ChompViewController, BufferView, UITextFieldDelegate {
    var presenter: BufferPresenter?
    var tableController: BufferTableController?
    
    var currentText = ""
    let buffer: BufferEntity
    
    @IBOutlet weak var bufferSendTextField: UITextField!
    @IBOutlet weak var bufferSendTextFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bufferSendTextFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bufferTable: UITableView!
    
    init(user: User, session: SessionManager, websocket: ChompWebsocket, buffer: BufferEntity) {
        self.buffer = buffer
        super.init(nibName: "BufferViewController", bundle: nil)
        self.presenter = BufferPresenter(view: self, websocket: websocket, buffer: buffer, session: session)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not NSCoder compliant")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.buffer.name
        bufferSendTextField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)

        setupTableView()

        presenter?.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        presenter?.viewWillDisappear()
    }
    
    func keyboardWillAppear(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(CATransaction.animationDuration(), animations: { () -> Void in
            self.bufferSendTextFieldBottomConstraint.constant = keyboardFrame.size.height
        })
    }

    func keyboardWillDisappear(notification: NSNotification) {
        UIView.animateWithDuration(CATransaction.animationDuration(), animations: { () -> Void in
            self.bufferSendTextFieldBottomConstraint.constant = 0
        })
    }

    @IBAction func handleBufferTableTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    // MARK: BufferSendTextField
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        presenter?.sendLineTapped(textField.text ?? "")
        
        return true
    }
    
    func clearLineInput() {
        bufferSendTextField.text = ""
    }

    func setupTableView() {
        self.tableController = BufferTableController(tableView: self.bufferTable, delegate: self.presenter!)
        self.presenter?.tableController = self.tableController
    }
}

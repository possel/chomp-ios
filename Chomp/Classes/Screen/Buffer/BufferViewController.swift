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
    
    var currentText = ""
    let buffer: BufferEntity
    
    @IBOutlet weak var bufferTextView: UITextView!
    @IBOutlet weak var bufferSendTextField: UITextField!
    @IBOutlet weak var bufferSendTextFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bufferSendTextFieldHeightConstraint: NSLayoutConstraint!
    
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
        self.styleViews()
        bufferSendTextField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
        
        presenter?.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        presenter?.viewWillDisappear()
    }

    func styleViews() {
        self.bufferTextView.text = ""
        self.bufferTextView.editable = false
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
    
    // MARK: BufferView

    func addLineToView(line: LineEntity) {
        var lineToAdd = "\(line.nick): \(line.content)"
        if !self.currentText.isEmpty {
            lineToAdd = "\n" + lineToAdd
        }
        
        let lineToAddString = lineToAdd as NSString
        let lineToAddLength = lineToAddString.length
        
        let currentTextString = currentText as NSString
        let currentLength = currentTextString.length

        self.currentText += lineToAdd
        self.bufferTextView.text = self.currentText
        
        self.bufferTextView.scrollRangeToVisible(NSMakeRange(currentLength, lineToAddLength))
    }
    
    // MARK: BufferSendTextField
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        presenter?.sendLineTapped(textField.text ?? "")
        
        return true
    }
    
    func clearLineInput() {
        bufferSendTextField.text = ""
    }
}

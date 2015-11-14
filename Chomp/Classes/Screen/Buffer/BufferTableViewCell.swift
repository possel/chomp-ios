//
//  BufferTableViewCell.swift
//  Chomp
//
//  Created by Sky Welch on 14/11/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import UIKit

class BufferTableViewCell: UITableViewCell {
    static let cellReuseIdentifier = "BufferTableViewCell"
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialise()
    }
    
    func initialise() {
        self.contentLabel.text = "hello buffer world"
    }
    
    override func prepareForReuse() {
        self.contentLabel.text = ""
    }
    
    func setContent(text: String) {
        contentLabel.text = text
    }
    
    func setNickname(text: String) {
        nicknameLabel.text = text
    }
}

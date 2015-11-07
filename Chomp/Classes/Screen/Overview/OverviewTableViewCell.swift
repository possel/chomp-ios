//
//  OverviewTableViewCell.swift
//  Chomp
//
//  Created by Sky Welch on 07/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import UIKit

class OverviewTableViewCell: UITableViewCell {
    static let cellReuseIdentifier = "OverviewTableViewCell"
    
    @IBOutlet weak var bufferNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialise()
    }
    
    func initialise() {
        self.bufferNameLabel.text = "hello buffer world"
    }
    
    override func prepareForReuse() {
        self.bufferNameLabel.text = ""
    }

    func setLabelText(text: String) {
        self.bufferNameLabel.text = text
    }
}

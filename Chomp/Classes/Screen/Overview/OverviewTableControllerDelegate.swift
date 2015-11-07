//
//  OverviewTableControllerDelegate.swift
//  Chomp
//
//  Created by Sky Welch on 07/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import Foundation

protocol OverviewTableControllerDelegate: class {
    func numberOfSections() -> Int
    func titleForSection(section: Int) -> String
    func numberOfItemsInSection(section: Int) -> Int
    func itemAtIndexPath(indexPath: NSIndexPath) -> (Int, String)?
    
    func onBufferTapped(id: Int)
}

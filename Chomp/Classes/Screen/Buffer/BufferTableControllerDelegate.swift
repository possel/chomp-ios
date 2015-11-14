//
// Created by Sky Welch on 14/11/2015.
// Copyright (c) 2015 Sky Welch. All rights reserved.
//

import Foundation

protocol BufferTableControllerDelegate: class {
    func numberOfItems(section: Int) -> Int
    func itemAtIndexPath(indexPath: NSIndexPath) -> (Int, String, String)?

    func onBufferRowTapped(id: Int)
}

//
// Created by Sky Welch on 02/11/2015.
// Copyright (c) 2015 Sky Welch. All rights reserved.
//

import UIKit

class Styling {
    class func styleNavigationBar(navigationBar: UINavigationBar) {
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName: UIColor.whiteColor() ]
        navigationBar.barTintColor = brandBlueColor()
        navigationBar.backgroundColor = brandBlueColor()
        navigationBar.barStyle = UIBarStyle.BlackTranslucent
        navigationBar.translucent = false
    }
    
    class func brandBlueColor() -> UIColor {
        return UIColor(red: 66.0 / 255.0, green: 165.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    }
    
    class func styleActionButton(button: UIButton) {
        button.backgroundColor = brandBlueColor()
        button.tintColor = .whiteColor()
        button.layer.cornerRadius = 5
    }
}

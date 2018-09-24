//
//  UIAppStyles.swift
//  Movies&Tvs
//
//  Created by Jesus on 9/23/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import UIKit

// MARK: - Colors
extension UIColor {
    
    class func semaphoreGreen() -> UIColor {
        return UIColor(red:34/255.0, green: 134/255.0, blue: 34/255.0, alpha: 1.0)
    }
    
    class func semaphoreRed() -> UIColor {
        return UIColor(red: 0.8823, green: 0.1019, blue: 0.1725, alpha: 1.0)
    }
    
    class func purpleBrown60Color(_ alpha: CGFloat = 0.6) -> UIColor {
        return UIColor(red: 35.0 / 255.0, green: 31.0 / 255.0, blue: 32.0 / 255.0, alpha: alpha)
    }
}

// MARK: - Fonts
extension UIFont {
    
    class func dateFont() -> UIFont {
        return UIFont(name: "Avenir", size: 10)!
    }
    
    class func titleFont() -> UIFont {
        return UIFont(name: "Avenir", size: 14)!
    }
}

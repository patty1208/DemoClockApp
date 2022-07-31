//
//  UIColor+Ext.swift
//  DemoClockApp
//
//  Created by 林佩柔 on 2022/7/31.
//

import Foundation
import UIKit

extension UIColor {
    static func getCustomBlueColor(alpha: CGFloat) -> UIColor {
        if alpha < 1 && alpha > 0 {
            return UIColor(red: 111/255, green: 134/255, blue: 167/255, alpha: alpha)
        } else {
            return UIColor(red: 111/255, green: 134/255, blue: 167/255, alpha: 1)
        }
    }
    static func getCustomGreenColor(alpha: CGFloat) -> UIColor {
        if alpha < 1 && alpha > 0 {
            return UIColor(red: 179/255, green: 198/255, blue: 191/255, alpha: alpha)
        } else {
            return UIColor(red: 179/255, green: 198/255, blue: 191/255, alpha: 1)
        }
        
    }
    static func getOrangeColor(alpha: CGFloat) -> UIColor {
        if alpha < 1 && alpha > 0 {
            return UIColor(red: 255/255, green: 147/255, blue: 0/255, alpha: alpha)
        } else {
            return UIColor(red: 255/255, green: 147/255, blue: 0/255, alpha: 1)
        }
    }
    static func getDarkOrangeColor() -> UIColor {
        UIColor(red: 168/255, green: 77/255, blue: 25/255, alpha: 1)
    }
    
    static func getDarkGreenColor() -> UIColor {
        UIColor(red: 104/255, green: 142/255, blue: 128/255, alpha: 1)
    }
    
}

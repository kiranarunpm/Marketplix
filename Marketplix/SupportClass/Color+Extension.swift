//
//  Color+Extension.swift
//  Marketplix
//
//  Created by Kiran PM on 16/04/23.
//

import Foundation
import UIKit

extension UIColor {
    class func colorFromHex(hex: Int) -> UIColor { return UIColor(red: (CGFloat((hex & 0xFF0000) >> 16)) / 255.0, green: (CGFloat((hex & 0xFF00) >> 8)) / 255.0, blue: (CGFloat(hex & 0xFF)) / 255.0, alpha: 1.0)
    }
    
    static var primaryColor  : UIColor { return UIColor.colorWithHexString("#0F75BC")}
    static var secondaryColor  : UIColor { return UIColor.colorWithHexString("#1C174C")}

    static var arBorderColor  : UIColor { return UIColor.colorWithHexString("#E5E5E5")}
    
    
    
}

extension UIColor {

class func colorWithHexString (_ hex: String) -> UIColor {
    var cString: String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
    /**      var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercased() */
    if cString.hasPrefix("#") {
        cString = (cString as NSString).substring(from: 1)
    }
    if cString.count != 6 {
        return UIColor.gray
    }
    let rString = (cString as NSString).substring(to: 2)
    let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
    let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
    var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
    Scanner(string: rString).scanHexInt32(&r)
    Scanner(string: gString).scanHexInt32(&g)
    Scanner(string: bString).scanHexInt32(&b)
    return UIColor(red: CGFloat(r) / 255.0,
                   green: CGFloat(g) / 255.0,
                   blue: CGFloat(b) / 255.0,
                   alpha: CGFloat(1))
}
    
    
}

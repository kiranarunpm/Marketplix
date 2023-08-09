//
//  Font+Extension.swift
//  Marketplix
//
//  Created by Kiran PM on 16/04/23.
//

import Foundation
import UIKit

extension UIFont {

    public enum MPfontType: String {
        case semibold = "-SemiBold"
        case regular = "-Regular"
        case light = "-Light"
        case bold = "-Bold"
        case medium = "-Medium"
    }

    static func MPfont(_ type: MPfontType = .regular, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return UIFont(name: "Poppins\(type.rawValue)", size: size)!
    }

    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }

    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }

}

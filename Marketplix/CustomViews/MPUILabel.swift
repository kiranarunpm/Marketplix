//
//  MPUILabel.swift
//  Marketplix
//
//  Created by Kiran PM on 16/04/23.
//

import UIKit

enum FontType: Int {
    
    case regular = 0
    case medium = 1
    case semibold = 2
    case bold = 3
    
}

@IBDesignable class MPUILabel: UILabel {
    
    @IBInspectable var style: Int = 0 {
        didSet {
            updateUI()
        }
    }
    
    @IBInspectable var fontSize: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }
    
    @IBInspectable var fontStyle: Int = 0 {
        didSet {
            updateUI()
        }
    }
    @IBInspectable var applyTitleCase:Bool = false {
        didSet{
            callApplyTitleCase()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    override func prepareForInterfaceBuilder() {
        updateUI()
    }
    
    func callApplyTitleCase() {
        if applyTitleCase{
            text = text?.capitalized(with: NSLocale.current)
        }
    }
    
    
    //MARK: GetFontStyle
    func getFontStyle() {
        
        switch FontType(rawValue: fontStyle) {
            
        case .regular: font = UIFont.MPfont(.regular, size: fontSize)
            
        case .medium: font = UIFont.MPfont(.medium, size: fontSize)
            
        case .semibold: font = UIFont.MPfont(.semibold, size: fontSize)
            
        case .bold: font = UIFont.MPfont(.bold, size: fontSize)
            
        default: break
            
        }
    }
    
    
    //MARK: LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch style {
            
        case 0: textColor = UIColor.primaryColor
            
        case 1: textColor = UIColor.darkGray

        case 2: textColor = UIColor.secondaryColor
            
        case 3: textColor = UIColor.black

        case 4: textColor = UIColor.white

        case 5: textColor = UIColor.red
            
        case 6: textColor = UIColor(named: "PriceGreenColor")

        default: textColor = UIColor.primaryColor
            
        }
        
        getFontStyle()
    }
    
    //MARK: UpdateUI
    func updateUI(){
        
        switch style {
            
        case 0: textColor = UIColor.primaryColor
            
        case 1: textColor = UIColor.darkGray
            
        case 2: textColor = UIColor.secondaryColor

        case 3: textColor = UIColor.black
            
        case 4: textColor = UIColor.white

        case 5: textColor = UIColor.red

        case 6: textColor = UIColor(named: "PriceGreenColor")

        default: textColor = UIColor.primaryColor
            
        }
        getFontStyle()
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

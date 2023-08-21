//
//  MPButton.swift
//  Marketplix
//
//  Created by Kiran PM on 16/04/23.
//

import Foundation
import UIKit


@IBDesignable class MPUIButton: UIButton {
    
    @IBInspectable var style: Int = 0 {
        didSet {
            updateView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateView()
    }
    
    override func prepareForInterfaceBuilder() {
        updateView()
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func awakeFromNib() {
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    //MARK: LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch style {
            
        case 0:
            if shadowLayer == nil {
                shadowLayer = nil

                addShadowPathLayer(fillColor: UIColor.primaryColor)
                self.setTitleColor(UIColor.white, for: .normal)
            }
            
        case 1:
            
            if shadowLayer != nil {
                shadowLayer.removeFromSuperlayer()
                shadowLayer = nil
            }
            layer.cornerRadius = frame.height/2
            backgroundColor = UIColor(named: "BackGroundColor")
            setTitleColor(UIColor.black, for: .normal)
            layer.borderWidth = 1
            layer.borderColor = UIColor.lightGray.cgColor

        default: break
            
        }
    }
    
 
    
    func updateView() {

        switch style {
            
        case 0:
            
            if shadowLayer != nil {
                shadowLayer = nil

                addShadowPathLayer(fillColor: UIColor.primaryColor)
                self.setTitleColor(UIColor.white, for: .normal)
                self.titleLabel?.font =  UIFont.MPfont(.semibold, size: 14)

            }
            
        case 1:
            
            if shadowLayer != nil {
                shadowLayer.removeFromSuperlayer()
                shadowLayer = nil
            }
            layer.cornerRadius = frame.height/2
            backgroundColor = UIColor(named: "BackGroundColor")
            setTitleColor(UIColor.black, for: .normal)
            layer.borderWidth = 1
            layer.borderColor = UIColor.lightGray.cgColor
            
        
            
        default: break
            
        }
    }
    
    //MARK: AddShadowPathLayer
    func addShadowPathLayer(fillColor: UIColor) {
        shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height/2).cgPath
        shadowLayer.fillColor = fillColor.cgColor
        layer.cornerRadius = frame.height/2
        layer.insertSublayer(shadowLayer, at: 0)
    }
}

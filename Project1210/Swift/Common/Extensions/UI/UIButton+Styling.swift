//
//  UIButton+Styling.swift
//  Project1210
//
//  Created by Ilayda Kodal on 4/4/21.
//

import UIKit

extension UIButton{
    
    func applyDefaultStyling(offset: CGSize = CGSize(width: 0, height: 1),
                             radius: CGFloat = 1.0,
                             opacity: Float = 0.5,
                             color: UIColor,
                             spread: CGFloat = .zero) {
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        
        if spread == .zero {
            layer.shadowPath = nil
        }else{
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

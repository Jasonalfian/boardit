//
//  Tutorial.swift
//  BoardIt
//
//  Created by Farrel Anshary on 15/06/21.
//

import Foundation
import UIKit

class Tutorial {
    static func createOverlay(frame: CGRect, element: UIView, haveSideBar: Bool) -> UIView {
        let overlayView = UIView(frame: frame)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let xOffset = haveSideBar ? element.frame.origin.x + 300 : element.frame.origin.x
        let yOffset = element.frame.origin.y
        let width = element.frame.width
        let height = element.frame.height
        
        let path = CGMutablePath()
        path.addRoundedRect(in: CGRect(x: xOffset, y: yOffset + 23, width: width, height: height), cornerWidth: 25, cornerHeight: 25)
        path.addRect(CGRect(origin: .zero, size: overlayView.frame.size))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        maskLayer.cornerRadius = 50
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        
        return overlayView
    }
}

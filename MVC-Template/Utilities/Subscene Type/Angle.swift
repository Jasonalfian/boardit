//
//  structSubScene.swift
//  BoardIt
//
//  Created by Jason Hartanto on 10/06/21.
//
import UIKit
import Foundation

struct Angle{
    var name: String
    var description: String
    var gambar: UIImage
    
    static func generateAngle() -> [Angle] {
        
        return [ Angle(name: "Low Angle", description: "This shot frames the subject from below a their eyeline. Low angle camera shots are a perfect camera angle for signaling superiority or to elicit feelings of fear and dread.", gambar: #imageLiteral(resourceName: "angle-lowAngle") ),
                 
        Angle(name: "MDd Angle", description: "Yeah this is a mid angle", gambar: #imageLiteral(resourceName: "angle-lowAngle") )
        
        ]
    }
    
}

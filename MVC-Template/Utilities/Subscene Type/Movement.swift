//
//  structSubScene.swift
//  BoardIt
//
//  Created by Jason Hartanto on 10/06/21.
//
import UIKit
import Foundation

struct Movement{
    var name: String
    var description: String
    var gambar: UIImage
    var gambar2: UIImage
    var gambar3: UIImage
    
    static func generateMovement() -> [Movement] {
        
        return [
            Movement(name: "Pan", description: "Panning is when you move your camera horizontally; either left to right or right to left, while its base is fixated on a certain point. You are not moving the position of the camera itself, just the direction it faces.", gambar: #imageLiteral(resourceName: "movement-pan1"), gambar2: #imageLiteral(resourceName: "movement-pan2"), gambar3: #imageLiteral(resourceName: "movement-pan3")),
            
            Movement(name: "Push In", description: "The camera physically moves towards the subject in the film, getting closer to them and tightening in on the subject and the scene. This can also be done with certain lenses instead of moving the camera.", gambar: #imageLiteral(resourceName: "movement-pushIn1"), gambar2: #imageLiteral(resourceName: "movement-pushIn2") , gambar3: #imageLiteral(resourceName: "movement-pushIn3")),
            
            Movement(name: "Push Out", description: "The camera physically moves back, or a special lens does, from the subject. The push out is used to reveal a larger picture for the audience.", gambar: #imageLiteral(resourceName: "movement-pushOut1"), gambar2: #imageLiteral(resourceName: "movement-pushOut2") , gambar3: #imageLiteral(resourceName: "movement-pushOut3")),
            
            Movement(name: "Static", description: "It is a shot that is devoid of camera movement. Also known as a locked-off shot, or an immobile shot. The frame can be filled with the movement of vehicles, characters, props, etc, but the frame itself does not move.", gambar: #imageLiteral(resourceName: "movement-static"), gambar2: #imageLiteral(resourceName: "movement-static"), gambar3: #imageLiteral(resourceName: "movement-static")),
            
            Movement(name: "Tilt", description: "Tilting is when you move the camera vertically, up to down or down to up, while its base is fixated to a certain point. This move usually use a tripod where the camera is stationary but you move the angle it points to.", gambar: #imageLiteral(resourceName: "movement-tilt1"), gambar2: #imageLiteral(resourceName: "movement-tilt2"), gambar3: #imageLiteral(resourceName: "movement-tilt3")),
            
            Movement(name: "Tracking", description: "A tracking shot is any shot that physically moves the camera through the scene for an extended amount of time. Tracking shots often follow a traveling subject, though they can be used to simply show off the scene.", gambar: #imageLiteral(resourceName: "movement-tracking1"), gambar2: #imageLiteral(resourceName: "movement-tracking2"), gambar3: #imageLiteral(resourceName: "movement-tracking3"))
        ]
        
    }
    
}

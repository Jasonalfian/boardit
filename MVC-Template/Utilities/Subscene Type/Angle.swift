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
        
        return [
            
            Angle(name: "Eye Level", description: "this is when your subject is at eye-level. An eye level shot can result in a neutral perspective (not superior or inferior). This mimics how we see people in real life.", gambar: #imageLiteral(resourceName: "angle-eyeLevel")),
            
        Angle(name: "Low Angle", description: "This shot frames the subject from below a their eyeline. Low angle camera shots are a perfect camera angle for signaling superiority or to elicit feelings of fear and dread.", gambar: #imageLiteral(resourceName: "angle-lowAngle") ),
                 
        Angle(name: "High Angle", description: "The camera points down at your subject. It usually creates a feeling of inferiority, or “looking down” on your subject.", gambar: #imageLiteral(resourceName: "angle-highAngle") ),
            
        Angle(name: "Hip Level", description: "A hip shot is when your camera is roughly waist-high. Hip level shots are often useful when one subject is seated while the other stands.", gambar: #imageLiteral(resourceName: "angle-hipLevel")),
            
        Angle(name: "Ground Level", description: "A ground level shot is when your camera’s height is on ground level with your subject. This camera angle is used a lot to feature a character walking without revealing their face, but it can help to make the viewer more active." , gambar: #imageLiteral(resourceName: "angle-groundLevel")),
            
        Angle(name: "Bird Eye", description: "This shot refers to a shot looking directly down on the subject. This shot can be used to give an overall establishing shot of a scene, or to emphasise the smallness or insignificance of the subjects.", gambar: #imageLiteral(resourceName: "angle-birdEye")),
            
        Angle(name: "Dutch Angle", description: "he camera is slanted to one side. With the horizon lines tilted in this way, you can create a sense of disorientation, a de-stabilized mental state, or increase the tension.", gambar: #imageLiteral(resourceName: "angle-dutchAngle")),
            
        Angle(name: "Over the Shoulder", description: "An overhead shot is from above, looking down on your subject. These are typically shot from 90 degrees above — anything less might be considered a high angle shot instead.", gambar: #imageLiteral(resourceName: "angle-overTheShoulder")),
            
        ]
    }
    
}

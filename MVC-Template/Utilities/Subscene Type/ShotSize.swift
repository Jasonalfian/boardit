//
//  structSubScene.swift
//  BoardIt
//
//  Created by Jason Hartanto on 10/06/21.
//
import UIKit
import Foundation

struct ShotSize{
    var name: String
    var description: String
    var gambar: UIImage
    
    static func generateShotSize() -> [ShotSize] {
        
        return [
            ShotSize(name: "Extreme Wide Shot", description: "a camera shot that will make your subject appear small against their location. You can also use an extreme long shot to make your subject feel distant or unfamiliar.", gambar: #imageLiteral(resourceName: "shotSize-extremeLongShot")),
            
            ShotSize(name: "Long Shot", description: "a camera shot that balances both the subject and the surrounding imagery. A wide shot will often keep the entire subject in frame while giving context to the environment. It keeps a good deal of space both above and below your subject.", gambar: #imageLiteral(resourceName: "shotsSize-longShot")),
            
            ShotSize(name: "Medium Wide Shot", description: "frames the subject from roughly the knees up. It splits the difference between a full shot and a medium shot.", gambar: #imageLiteral(resourceName: "shotSize-mediumLongShot")),
            
            ShotSize(name: "Medium Shot", description: "Frames from roughly the waist up and through the torso. So it emphasizes more of your subject while keeping their surroundings visible", gambar: #imageLiteral(resourceName: "shotSize-mediumShot")),
            
            ShotSize(name: "Medium Close Up", description: "The medium close-up frames your subject from roughly the chest up. So it typically favors the face, but still keeps the subject somewhat distant.", gambar: #imageLiteral(resourceName: "shotSize-mediumCloseUp")),
            
            ShotSize(name: "Close Up", description: "The close-up camera shot fills your frame with a part of your subject. If your subject is a person, it is often their face.", gambar: #imageLiteral(resourceName: "shotSize-closeUp")),
            
            ShotSize(name: "Extreme Close Up", description: "An extreme close-up shot is a type of camera shot size in film that fills the frame with your subject, and is so close that we can pick up tiny details that would otherwise be difficult to see.", gambar: #imageLiteral(resourceName: "shotSize-extremeCloseUp")),
        
        ]
    }
    
}

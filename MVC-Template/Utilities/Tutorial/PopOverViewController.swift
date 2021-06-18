//
//  PopOverViewController.swift
//  BoardIt
//
//  Created by Farrel Anshary on 17/06/21.
//

import UIKit

class PopOverViewController: UIViewController {
    
    var tutorialText: String?
    var tutorialSteps: String?
    @IBOutlet weak var tutorialLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tutorialLabel.text = tutorialText
        tutorialLabel.sizeToFit()
        
        stepsLabel.text = "\(tutorialSteps!)/17"
        
        preferredContentSize = CGSize(width: tutorialLabel.frame.width + 40, height: tutorialLabel.frame.height + 20 + 20 + 25 + 20)
        
        
        // Do any additional setup after loading the view.
    }

}

//
//  PopOverViewController.swift
//  BoardIt
//
//  Created by Farrel Anshary on 17/06/21.
//

import UIKit

class PopOverViewController: UIViewController {
    
    var tutorialText: String?
    @IBOutlet weak var tutorialLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tutorialLabel.text = tutorialText
        tutorialLabel.sizeToFit()
        
        preferredContentSize = CGSize(width: tutorialLabel.frame.width + 40, height: tutorialLabel.frame.height + 40)
        
        
        // Do any additional setup after loading the view.
    }

}

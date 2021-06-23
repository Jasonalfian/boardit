//
//  PopOverViewController.swift
//  BoardIt
//
//  Created by Farrel Anshary on 17/06/21.
//

import UIKit

class PopOverViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var tutorialText: String?
    var tutorialSteps: String?
    var onDismiss: ((Bool) -> Void)?
    var isInsideModal: Bool?
    var hasSidebar: Bool?
    @IBOutlet weak var tutorialLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tutorialLabel.text = tutorialText
        tutorialLabel.sizeToFit()
        
        stepsLabel.text = tutorialSteps ?? ""
        
        preferredContentSize = CGSize(width: tutorialLabel.frame.width + 40, height: tutorialLabel.frame.height + 20 + 20 + 25 + 20)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if hasSidebar! {
            if isInsideModal! {
                self.presentingViewController?.presentingViewController?.view.alpha = 0.3
            }
            else {
                self.presentingViewController?.view.alpha = 0.3
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if hasSidebar! {
            if isInsideModal! {
                self.presentingViewController?.presentingViewController?.view.alpha = 1
            }
            else {
                self.presentingViewController?.view.alpha = 1
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let doDismiss = onDismiss {
            doDismiss(true)
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        onDismiss!(true)
    }

}

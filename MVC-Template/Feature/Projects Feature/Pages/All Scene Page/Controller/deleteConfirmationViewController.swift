//
//  deleteConfirmationViewController.swift
//  BoardIt
//
//  Created by Jason Hartanto on 20/06/21.
//

import UIKit

class deleteConfirmationViewController: UIViewController {
    
    var rowNumber:Int!
    var project:Project!
    var coreData = CoreDataManager()
    
    @IBOutlet weak var deleteWarning: UITextView!
    
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yesButton.layer.cornerRadius = 15
        yesButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 15
        deleteView.layer.cornerRadius = 15
        
        let boldText = String(describing: project.name!)
        
        deleteWarning.text = "Are you sure you want to delete project -\(boldText)- and it's content?"
        
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion:nil)
    }
    
    @IBAction func yesAction(_ sender: UIButton) {
        
        coreData.removeProject(project: project)
     
        NotificationCenter.default.post(name: Notification.Name("load"), object:rowNumber)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

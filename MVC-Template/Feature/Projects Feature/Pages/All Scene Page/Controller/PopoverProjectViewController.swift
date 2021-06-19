//
//  NewProjectViewController.swift
//  BoardIt
//
//  Created by Harrya Grahila Prabaswara on 15/06/21.
//

import UIKit
class PopoverProjectViewController: UIViewController{
    
    @IBOutlet weak var renameButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var buttonRow:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    
    @IBAction func renameAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "renamePopOver"), object: buttonRow)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        
    }
    
}

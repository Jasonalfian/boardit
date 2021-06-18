//
//  editSaveModalViewController.swift
//  BoardIt
//
//  Created by Jason Hartanto on 14/06/21.
//

import UIKit

class EditSaveModalViewController: UIViewController {
    
    var segueSender:String!
    var segueSave:Save!
    var anyDifference:Bool!
    var haveSavedSegue:Bool!
    var coreData = CoreDataManager()
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var chechBox: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var viewHolder: UIView!
    @IBOutlet weak var saveOnly: UIButton!
    @IBOutlet weak var saveOnlyLabel: UILabel!
    @IBOutlet weak var saveOnlyView: UIView!
    @IBOutlet weak var warningView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warningView.layer.cornerRadius = 15
        
        yesButton.layer.cornerRadius = 15
        yesButton.layer.borderWidth = 1
        
        noButton.layer.cornerRadius = 15
        noButton.layer.borderWidth = 1
        
        saveOnly.layer.cornerRadius = 15
        
        viewHolder.layer.cornerRadius = 15
        
            if (segueSender == "saveButton") {
                
                self.warningLabel.text = "You haven't filled all part, keep saving?"
                self.saveOnlyView.isHidden = true
                self.warningView.isHidden = false
                
            }

            if (self.segueSender == "backButton") {
               
                    self.warningLabel.text = "Are you sure you want to leave without saving?"
                    self.saveOnlyView.isHidden = true
                    self.warningView.isHidden = false
                
            }

            if (self.segueSender == "saveOnlySegue"){
               
                    print("masuk saveOnlySegue")
                    self.saveOnlyView.isHidden = false
                    self.warningView.isHidden = true
                    
                if (self.haveSavedSegue == true || anyDifference == false){
                        self.saveOnlyLabel.text = "Your changes have been saved"
                    } else {
                        self.saveOnlyLabel.text = "Your changes have been saved"
                    
                }
            }
        }
             
    
    @IBAction func yesButtonAction(_ sender: UIButton) {
        
        if (chechBox.isSelected == true) {
            coreData.changeSaveState(saving: segueSave)
            NotificationCenter.default.post(name: Notification.Name("refreshSave"), object:nil)
        }
        
        if (segueSender == "saveButton" ){
        NotificationCenter.default.post(name: Notification.Name("saveSubScene"), object:nil)
            NotificationCenter.default.post(name: Notification.Name("resetSaveTrigger"), object:nil)
        print("Saved with some empty attribute"
        )}
        
        self.dismiss(animated: true, completion: nil)
        if (segueSender == "backButton"){
            NotificationCenter.default.post(name: Notification.Name("backMainPage"), object:nil)
            print("Exit without saving")
        }
    }
    
    @IBAction func noButtonAction(_ sender: UIButton) {
        
        if (chechBox.isSelected == true) {
            coreData.changeSaveState(saving: segueSave)
            NotificationCenter.default.post(name: Notification.Name("refreshSave"), object:nil)
        }
        self.dismiss(animated: true, completion: nil)
        print("no selected")
    }
    
    @IBAction func saveOnly(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeCheckBox(_ sender: UIButton) {
            sender.isSelected = !sender.isSelected
    }
}

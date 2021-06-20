//
//  NewProjectTableViewCell.swift
//  BoardIt
//
//  Created by Nicholas Kusuma on 14/06/21.
//

import UIKit

class NewProjectTableViewCell: UITableViewCell, UITextViewDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var Bulet: UIView!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var projectDate: UILabel!
    @IBOutlet weak var projectTextView: UITextView!
    @IBOutlet weak var editProject: UIButton!
    
    var placeHolder = "-"
    var viewController:UIViewController!
    var indexRowNumber:Int!
    var coreData = CoreDataManager()
    
    var project:Project!
    var listProject:[Project]!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        projectName.isHidden = true
        projectTextView.isEditable = false
        
        projectTextView.delegate = self
        self.projectTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        NotificationCenter.default.addObserver(self, selector: #selector(goToDeleteWarning), name: NSNotification.Name(rawValue: "deleteWarning"), object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(runFromPopover), name: NSNotification.Name("runFromPopover"), object: nil)
//         Initialization code
//        Bulet.layer.cornerRadius = 9
//        Bulet.layer.borderWidth = 1
//        Bulet.layer.borderColor = #colorLiteral(red: 0.1000000015, green: 0.1000000015, blue: 0.1000000015, alpha: 1)
    }
    
    @objc func goToDeleteWarning(_ data: Notification) {
        
        let rowNumber = data.object as! Int
        
        let storyboard : UIStoryboard = UIStoryboard(name: "AllScenePage", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "deleteProjectWarning") as! deleteConfirmationViewController
        
        listProject = coreData.getAllData(entity: Project.self)
        
        vc.modalPresentationStyle = .overFullScreen
        vc.project = listProject[rowNumber]
        vc.rowNumber = rowNumber
        
        viewController.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func editProject(_ sender: UIButton) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "AllScenePage", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "testPopOver") as! PopoverProjectViewController
        
            vc.modalPresentationStyle = .popover
         
//        vc.preferredContentSize = CGSize(width: 150, height: 100)
        vc.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.left
                vc.popoverPresentationController?.delegate = self
                vc.popoverPresentationController?.sourceView = sender // button
                vc.popoverPresentationController?.sourceRect = sender.bounds
        
        vc.buttonRow = indexRowNumber
        
        viewController.present(vc, animated: true, completion:nil)
        
    }
    
//    @objc func runFromPopover() {
//
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "renamePopOver"), object: indexRowNumber)
//    }
    
    func renameProject() {
            projectTextView.isEditable = true
            projectTextView.becomeFirstResponder()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textView.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        // make sure the result is under 16 characters
        return updatedText.count <= 21
    }
    
    @objc func tapDone(sender: Any) {
            projectTextView.resignFirstResponder()
            projectTextView.isEditable = false
            
        coreData.updateProject(project: project, name: projectTextView.text)
        
        }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if projectTextView.textColor == .lightGray {
            projectTextView.text = ""
            projectTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if projectTextView.text.isEmpty {
            projectTextView.text = placeHolder
            projectTextView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
           
    }
    
}

//extension UITextView {
//
//    func addDoneButton(title: String, target: Any, selector: Selector) {
//
//        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
//                                              y: 0.0,
//                                              width: UIScreen.main.bounds.size.width,
//                                              height: 44.0))//1
//        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
//        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
//        toolBar.setItems([flexible, barButton], animated: false)//4
//        self.inputAccessoryView = toolBar//5
//    }
//}

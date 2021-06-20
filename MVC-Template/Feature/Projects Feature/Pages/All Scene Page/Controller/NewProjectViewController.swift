//
//  NewProjectViewController.swift
//  BoardIt
//
//  Created by Harrya Grahila Prabaswara on 15/06/21.
//

import UIKit
class NewProjectViewController: UIViewController, UITextFieldDelegate{
    
    var aspectRatio = 0
    var coreData = CoreDataManager()
    var listProject:[Project] = []
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var projectNameTextField: UITextField!
    
    @IBOutlet weak var enamBelasButton: UIButton!
    @IBOutlet weak var enamBelasPressed: UILabel!
    @IBAction func enamBelasButton(_ sender: Any) {
        enamBelasPressed.layer.borderWidth = 1
        satuPressed.layer.borderWidth = 0
        empatPressed.layer.borderWidth = 0
        aspectRatio = 16
    }

    @IBOutlet weak var empatPressed: UILabel!
    @IBOutlet weak var empatButton: UIButton!
    @IBAction func empatButton(_ sender: Any) {
        enamBelasPressed.layer.borderWidth = 0
        satuPressed.layer.borderWidth = 0
        empatPressed.layer.borderWidth = 1
        aspectRatio = 4
    }

    @IBOutlet weak var satuPressed: UILabel!
    @IBOutlet weak var satuButton: UIButton!
    @IBAction func satuButton(_ sender: Any) {
        enamBelasPressed.layer.borderWidth = 0
        satuPressed.layer.borderWidth = 1
        empatPressed.layer.borderWidth = 0
        aspectRatio = 1
    }
    
    var vc: ProjectViewController!
    
    @IBAction func createNewProjectButton(_ sender: Any) {
        if projectNameTextField.text == ""
        {
            print("User belum memasukkan data secara lengkap")
        }
        else
        {
            coreData.createProject(name: projectNameTextField.text!, ratio: Int64(aspectRatio))
            projectNameTextField.text = ""
            enamBelasPressed.layer.borderWidth = 0
            satuPressed.layer.borderWidth = 0
            empatPressed.layer.borderWidth = 0
            aspectRatio = 0
            
            listProject = coreData.getAllData(entity: Project.self)
            coreData.createScene(project: listProject[0])
            
//            self.performSegue(withIdentifier: "unwind", sender: self)
            
//            vc.projectTable.reloadData()
            
//            NotificationCenter.default.post(name: NSNotification.Name("loadFromProject"), object: listProject[0])
            
            NotificationCenter.default.post(name: NSNotification.Name("load"), object: 0)
            
            if((self.presentingViewController) != nil){
                self.dismiss(animated: true, completion: nil)
              print("cancel")
             }
        }
    }
    
    @objc func handleTap()
    {
        projectNameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ projectName: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue){
            let keyboardFrame = keyboardSize.cgRectValue
//            if popUpView.frame.origin.y == 232 {
            let viewBottomY = popUpView.frame.maxY
            let keyboardTopY = keyboardFrame.minY
            popUpView.frame.origin.y -= (viewBottomY - keyboardTopY) + 50
//            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if popUpView.frame.origin.y != 0 {
            popUpView.frame.origin.y -= -200
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.projectNameTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
        enamBelasPressed.layer.cornerRadius = 15
        empatPressed.layer.cornerRadius = 15
        satuPressed.layer.cornerRadius = 15

        enamBelasButton.layer.borderWidth = 1
        enamBelasButton.layer.shadowOpacity = 1
        enamBelasButton.layer.shadowOffset = CGSize(width: 1, height: 2)

        empatButton.layer.borderWidth = 1
        empatButton.layer.shadowOpacity = 1
        empatButton.layer.shadowOffset = CGSize(width: 1, height: 2)

        satuButton.layer.borderWidth = 1
        satuButton.layer.shadowOpacity = 1
        satuButton.layer.shadowOffset = CGSize(width: 1, height: 2)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

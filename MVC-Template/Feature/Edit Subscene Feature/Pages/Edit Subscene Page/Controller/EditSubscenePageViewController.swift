//
//  EditSubscenePageViewController.swift
//  BoardIt
//
//  Created by Gilbert Nicholas on 08/06/21.
//

import UIKit

class EditSubscenePageViewController: UIViewController, UITextViewDelegate {
    
    var listProject:[Project] = []
    var listScene:[Scene] = []
    var listSubScene:[SubScene] = []
    
    var coreData = CoreDataManager()
    
    public static let shared = EditSubscenePageViewController()

    @IBOutlet weak var playButton: UIBarButtonItem!
    @IBOutlet weak var redoTutorial: UIBarButtonItem!
    
    @IBOutlet weak var descriptionEditor: UITextView!
    @IBOutlet weak var storyboardImage: UIImageView!
    
    @IBOutlet weak var angleTypeSelector: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shotSizeSelector: UIButton!
    @IBOutlet weak var movementTypeSelector: UIButton!
    
    var placeHolder = "Enter your description here"
    var descriptionText = ""
    var sceneName = ""
    
    var angle:String = ""
    var shotSize:String = ""
    var movement:String = ""
    
    @objc func changeText(_ data: Notification){
        
        let arrayData = data.object as! [String]
        
        print(arrayData)
        
        if(arrayData[1] == "Angle Type"){
            self.angleTypeSelector.setTitle("- \(arrayData[0]) -", for: .normal)
        } else if(arrayData[1] == "Shot Type"){
            self.shotSizeSelector.setTitle("- \(arrayData[0]) -", for: .normal)
        } else if(arrayData[1] == "Movement Type"){
            self.movementTypeSelector.setTitle("- \(arrayData[0]) -", for: .normal)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("jalan")
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeText), name: Notification.Name("refresh"), object: nil)
        
        super.viewWillAppear(true)
        
        if (sceneName == "") {
            self.title = "Test Title"
        }
        
        initalSetup()
        // Do any additional setup after loading the view.
    }
    
    func initalSetup() {
        
        descriptionEditor.delegate = self
        
        descriptionEditor.layer.cornerRadius = 15
        descriptionEditor.layer.borderWidth = 1

        storyboardImage.layer.cornerRadius = 15
        storyboardImage.clipsToBounds = true
        
        if (descriptionText == "") {
            descriptionEditor.text = placeHolder
            descriptionEditor.textColor = .lightGray
        } else {
            descriptionEditor.text = description
            descriptionEditor.textColor = .black
        }
        
        self.descriptionEditor.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        saveButton.layer.cornerRadius = 15
        
        if angle != "" {
            angleTypeSelector.setTitle(angle, for: .normal)
        }
        
        if shotSize != "" {
            angleTypeSelector.setTitle(shotSize, for: .normal)
        }
        
        if movement != "" {
            angleTypeSelector.setTitle(movement, for: .normal)
        }
        
        listSubScene = coreData.getAllData(entity: SubScene.self)
        
        storyboardImage.image = UIImage(data: listSubScene[0].storyboard!)
//
    }
    
    @objc func tapDone(sender: Any) {
            self.view.endEditing(true)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let newVC = segue.destination as? EditModalTypeController else {return}
        
        if (segue.identifier == "angleSegue"){
            newVC.titleSegue = "Angle Type"
        }
        if (segue.identifier == "shotSegue"){
            newVC.titleSegue = "Shot Type"
        }
        if (segue.identifier == "movementSegue"){
            newVC.titleSegue = "Movement Type"
        }
    }
    
    func checkPlaceHolder(){
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionEditor.textColor == .lightGray {
            descriptionEditor.text = ""
            descriptionEditor.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionEditor.text.isEmpty {
            descriptionEditor.text = "Please comment here..."
            descriptionEditor.textColor = UIColor.lightGray
            placeHolder = ""
        } else {
            placeHolder = textView.text
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
            placeHolder = textView.text
        }
    
//    public func setAngleType(angleType: String) {
//
//        self.angle = angleType
//    }
//
//    func setShotSize(shotSize: String){
//        self.shotSize = shotSize
//    }
//
//    func setMovementType(movementType: String){
//        self.movement = movementType
//    }
//
    @IBAction func goToPresentationPage(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
    }
    
    
    @IBAction func reDoTutorial(_ sender: UIBarButtonItem) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension UITextView {
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}


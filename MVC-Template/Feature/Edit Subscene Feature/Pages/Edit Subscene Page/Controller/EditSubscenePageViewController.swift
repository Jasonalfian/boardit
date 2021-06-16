//
//  EditSubscenePageViewController.swift
//  BoardIt
//
//  Created by Gilbert Nicholas on 08/06/21.
//

import UIKit

class EditSubscenePageViewController: UIViewController, UITextViewDelegate {
    
    //core data placeholder
    var listProject:[Project] = []
    var listScene:[Scene] = []
    var listSubScene:[SubScene] = []
    var listSave:[Save] = []
    
    //list of struct
    var listAngle = Angle.generateAngle()
    var listShotSize = ShotSize.generateShotSize()
    var listMovement = Movement.generateMovement()
    
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
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    //subscene placeholder
    var subScene:SubScene!
    
    //defaul textview text
    var placeHolder = "Enter your description here"
    
    //trigger
    var triggerBack:Bool!
    var triggerDone:Bool!
    var haveSaved:Bool!
    var anyDifference:Bool!
    
    //value placholder
    var descriptionText:String!
    var angle:String!
    var shotSize:String!
    var movement:String!
    var initStoryboardImage:UIImage!
    var rawImage:Data!
    var pencilKitData:Data!
    
    @objc func changeText(_ data: Notification){
        
        let arrayData = data.object as! [String]
        
        if(arrayData[1] == "Angle Type"){
            self.angleTypeSelector.setTitle("\(arrayData[0])", for: .normal)
        } else if(arrayData[1] == "Shot Type"){
            self.shotSizeSelector.setTitle("\(arrayData[0])", for: .normal)
        } else if(arrayData[1] == "Movement Type"){
            self.movementTypeSelector.setTitle("\(arrayData[0])", for: .normal)
        }

    }
    
    @objc func refetchSave() {
        
        listSave = coreData.getAllData(entity: Save.self)
        
    }
    
    @objc func saveSubScene() {
        
        var tempImage:Data!
        
        if (storyboardImage.image != nil){
            tempImage = storyboardImage.image?.pngData()
        } else {
            tempImage = nil
        }
        
        coreData.updateSubScene(subScene: subScene, description: descriptionEditor.text, angle: angleTypeSelector.title(for: .normal), shotSize: shotSizeSelector.title(for: .normal), movement: movementTypeSelector.title(for: .normal), storyboard: tempImage ,rawImage: rawImage, pencilKitData: pencilKitData)
        
    }
    
    //connect with pencil kit page
    @objc func changeImagePencil(_ data: Notification) {
        
        let arrayData = data.object as! passData
        
        storyboardImage.image = arrayData.thumbnail
        pencilKitData = arrayData.drawStroke.dataRepresentation()
        rawImage = arrayData.imagePlain.pngData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeText), name: Notification.Name("refresh"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refetchSave), name: Notification.Name("refreshSave"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeImagePencil), name: Notification.Name("updateImage"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveSubScene), name: Notification.Name("saveSubScene"), object: nil)
        
        initalSetup()
        // Do any additional setup after loading the view.
    }
    
    func initalSetup() {
        
        //Tampilan
        descriptionEditor.delegate = self
        
        descriptionEditor.layer.cornerRadius = 15
        descriptionEditor.layer.borderWidth = 1

        storyboardImage.layer.cornerRadius = 15
        storyboardImage.layer.borderWidth = 1
        storyboardImage.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        storyboardImage.clipsToBounds = true
        
        saveButton.layer.cornerRadius = 15
        
        let gestureRecog = UITapGestureRecognizer(target: self, action: #selector(goToDrawingPage(_:)))
        gestureRecog.numberOfTapsRequired = 1
        gestureRecog.numberOfTouchesRequired = 1
        
        storyboardImage.addGestureRecognizer(gestureRecog)
        storyboardImage.isUserInteractionEnabled = true
        
        //Keyboard setting for text Field
        self.descriptionEditor.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        //Save State Core Data
        listSave = coreData.getAllData(entity: Save.self)
        
        if (listSave.count == 0){
            coreData.createSaveState()
            coreData.createSaveState()
            listSave = coreData.getAllData(entity: Save.self)
        }
        
        haveSaved = false
        
        //Get SubScene
        listSubScene = coreData.getAllData(entity: SubScene.self)
        
        if (listSubScene.count != 0) {
            subScene = listSubScene[0]
        }
        
        //Move core data to local variable
        if (subScene != nil){
            
            self.title = "SubScene \(subScene.number).\(String(describing: subScene.subtoscene!.number))"
            descriptionText = subScene.sceneDescription ?? placeHolder
            angle = subScene.angle ?? "- Select -"
            shotSize = subScene.shotSize ?? "- Select -"
            movement = subScene.movement ?? "- Select -"
            
            pencilKitData = subScene.pencilKitData ?? Data()
            rawImage = subScene.rawImage ?? UIImage().pngData()
            
            if (subScene.storyboard != nil){
                initStoryboardImage = UIImage(data: subScene.storyboard!)
            } else {
                initStoryboardImage = nil
            }
        } else {
            
            self.title = "Test Edit Subscene"
            descriptionText = placeHolder
            angle = "- Select -"
            shotSize = "- Select -"
            movement = "- Select -"
            initStoryboardImage = nil
        }
        
        
        //Move local variable to frontend
        if (descriptionText == placeHolder) {
            descriptionEditor.text = placeHolder
            descriptionEditor.textColor = .lightGray
        } else {
            descriptionEditor.text = descriptionText
            descriptionEditor.textColor = .black
        }
        
        angleTypeSelector.setTitle(angle, for: .normal)
        shotSizeSelector.setTitle(shotSize, for: .normal)
        movementTypeSelector.setTitle(movement, for: .normal)
        
        if (initStoryboardImage != nil) {
            storyboardImage.image = initStoryboardImage
        }
        
    }
    
    @objc func goToDrawingPage(_ gesture: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "drawingSegue", sender: self)
    }
    
    @objc func tapDone(sender: Any) {
            self.view.endEditing(true)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let newVC = segue.destination as? EditModalTypeController

        let newVC2 = segue.destination as? EditSaveModalViewController
        
        let destVC = segue.destination as? DrawingPageViewController
        
        if (segue.identifier == "angleSegue"){
            newVC!.titleSegue = "Angle Type"
            newVC!.startingIndex = getAngleIndex()
        }
        if (segue.identifier == "shotSegue"){
            newVC!.titleSegue = "Shot Type"
            newVC!.startingIndex = getShotIndex()
        }
        if (segue.identifier == "movementSegue"){
            newVC!.titleSegue = "Movement Type"
            newVC!.startingIndex = getMovementIndex()
        }
        
        if (segue.identifier == "saveSegue"){
            newVC2!.segueSender = "saveButton"
            newVC2!.segueSave = listSave[0]
        }

        if (segue.identifier == "backSaveSegue"){
            newVC2!.segueSender = "backButton"
            newVC2!.segueSave = listSave[1]
        }
        
        if (segue.identifier == "saveOnlySegue"){
            newVC2!.segueSender = "saveOnlySegue"
            newVC2!.haveSavedSegue = haveSaved
            newVC2!.anyDifference = anyDifference
        }
        
        if(segue.identifier == "drawingSegue") {
            destVC?.drawing = pencilKitData
            destVC?.imagePlain = rawImage
            destVC?.screenType = 16
        }
    }
    
    func checkBackTrigger() -> Bool{
        var tempBool = false
        
        if (descriptionEditor.text != descriptionText){
            tempBool = true
            haveSaved = false
        }
        if (angleTypeSelector.title(for: .normal) != angle){
            tempBool = true
            haveSaved = false
        }
        if (shotSizeSelector.title(for: .normal) != shotSize){
            tempBool = true
            haveSaved = false
        }
        if (movementTypeSelector.title(for: .normal) != movement){
            tempBool = true
            haveSaved = false
        }
        if (storyboardImage.image != initStoryboardImage){
            tempBool = true
            haveSaved = false
        }
        
        return tempBool
    }
    
    func checkDoneTrigger() -> Bool{
        
        var tempBool = false
        
        if (descriptionEditor.text == placeHolder){
            tempBool = true
        }
        if (angleTypeSelector.title(for: .normal) == "- Select -"){
            tempBool = true
        }
        if (shotSizeSelector.title(for: .normal) == "- Select -"){
            tempBool = true
        }
        if (movementTypeSelector.title(for: .normal) == "- Select -"){
            tempBool = true
        }
        if (storyboardImage.image == nil){
            tempBool = true
        }
        
        return tempBool
    }
    
    func resetInitValue() {
        descriptionText = descriptionEditor.text
        angle = angleTypeSelector.title(for: .normal)
        shotSize = shotSizeSelector.title(for: .normal)
        movement = movementTypeSelector.title(for: .normal)
        initStoryboardImage = storyboardImage.image
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionEditor.textColor == .lightGray {
            descriptionEditor.text = ""
            descriptionEditor.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionEditor.text.isEmpty {
            descriptionEditor.text = placeHolder
            descriptionEditor.textColor = UIColor.lightGray
        }
    }
    
    func getAngleIndex() -> Int {
        
        var tempIndex = 0
        var tempFound = false
        
        for item in listAngle{
            if (item.name == angleTypeSelector.title(for: .normal)){
                tempFound = true
                break
            }
            tempIndex+=1
        }
        
        if tempFound == true {
            return tempIndex
        } else {
            return 99
        }
    }
    
    func getShotIndex() -> Int {
        
        var tempIndex = 0
        var tempFound = false
        
        for item in listShotSize{
            if (item.name == shotSizeSelector.title(for: .normal)){
                tempFound = true
                break
            }
            tempIndex+=1
        }
        
        if tempFound == true {
            return tempIndex
        } else {
            return 99
        }
    }
    
    func getMovementIndex() -> Int {
        
        var tempIndex = 0
        var tempFound = false
        
        for item in listMovement{
            if (item.name == movementTypeSelector.title(for: .normal)){
                tempFound = true
                break
            }
            tempIndex+=1
        }
        
        if tempFound == true {
            return tempIndex
        } else {
            return 99
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
           
        }
    
    @IBAction func goToPresentationPage(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        anyDifference = checkBackTrigger()
        
        if (haveSaved == false){
        if (listSave[0].state == true && checkDoneTrigger()){
    
        performSegue(withIdentifier: "saveSegue", sender: nil)
            
        } else{
            
            saveSubScene()
            resetInitValue()
            performSegue(withIdentifier: "saveOnlySegue", sender: nil)
            haveSaved = true
            
            }
        } else {
            
            performSegue(withIdentifier: "saveOnlySegue", sender: nil)
        }
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        if (listSave[1].state == true && checkBackTrigger()){
        performSegue(withIdentifier: "backSaveSegue", sender: nil)
        } else {
            print("Back button success")
        }
    }
    
    @IBAction func reDoTutorial(_ sender: UIBarButtonItem) {
        
    }
    
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


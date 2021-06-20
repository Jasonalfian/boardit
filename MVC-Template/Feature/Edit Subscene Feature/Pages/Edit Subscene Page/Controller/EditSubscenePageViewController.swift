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
    
    var subSceneNumber:Int!
    var SceneNumber : Int!
    
    var isFirst = true
    
    var overlay: UIView?
    var popOver: UIViewController?
    
    @objc func changeText(_ data: Notification){
        
        let arrayData = data.object as! [String]
        
        if(arrayData[1] == "Angle Type"){
            self.angleTypeSelector.setTitle("\(arrayData[0])", for: .normal)
            
            if UserDefaults.standard.bool(forKey: "isTutorial") && UserDefaults.standard.integer(forKey: "tutorialStep") == 7 {
                displayTutorial(element: shotSizeSelector, text: Tutorial.getTutorialDataByID(id: 7)!.description, step: "7/17", direction: .up)
                UserDefaults.standard.setValue(8, forKey: "tutorialStep")
            }
        } else if(arrayData[1] == "Shot Type"){
            self.shotSizeSelector.setTitle("\(arrayData[0])", for: .normal)
            
            if UserDefaults.standard.bool(forKey: "isTutorial") && UserDefaults.standard.integer(forKey: "tutorialStep") == 9 {
                displayTutorial(element: movementTypeSelector, text: Tutorial.getTutorialDataByID(id: 9)!.description, step: "9/17", direction: .up)
                UserDefaults.standard.setValue(10, forKey: "tutorialStep")
            }
        } else if(arrayData[1] == "Movement Type"){
            self.movementTypeSelector.setTitle("\(arrayData[0])", for: .normal)
            
            if UserDefaults.standard.bool(forKey: "isTutorial") && UserDefaults.standard.integer(forKey: "tutorialStep") == 11 {
                displayTutorial(element: storyboardImage, text: Tutorial.getTutorialDataByID(id: 11)!.description, step: "11/17", direction: .down)
                UserDefaults.standard.setValue(12, forKey: "tutorialStep")
            }
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
        
        initStoryboardImage = arrayData.thumbnail
        pencilKitData = arrayData.drawStroke.dataRepresentation()
        rawImage = arrayData.imagePlain.pngData()
        
        storyboardImage.image = arrayData.thumbnail
        descriptionEditor.text = arrayData.descriptionText
        angleTypeSelector.setTitle(arrayData.angleSelected, for: .normal)
        shotSizeSelector.setTitle(arrayData.shotSizeSelected, for: .normal)
        movementTypeSelector.setTitle(arrayData.movementTypeSelected, for: .normal)
        
        isFirst = false
    }
    
    @objc func backMainPage() {
        print("masuk close")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func resetSaveTrigger() {
        resetInitValue()
        haveSaved = true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeText), name: Notification.Name("refresh"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refetchSave), name: Notification.Name("refreshSave"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeImagePencil), name: Notification.Name("updateImage"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveSubScene), name: Notification.Name("saveSubScene"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(backMainPage), name: Notification.Name("backMainPage"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(resetSaveTrigger), name: Notification.Name("resetSaveTrigger"), object: nil)
        
        initalSetup()
        if UserDefaults.standard.bool(forKey: "isTutorial") {
            if UserDefaults.standard.integer(forKey: "tutorialStep") == 4 {
                displayTutorial(element: descriptionEditor, text: Tutorial.getTutorialDataByID(id: 4)!.description, step: "4/17", direction: .up)
                UserDefaults.standard.setValue(5, forKey: "tutorialStep")
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func displayTutorial(element: UIView, text: String, step: String, direction: UIPopoverArrowDirection, isInsideModal: Bool = false) {
        if let ov = overlay {
            ov.isHidden = true
        }
        overlay = Tutorial.createOverlay(view: view, elementToShow: element)
        overlay!.isHidden = false
        popOver = Tutorial.createPopOver(tutorialText: text, step: step, elementToPoint: element, direction: direction, isInsideModal: isInsideModal, hasSidebar: false)
        self.present(popOver!, animated: true)
    }
    
    func fifteenthTutorial() {
        if UserDefaults.standard.integer(forKey: "tutorialStep") == 15 {
            let popOver3 = PopOverViewController()
            popOver3.tutorialText = Tutorial.getTutorialDataByID(id: 15)!.description
            popOver3.tutorialSteps = "15/17"
            popOver3.isInsideModal = false
            popOver3.hasSidebar = true
            popOver3.modalPresentationStyle = .popover
            popOver3.popoverPresentationController?.permittedArrowDirections = .up
            popOver3.popoverPresentationController?.barButtonItem = redoTutorial
            popOver3.onDismiss = { result in
                self.displayTutorial(element: self.saveButton, text: Tutorial.getTutorialDataByID(id: 16)!.description, step: "16/17", direction: .down)
                UserDefaults.standard.setValue(17, forKey: "tutorialStep")
            }
            self.present(popOver3, animated: true)
            UserDefaults.standard.setValue(16, forKey: "tutorialStep")
        }
        else if UserDefaults.standard.integer(forKey: "tutorialStep") == 17 {
            let popOver3 = PopOverViewController()
            popOver3.tutorialText = Tutorial.getTutorialDataByID(id: 17)!.description
            popOver3.tutorialSteps = "17/17"
            popOver3.isInsideModal = false
            popOver3.hasSidebar = true
            popOver3.modalPresentationStyle = .popover
            popOver3.popoverPresentationController?.permittedArrowDirections = .up
            popOver3.popoverPresentationController?.barButtonItem = backButton
            self.present(popOver3, animated: true)
            UserDefaults.standard.setValue(18, forKey: "tutorialStep")
        }
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
//
        if (subScene == nil) {
            subScene = listSubScene[0]
        }
        
        //Move core data to local variable
        if (subScene != nil){
            
            self.title = "SubScene \(String(describing: subScene.subtoscene!.number)).\(String(describing: subSceneNumber! + 1))"
            
//            Ga dijalanin pas masuk halaman edit subcene dari drawing page
            if isFirst == true {
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
        
        let drawNavCon = segue.destination as? UINavigationController
        let destVC = drawNavCon?.viewControllers.first as? DrawingPageViewController
        
        if let ov = overlay {
            ov.isHidden = true
        }
        
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
            newVC2!.parentVC = self
        }

        if (segue.identifier == "backSaveSegue"){
            newVC2!.segueSender = "backButton"
            newVC2!.segueSave = listSave[1]
        }
        
        if (segue.identifier == "saveOnlySegue"){
            newVC2!.segueSender = "saveOnlySegue"
            newVC2!.haveSavedSegue = haveSaved
            newVC2!.anyDifference = anyDifference
            newVC2!.parentVC = self
        }
        
        if (segue.identifier == "drawingSegue") {
            
            destVC?.descriptionEditorText = descriptionEditor.text
            destVC?.angleSelected = angleTypeSelector.title(for: .normal)
            destVC?.shotSizeSelected = shotSizeSelector.title(for: .normal)
            destVC?.movementSelected = movementTypeSelector.title(for: .normal)
            
            destVC?.drawing = pencilKitData
            destVC?.imagePlain = rawImage
            destVC?.usedTitle = self.title!
            destVC?.parentController = self
            
            if subScene != nil {
                destVC?.screenType = Int(subScene.subtoscene!.scenetoproject!.ratio)
            } else {
                destVC?.screenType = 16
            }
            
            if initStoryboardImage != nil {
                destVC?.imagePlain = initStoryboardImage.pngData()
            } else {
                
            }
        }
        if(segue.identifier == "presentationSegue"){
            
            let destinationVC = segue.destination as! UINavigationController
            if let presentVC = destinationVC.viewControllers[0] as? PresentationPageViewController {
                presentVC.indexScene = SceneNumber //SceneNumber
                presentVC.indexSubscene = subSceneNumber //subSceneNumber
                presentVC.currentProjectZ = subScene.subtoscene?.scenetoproject
                presentVC.projectTitlePassingBro = subScene.subtoscene?.scenetoproject?.name
            }
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
        
        if UserDefaults.standard.bool(forKey: "isTutorial") && UserDefaults.standard.integer(forKey: "tutorialStep") == 5 {
            if !descriptionEditor.text.isEmpty && descriptionEditor.text != placeHolder {
                if let ov = overlay {
                    ov.isHidden = true
                }
                displayTutorial(element: angleTypeSelector, text: Tutorial.getTutorialDataByID(id: 5)!.description, step: "5/17", direction: .up)
                UserDefaults.standard.setValue(6, forKey: "tutorialStep")
            }
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
        self.performSegue(withIdentifier: "presentationSegue", sender: self)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        anyDifference = checkBackTrigger()
        
        if (haveSaved == false){
        if (listSave[0].state == true && checkDoneTrigger()){
    
        performSegue(withIdentifier: "saveSegue", sender: nil)
            
        } else{
            
            saveSubScene()
            coreData.updateProject(project: subScene.subtoscene!.scenetoproject, modifiedDate: Date())
            resetInitValue()
            performSegue(withIdentifier: "saveOnlySegue", sender: nil)
            haveSaved = true
            
            }
        } else {
            
            performSegue(withIdentifier: "saveOnlySegue", sender: nil)
        }
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        if (haveSaved == false){
            if(checkBackTrigger() == false){
                backMainPage()
            } else {
                performSegue(withIdentifier: "backSaveSegue", sender: nil)
            }
        } else {
            print("Back button success")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadFromProject"), object: subScene.subtoscene?.scenetoproject)
            self.navigationController?.popViewController(animated: true)
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


//
//  DrawingPageViewController.swift
//  BoardIt
//
//  Created by Gilbert Nicholas on 08/06/21.
//

import UIKit
import PencilKit
import PhotosUI

class DrawingPageViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver {

    var core = CoreDataManager()
    
    @IBOutlet weak var canvasView: PKCanvasView!
    @IBOutlet weak var uploadedImageView: UIImageView!

    @IBOutlet weak var leftConst: NSLayoutConstraint!
    @IBOutlet weak var botConst: NSLayoutConstraint!
    @IBOutlet weak var rightConst: NSLayoutConstraint!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!

    let toolPicker: PKToolPicker! = PKToolPicker()
    
    var drawing: Data!
    var imagePlain: Data!
    var screenType: Int!
    var usedTitle: String!
    
    var descriptionEditorText: String!
    var angleSelected: String!
    var shotSizeSelected: String!
    var movementSelected: String!
    
    var dataModelController: CoreDataManager!
    
    var hasModifiedDrawing = false
    
    var thumbnailImage: UIImage!
    
    var popOver: UIViewController?
    var overlay: UIView?
    
    var parentController: EditSubscenePageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = usedTitle
        setCanvas()
        setPicker()
        
        firstTutorial()
    }
    
    func displayOverlay(element: UIView) {
        if let ov = overlay {
            ov.isHidden = true
        }
        overlay = Tutorial.createOverlay(view: view, elementToShow: element)
        overlay!.isHidden = false
    }
    
    func firstTutorial() {
        let popOverVC = PopOverViewController()
        popOverVC.tutorialText = Tutorial.getTutorialDataByID(id: 12)!.description
        popOverVC.tutorialSteps = "12/17"
        popOverVC.isInsideModal = false
        popOverVC.hasSidebar = true
        popOverVC.onDismiss = { result in
            
            self.displayOverlay(element: self.canvasView)
            self.popOver = Tutorial.createPopOver(tutorialText: Tutorial.getTutorialDataByID(id: 13)!.description, step: "13/17", elementToPoint: self.canvasView, direction: .left, isInsideModal: false, hasSidebar: false, onDismiss: { result in
                if let ov = self.overlay {
                    ov.isHidden = true
                }
                let popOver3 = PopOverViewController()
                popOver3.tutorialText = Tutorial.getTutorialDataByID(id: 14)!.description
                popOver3.tutorialSteps = "14/17"
                popOver3.isInsideModal = false
                popOver3.hasSidebar = false
                popOver3.modalPresentationStyle = .popover
                popOver3.popoverPresentationController?.permittedArrowDirections = .up
                popOver3.popoverPresentationController?.barButtonItem = self.saveButton
                self.present(popOver3, animated: true)
                UserDefaults.standard.setValue(15, forKey: "tutorialStep")
            })
            self.present(self.popOver!, animated: true)
            UserDefaults.standard.setValue(14, forKey: "tutorialStep")
        }
        popOverVC.modalPresentationStyle = .formSheet
        
        self.present(popOverVC, animated: true)
        UserDefaults.standard.setValue(13, forKey: "tutorialSetp")
    }
    
    func setCanvas() {
        canvasView.delegate = self
        
        if screenType == 16 {
            leftConst.constant = 70
            rightConst.constant = -70
            topConst.constant = 50
            botConst.constant = 110

        } else if screenType == 4 {
            leftConst.constant = 150
            rightConst.constant = -150
            topConst.constant = 40
            botConst.constant = 60
            
        } else if screenType == 1 {
            leftConst.constant = 220
            rightConst.constant = -220
            topConst.constant = 40
            botConst.constant = 60
        }
        
//        Catch the data from edit page into drawing page
        do {
            canvasView.drawing = try PKDrawing(data: drawing ?? Data())
        } catch {
            print("Your Drawing could not be found")
        }
        
//        Uploaded Background image
        if UserDefaults.standard.bool(forKey: "isTutorial") {
            uploadedImageView.image = UIImage(named: "tutorialDrawing")
        } else {
            uploadedImageView.image = UIImage(data: imagePlain ?? Data())
        }
        
        uploadedImageView.frame = canvasView.bounds
        uploadedImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        uploadedImageView.clipsToBounds = true
        
        canvasView.addSubview(uploadedImageView)
        canvasView.sendSubviewToBack(uploadedImageView)
        
        canvasView.backgroundColor = .clear
        canvasView.layer.borderWidth = 3
        canvasView.layer.cornerRadius = 12
        canvasView.drawingPolicy = .anyInput
        
        canvasView.alwaysBounceVertical = false
    }
    
    func setPicker() {
        toolPicker.addObserver(canvasView)
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        
        canvasView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

        NotificationCenter.default.post(name: Notification.Name("updateImage"), object: passData(thumb: thumbnailImage, image: uploadedImageView.image ?? UIImage(), stroke: canvasView.drawing, description: descriptionEditorText, angle: angleSelected, shotSize: shotSizeSelected, movementType: movementSelected))
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        hasModifiedDrawing = true
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        generateThumbnail()

        self.dismiss(animated: true) {
            if UserDefaults.standard.integer(forKey: "tutorialStep") == 15 {
                self.parentController!.fifteenthTutorial()
            }
        }
    }
    
    @IBAction func clearCanvasButtonTapped(_ sender: UIBarButtonItem) {
        canvasView.drawing = PKDrawing()
        uploadedImageView.image = nil
    }
    
    @IBAction func captureCanvasButtonTapped(_ sender: UIBarButtonItem) {
        setImagePicker(1)
    }
    
    func generateThumbnail() {
        UIGraphicsBeginImageContextWithOptions(canvasView.bounds.size, false, UIScreen.main.scale)
        
        canvasView.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if image != nil {
            thumbnailImage = image
        }
    }
    
    @IBAction func uploadCanvasButtonTapped(_ sender: UIBarButtonItem) {
        setImagePicker(2)
    }
    
    func setImagePicker(_ typePicker: Int) {
        let picker = UIImagePickerController()
        
        if typePicker == 1 {
            picker.sourceType = .camera
        } else if typePicker == 2 {
            picker.sourceType = .photoLibrary
        }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

}

extension DrawingPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        uploadedImageView.image = image

        uploadedImageView.frame = canvasView.bounds
        uploadedImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        uploadedImageView.clipsToBounds = true
        canvasView.addSubview(uploadedImageView)
        canvasView.sendSubviewToBack(uploadedImageView)
        
        picker.dismiss(animated: true, completion: nil)
    }
}

struct passData {
    var thumbnail: UIImage?
    var imagePlain: UIImage
    var drawStroke: PKDrawing
    var descriptionText: String
    var angleSelected: String
    var shotSizeSelected: String
    var movementTypeSelected: String
    
    init(thumb: UIImage?, image: UIImage, stroke: PKDrawing, description: String, angle: String, shotSize: String, movementType: String) {
        self.thumbnail = thumb
        self.imagePlain = image
        self.drawStroke = stroke
        self.descriptionText = description
        self.angleSelected = angle
        self.shotSizeSelected = shotSize
        self.movementTypeSelected = movementType
    }
}

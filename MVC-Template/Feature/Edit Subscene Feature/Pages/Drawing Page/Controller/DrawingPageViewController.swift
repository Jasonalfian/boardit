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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = usedTitle
        setCanvas()
        setPicker()
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
        
//        convert from DATA type
        do {
            canvasView.drawing = try PKDrawing(data: drawing ?? Data())
        } catch {
            print("Your Drawing could not be found")
        }
        
        uploadedImageView.image = UIImage(data: imagePlain ?? Data())
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
        
//        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
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
//        let contentView = canvasView.subviews[0]
//            contentView.addSubview(uploadedImageView)
//            contentView.sendSubviewToBack(uploadedImageView)
        
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

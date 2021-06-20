//
//  Tutorial.swift
//  BoardIt
//
//  Created by Farrel Anshary on 15/06/21.
//

import Foundation
import UIKit

class Tutorial {
    static func createOverlay(view: UIView, elementToShow: UIView) -> UIView {
        let overlayView = UIView(frame: view.frame)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        UIView.transition(with: view, duration: 0.2, options: [.transitionCrossDissolve], animations: {
            view.addSubview(overlayView)
        }, completion: nil)
        view.bringSubviewToFront(elementToShow)
        
        return overlayView
    }
    
    static func createPopOver(tutorialText: String, step: String?, elementToPoint: UIView, direction: UIPopoverArrowDirection, isInsideModal: Bool, hasSidebar: Bool, onDismiss: ((Bool) -> Void)? = nil) -> UIViewController {
        let popOverVC = PopOverViewController()
        popOverVC.tutorialText = tutorialText
        popOverVC.tutorialSteps = step
        popOverVC.isInsideModal = isInsideModal
        popOverVC.hasSidebar = hasSidebar
        popOverVC.modalPresentationStyle = .popover
        popOverVC.onDismiss = onDismiss
        
        let presentationController = popOverVC.popoverPresentationController!
        presentationController.sourceView = elementToPoint
        presentationController.permittedArrowDirections = direction
        
        return popOverVC
    }
    
    static func getAllTutorialData() -> [TutorialDataModel] {
        return tutorialData
    }
    
    static func getTutorialDataByID(id: Int) -> TutorialDataModel? {
        var tempData: TutorialDataModel?
        
        for tutorial in tutorialData {
            if tutorial.id == id {
                tempData = tutorial
                break
            }
        }
        return tempData ?? nil
    }
    
    static var tutorialData = [
        TutorialDataModel(id: 0, description: "Hey, welcome to Board It! We would like to walk you through this app.\n\nPress anywhere to continue"),
        TutorialDataModel(id: 1, description: "Great! we will teach you how to make the perfect storyboard.\n\nBut before that, let's add a new project first by pressing this button."),
        TutorialDataModel(id: 2, description: "You can name your project and choose the aspect ratio for your project.\n\nAfter those things are filled, press the \"Create New Project\" button."),
        TutorialDataModel(id: 3, description: "Woohoo! You created your first project.\n\nTo create a storyboard for a scene, press the \"Add Subscene\" button."),
        TutorialDataModel(id: 4, description: "This is where you write down a situation for a scene.\n\nTry to tap the description box and describe a situation you want to make."),
        TutorialDataModel(id: 5, description: "After describing the scene, pick which shot angle you want to choose for your scene by pressing this button"),
        TutorialDataModel(id: 6, description: "In this menu, you can read through the shot angle information and then you can pick an angle for your scene.\n\nTake your time to read and understand the different types of it! After you choose an angle to use, don't forget to tap the \"Select\" button below."),
        TutorialDataModel(id: 7, description: "Pick a framing of your shot. Press this button to pick which framing size you would like to use."),
        TutorialDataModel(id: 8, description: "In this menu, you can read through the shot size information and then you can pick a size for your scene.\n\nTake your time to read and understand the different types of it! After you choose a size to use, don't forget to tap the \"Select\" button below."),
        TutorialDataModel(id: 9, description: "Pick a movement for your shot. Press this button to pick which shot movement you would like to use"),
        TutorialDataModel(id: 10, description: "In this menu, you can read through the shot movement information and then you can pick a movement for your scene.\n\nTake your time to read and understand the different types of it! After you choose a movement to use, don't forget to tap the \"Select\" button below."),
        TutorialDataModel(id: 11, description: "Here you can visualize your storyboard based on things you filled before!\n\nTap this board to visualize your storyboard."),
        TutorialDataModel(id: 12, description: "Voila! Welcome to the storyboard drawing tool of Board It!\n\nHere you can draw, select an image from your gallery, and even capture a photo to be your storyboard!"),
        TutorialDataModel(id: 13, description: "To make it quick we provide you with a drawing."),
        TutorialDataModel(id: 14, description: "Tap the \"Save\" button to go back and see the whole scene!"),
        TutorialDataModel(id: 15, description: "You can read the instructions if you ever need it again."),
        TutorialDataModel(id: 16, description: "Congrats! You've made your first storyboard!\n\nPress this button to save your creation."),
        TutorialDataModel(id: 17, description: "After changes saved, you can press this button to go back to main menu"),
        TutorialDataModel(id: 18, description: "Here you can add more sub-scenes, add new scenes, and edit the things you've made!\n\nSo that's all for the tutorial! Go create more amazing storyboards!"),
    ]
}

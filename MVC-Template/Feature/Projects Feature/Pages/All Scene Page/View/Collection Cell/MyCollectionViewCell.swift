//
//  MyCollectionViewCell.swift
//  BoardIt
//
//  Created by Nicholas Kusuma on 12/06/21.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell, TableObserver {
    
    var observerController: ObserverController!
    var modeStatus: Bool!
    
    @IBOutlet var myDesc: UILabel!
    @IBOutlet var myShotSize: UILabel!
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet weak var BaseView: UIView!
    @IBOutlet weak var BaseHitam: UIView!
    @IBOutlet var myShotAngle: UILabel!
    @IBOutlet var myMovement: UILabel!
    @IBOutlet weak var addNewSubscene: UIView!
    @IBOutlet weak var goToEditScene: UIButton!
    @IBOutlet weak var newSubscene: UIButton!
    
    @IBOutlet weak var highlightIndicator: UIView!
    
    @IBOutlet weak var selectIndicator: UIImageView!
    
    override var isHighlighted: Bool {
        didSet {
            highlightIndicator.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet {
            highlightIndicator.isHidden = !isSelected
            selectIndicator.isHidden = !isSelected
        }
    }
    
    func setObserver() {
        observerController.tableObservers.append(self)
    }
    
    func changeMultipleSelectStatus(status: Bool) {
        modeStatus = status
        if modeStatus == false {
            goToEditScene.isEnabled = true
            newSubscene.isEnabled = true
//            isHighlighted = false
        } else if modeStatus == true {
//            isHighlighted = true
            goToEditScene.isEnabled = false
            newSubscene.isEnabled = false
        }
    }
    
    var navigationController: UINavigationController?
    var sceneNumber:Int!
    
    var hideController: Bool!
    var defaultImage = #imageLiteral(resourceName: "empty Image")
    var scene: Scene!
    var subScene: SubScene?
    
    var coreData = CoreDataManager()
    var listSubScene:[SubScene]!
    
    static let identifier = "MyCollectionViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        BaseView.layer.borderWidth = 1
//        BaseView.layer.borderColor = #colorLiteral(red: 0.1930259168, green: 0.1930313706, blue: 0.19302845, alpha: 1)
        
        BaseView.layer.cornerRadius = 30
        BaseHitam.layer.cornerRadius = 30
        BaseHitam.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        addNewSubscene.isHidden = true
        addNewSubscene.layer.cornerRadius = 30
    }
    
    func didDeleteTapped() {
        //
    }

    public func configure(with model: Model) {
        
        
        if (model.desc == "Enter your description here"){
            self.myDesc.text = "-"
        } else {
            self.myDesc.text = model.desc
        }
        
        if (model.angle == "- Select -"){
            self.myShotAngle.text = "-"
        } else {
            self.myShotAngle.text = model.angle
        }
        
        if (model.size == "- Select -"){
            self.myShotAngle.text = "-"
        } else {
            self.myShotSize.text = model.size
        }
        
        if (model.movement == "- Select -"){
            self.myMovement.text = "-"
        } else {
            self.myMovement.text = model.movement
        }
        
        self.myImageView.image = UIImage(data: ((model.imageName ?? defaultImage.pngData())!))
        self.hideController = model.addNew
        
//        if self.hideController == true {
            addNewSubscene.isHidden = !self.hideController
//        }
        
        self.scene = model.scene
        self.subScene = model.subScene
    
    }
    
    func prepareScreen(navController: UINavigationController)-> UIView {
        navigationController = navController
        let nibView = Bundle.main.loadNibNamed("MyCollectionViewCell", owner: self, options: nil)?[0] as! UIView
        self.addSubview(nibView)
        return nibView
    }
    
    @IBAction func goToEditScene(_ sender: UIButton) {
        let editSubSceneStoryboard = UIStoryboard(name: "EditSubcenePage", bundle: nil)
        let editPage = editSubSceneStoryboard.instantiateViewController(withIdentifier: "EditSubscenePageViewController") as! EditSubscenePageViewController

//        editPage.subScene = self.subScene
        editPage.subScene = subScene
        editPage.sceneNumber = sceneNumber
        
        if let splitView = navigationController?.parent as? UISplitViewController {
            UIView.animate(withDuration: 0.3, animations: {
                splitView.preferredDisplayMode = .primaryHidden
                    }, completion: nil)
        }

        self.navigationController?.pushViewController(editPage, animated: true)
    }
    
    @IBAction func addNewSubScene(_ sender: UIButton) {
        
        let editSubSceneStoryboard = UIStoryboard(name: "EditSubcenePage", bundle: nil)
        let editPage = editSubSceneStoryboard.instantiateViewController(withIdentifier: "EditSubscenePageViewController") as! EditSubscenePageViewController
        
//        let navController = UINavigationController(rootViewController: editPage)
//        window?.rootViewController = navController
        
        editPage.sceneNumber = sceneNumber
        
        //create new subscene
        coreData.createSubScene(scene: self.scene)
        listSubScene = coreData.getAllSubScene(scene: self.scene)
        self.subScene = listSubScene.last
        editPage.subScene = self.subScene
        
        if let splitView = navigationController?.parent as? UISplitViewController {
            UIView.animate(withDuration: 0.3, animations: {
                splitView.preferredDisplayMode = .primaryHidden
                    }, completion: nil)
        }
        
//      self.navigationController?.present(navController, animated: true)
        self.navigationController?.pushViewController(editPage, animated: true)
    }
    
}

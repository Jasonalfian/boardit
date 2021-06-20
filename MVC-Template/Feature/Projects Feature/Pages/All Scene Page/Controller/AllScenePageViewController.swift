//
//  AllScenePageViewController.swift
//  BoardIt
//
//  Created by Gilbert Nicholas on 08/06/21.
//

import UIKit

class AllScenePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CollectionObserver {
   
    @IBOutlet weak var filterBarButton: UIBarButtonItem!
    @IBOutlet weak var presentationBarButton: UIBarButtonItem!
    @IBOutlet weak var addNewScene: UIButton!
   
    var aspectRatio = 0
    var coreData = CoreDataManager()
    var listProject:[Project] = []
    var listScene:[Scene] = []
    var listSubScene:[SubScene] = []
    var model1 = [Model]()
    var models = [[Model]]()
    var currentProject: Project!
    
    var modelCore1 = [SubScene]()
    var modelCore2 = [[SubScene]]()
    var modelCore3 = [[SubScene]]()
    var observerController = ObserverController()
    
    var myCollectionView = MyCollectionViewCell()
    
    var firstCell: CollectionTableViewCell?
    
    @IBOutlet var table: UITableView!
    
    enum Mode {
        case view
        case select
    }
    
    var mMode: Mode = .view {
        didSet {
            switch mMode {
            case .view:
                selectBarButton.title = "Select"
                navigationItem.leftBarButtonItem = nil
                
                for item in observerController.tableObservers {
                    item.changeMultipleSelectStatus(status: false)
                }
            case .select:
                selectBarButton.title = "Cancel"
                navigationItem.leftBarButtonItem = deleteBarButton
                
                for item in observerController.tableObservers {
                    item.changeMultipleSelectStatus(status: true)
                }
            }
        }
    }
    
    lazy var selectBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(didSelectButtonClicked(_:)))
        return barButtonItem
    }()
    
    lazy var deleteBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didDeleteButtonClicked(_:)))
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listProject = coreData.getAllData(entity: Project.self)
        print("jumlah data project",listProject.count)
                
        table.register(CollectionTableViewCell.nib(), forCellReuseIdentifier: CollectionTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        
        currentProject = listProject[0]
        listScene = coreData.getAllProjectScene(project: currentProject)
        addNewScene.layer.borderWidth = 1
        addNewScene.layer.cornerRadius = 30
        addNewScene.setTitle("+ Add Scene", for: .normal)

        fetchDataLocal(project: currentProject)
        setupBarButton()
        
        observerController.collObservers.append(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name("loadFromProject"), object: nil)
    }
    
    func didChange() {
        fetchDataLocal(project: currentProject)
    }
    
    func setupBarButton() {
        self.navigationItem.rightBarButtonItems = [presentationBarButton, filterBarButton, selectBarButton]
    }
    
    @IBAction func didPresentationButtonClicked(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func didFilterButtonClicked(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func didSelectButtonClicked(_ sender: UIBarButtonItem) {
        mMode = mMode == .view ? .select : .view
    }
    
    @objc func didDeleteButtonClicked(_ sender: UIBarButtonItem) {
        for item in observerController.tableObservers {
            item.didDeleteTapped()
        }
    }
    
    @objc func fetchData(_ data: Notification) {
        
        var selectedProject:Project
        
        selectedProject = data.object as! Project
        currentProject = selectedProject
        fetchDataLocal(project: selectedProject)
       
    }
    
    func fetchDataLocal(project: Project) {
        
        models.removeAll()
        listScene = coreData.getAllProjectScene(project: project)
        
        for item in listScene {
            
            listSubScene = coreData.getAllSubScene(scene: item)
            
            print("scene no: \(item.number)")
            print("Jumlah subscene: \(listSubScene.count)")
            
            for item in listSubScene{
                
                print("subscene number \(item.number)")
                model1.append(Model(desc: item.sceneDescription ?? "-", size: item.shotSize ?? "-" , angle: item.angle ?? "-", movement: item.movement ?? "-", imageName: item.storyboard , scene: item.subtoscene, addNew: false, subScene: item))
                
                modelCore1.append(item)
            }
            
            model1.append(Model(scene: item, addNew: true))
            
            models.append(model1)
            modelCore2.append(modelCore1)
            
            modelCore1.removeAll()
            model1.removeAll()

            
        }
        
        modelCore3 = modelCore2
        modelCore2.removeAll()
        
        table.reloadData()
        
        if UserDefaults.standard.bool(forKey: "isTutorial") && UserDefaults.standard.integer(forKey: "tutorialStep") == 18 {
            let popOverVC = PopOverViewController()
            popOverVC.tutorialText = Tutorial.getTutorialDataByID(id: 18)!.description
            popOverVC.isInsideModal = false
            popOverVC.hasSidebar = true
            popOverVC.onDismiss = { result in
                UserDefaults.standard.setValue(false, forKey: "isTutorial")
            }
            popOverVC.modalPresentationStyle = .formSheet
            
            self.present(popOverVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as! CollectionTableViewCell
    
        cell.textLabel?.text = "      Scene \(indexPath.row+1)"
        cell.textLabel?.font = UIFont(name: "Poppins-SemiBold", size: 20)
        cell.textLabel?.textAlignment = .left
        cell.navigationController = self.navigationController
        cell.observerController = self.observerController
        cell.sceneNum = indexPath.row
        cell.modelCore = modelCore3[indexPath.row]
        cell.coreData = self.coreData
        
//        // Define attributes
//        let labelFont = UIFont(name: "Poppins-Bold", size: 18)
//        let attributes :Dictionary = [NSAttributedString.Key.font : labelFont]
//
//        // Create attributed string
//        var attrString = NSAttributedString(string: "Foo", attributes:attributes as [NSAttributedString.Key : Any])
//
//        cell.textLabel?.attributedText = attrString
        
        cell.configure(with: models[indexPath.row])
        if indexPath.row == 0 {
            self.firstCell = cell
        }
    return cell
        
    }
        
    @IBAction func addNewScene(_ sender: UIButton) {
        coreData.createScene(project: currentProject)
        fetchDataLocal(project: currentProject)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listScene.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == listScene.count - 1 && UserDefaults.standard.bool(forKey: "isTutorial") && UserDefaults.standard.integer(forKey: "tutorialStep") == 3 {
            loadTutorial(element: firstCell!)
            UserDefaults.standard.setValue(4, forKey: "tutorialStep")
        }
    }
    
//    @objc private func didTapButton() {
//        let splitVC = UISplitViewController(style: .doubleColumn)
//
//        splitVC.viewControllers = []
//
//        present(splitVC, animated: true)
//    }
    
    func loadTutorial(element: UIView) {
        let popOver = Tutorial.createPopOver(tutorialText: Tutorial.getTutorialDataByID(id: 3)!.description, step: "3/17", elementToPoint: element, direction: .right, isInsideModal: false, hasSidebar: true)
        self.present(popOver, animated: true)
    }
    
}

struct Model {
    let desc: String?
    let size: String?
    let angle: String?
    let movement: String?
    
    let imageName: Data?
    let addNew: Bool!
    let scene: Scene?
    let subScene: SubScene?
    
    init(desc: String? = nil, size: String? = nil, angle: String? = nil, movement: String? = nil, imageName: Data? = nil, scene: Scene? = nil, addNew: Bool, subScene: SubScene? = nil) {
        
        self.desc = desc
        self.size = size
        self.angle = angle
        self.movement = movement
        self.imageName = imageName
        self.addNew = addNew
        self.scene = scene
        self.subScene = subScene
    }
    
    
}




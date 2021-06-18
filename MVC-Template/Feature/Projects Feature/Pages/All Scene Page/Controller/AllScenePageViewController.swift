//
//  AllScenePageViewController.swift
//  BoardIt
//
//  Created by Gilbert Nicholas on 08/06/21.
//

import UIKit

class AllScenePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
   
    @IBOutlet weak var addNewScene: UIButton!
   
    var aspectRatio = 0
    var coreData = CoreDataManager()
    var listProject:[Project] = []
    var listScene:[Scene] = []
    var listSubScene:[SubScene] = []
    var model1 = [Model]()
    var models = [[Model]]()
    var currentProject: Project!
    
    var myCollectionView = MyCollectionViewCell()
    
    @IBOutlet var table: UITableView!
//    @IBAction func sideBar(_ sender: Any) {
//
//    didTapButton()
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listProject = coreData.getAllData(entity: Project.self)
        print("jumlah data project",listProject.count)
                
        table.register(CollectionTableViewCell.nib(), forCellReuseIdentifier: CollectionTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        
//        coreData.createScene(project: listProject[0])
        
        currentProject = listProject[0]
        listScene = coreData.getAllProjectScene(project: currentProject)
        addNewScene.layer.borderWidth = 1
        addNewScene.layer.cornerRadius = 30
        addNewScene.setTitle("+ Add Scene", for: .normal)
//        coreData.createSubScene(scene: listScene[0], description: "Ayam Bakar 2", angle: "Eye Level", shotSize: "Long Shot", movement: "Push In", storyboard: UIImage().pngData())
        
        fetchDataLocal(project: currentProject)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name("loadFromProject"), object: nil)
        
        
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
            }
            
            model1.append(Model(scene: item, addNew: true))
            
            models.append(model1)
            
            model1.removeAll()
            
        }
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as! CollectionTableViewCell
    
        cell.textLabel?.text = "      Scene \(indexPath.row+1)"
        cell.textLabel?.font = UIFont(name: "Poppins-SemiBold", size: 20)
        cell.textLabel?.textAlignment = .left
        cell.navigationController = self.navigationController
        
        
//        // Define attributes
//        let labelFont = UIFont(name: "Poppins-Bold", size: 18)
//        let attributes :Dictionary = [NSAttributedString.Key.font : labelFont]
//
//        // Create attributed string
//        var attrString = NSAttributedString(string: "Foo", attributes:attributes as [NSAttributedString.Key : Any])
//
//        cell.textLabel?.attributedText = attrString
        
        cell.configure(with: models[indexPath.row])
        
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
    
//    @objc private func didTapButton() {
//        let splitVC = UISplitViewController(style: .doubleColumn)
//
//        splitVC.viewControllers = []
//
//        present(splitVC, animated: true)
//    }
    
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




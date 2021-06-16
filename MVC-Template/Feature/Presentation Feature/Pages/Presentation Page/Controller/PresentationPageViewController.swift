import UIKit
import SideMenu

class PresentationPageViewController: UIViewController, SceneListControllerDelegate {

    var sceneMenu : SideMenuNavigationController?
    
    var projectTitlePassingBro : String?
    @IBOutlet weak var navTitle: UINavigationItem!
    
    @IBOutlet weak var descriptionText : UILabel!
    @IBOutlet weak var angleText : UILabel!
    @IBOutlet weak var shotText : UILabel!
    @IBOutlet weak var movementText : UILabel!
    
    @IBOutlet weak var counterSceneText : UILabel!
    @IBOutlet weak var thumbnailImage : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navTitle.title = projectTitlePassingBro
        
        let SLC = SceneListController()
        SLC.delegateController = self
        sceneMenu = SideMenuNavigationController(rootViewController: SLC)
        sceneMenu?.leftSide = true
        sceneMenu?.title = "Scenes"
        sceneMenu?.navigationBar.barTintColor = #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.1450980392, alpha: 1)
    }
    
    @IBAction func tapSceneMenu(_ sender: UIButton) {
        present(sceneMenu!, animated: true)
    }
    
    @IBAction func tapCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func ChangeSubScene(scene: SubScene, counter : String) {
        descriptionText.text = scene.sceneDescription
        angleText.text = scene.angle
        shotText.text = scene.shotSize
        movementText.text = scene.movement
        
        counterSceneText.text = counter
//        thumbnailImage.image = image
    }
}

protocol SceneListControllerDelegate{
    
    func ChangeSubScene(scene : SubScene, counter : String)
    
}

class SceneListController : UITableViewController{
    
    var coreData = CoreDataManager()
    var currentProject : Project? = nil
    var allScenez: [Scene: [SubScene]] = [:]
    var allSubsScenez : [ [SubScene] ] = []
    
    public var delegateController: SceneListControllerDelegate?
    
    let darkColour = #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.1450980392, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.backgroundColor = darkColour
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //Get Core Data
        var listProject : [Project] = []
        listProject = coreData.getAllData(entity: Project.self)
        //GET currentProject
        
        //Harusnya disini dapet dari page sebelum
        let listScene = coreData.getAllProjectScene(project: listProject[0])
        //Cara ribet
//        if let z = listScene[0].scenetosub?.allObjects as? [SubScene] {
//            for i in z {
//                print(i.angle! as String)
//            }
//        }
        
        for i in listScene {
            allSubsScenez.append(coreData.getAllSubScene(scene: i))
        }
        
        //Harusnya disini tergantung saat clicknya
        delegateController?.ChangeSubScene(scene: allSubsScenez[0][0], counter : "\(1)/\(allSubsScenez[0].count)")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allSubsScenez.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSubsScenez[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Scene \(section+1)"
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let myLabel = UILabel()
//        myLabel.frame = CGRect(x: 16, y: 8, width: 320, height: 30)
//        myLabel.font = UIFont(name: "Poppins-Regular", size: 24)
//        myLabel.textColor = .white
//        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
//
//        let headerView = UIView()
//        headerView.addSubview(myLabel)
//
//        return headerView
//    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Scene \(indexPath.section+1).\(indexPath.row+1)"
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "Poppins-Regular", size: 18)
        cell.backgroundColor = darkColour
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegateController?.ChangeSubScene(scene: allSubsScenez[indexPath.section][indexPath.row], counter : "\(indexPath.row+1)/\(allSubsScenez[indexPath.section].count)")
        
    }
}

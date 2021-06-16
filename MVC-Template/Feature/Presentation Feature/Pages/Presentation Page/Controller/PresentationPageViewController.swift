import UIKit
import SideMenu

class PresentationPageViewController: UIViewController, SceneListControllerDelegate {

    var sceneMenu : SideMenuNavigationController?
    var sceneListController : SceneListController?
    
    var projectTitlePassingBro : String?
    @IBOutlet weak var navTitle: UINavigationItem!
    
    @IBOutlet weak var descriptionText : UILabel!
    @IBOutlet weak var angleText : UILabel!
    @IBOutlet weak var shotText : UILabel!
    @IBOutlet weak var movementText : UILabel!
    
    @IBOutlet weak var counterSceneText : UILabel!
    @IBOutlet weak var thumbnailImage : UIImageView!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navTitle.title = projectTitlePassingBro
        
        sceneListController = SceneListController()
        sceneListController?.delegateController = self
        sceneMenu = SideMenuNavigationController(rootViewController: sceneListController ?? SceneListController())
        sceneMenu?.leftSide = true
        sceneMenu?.title = "Scenes"
        sceneMenu?.navigationBar.barTintColor = #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.1450980392, alpha: 1)
        
        sceneListController?.InitializeData()
    }
    
    @IBAction func tapSceneMenu(_ sender: UIButton) {
        present(sceneMenu!, animated: true)
    }
    
    @IBAction func tapCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tapPrev(_ sender: UIButton) {
        sceneListController?.ChangePage(isNext: false)
    }
    @IBAction func tapNext(_ sender: UIButton) {
        sceneListController?.ChangePage(isNext: true)
    }
    
    func ChangeSubScene(scene: SubScene, counter : String) {
        descriptionText.text = scene.sceneDescription
        angleText.text = scene.angle
        shotText.text = scene.shotSize
        movementText.text = scene.movement
        
        counterSceneText.text = counter
//        thumbnailImage.image = image
    }
    
    func HideButton(isHideNext: Bool, isHidePrev : Bool) {
        nextButton.isHidden = isHideNext
        prevButton.isHidden = isHidePrev
    }
}

protocol SceneListControllerDelegate{
    
    func ChangeSubScene(scene : SubScene, counter : String)
    
    func HideButton(isHideNext : Bool, isHidePrev : Bool)
}

class SceneListController : UITableViewController{
    
    var coreData = CoreDataManager()
    var currentProject : Project? = nil
    var allSubsScenez : [ [SubScene] ] = []
    var indexScene : Int = 0
    var indexSubscene : Int = 0
    
    public var delegateController: SceneListControllerDelegate?
    
    let darkColour = #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.1450980392, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.backgroundColor = darkColour
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        
        indexScene = indexPath.section
        indexSubscene = indexPath.row
        
        CheckButtons()
        
        delegateController?.ChangeSubScene(scene: allSubsScenez[indexScene][indexSubscene], counter : "Scene \(indexScene+1) - Subscene \(indexSubscene+1)")
//        delegateController?.ChangeSubScene(scene: allSubsScenez[indexPath.section][indexPath.row], counter : "\(indexPath.row+1)/\(allSubsScenez[indexPath.section].count)")
    }
    
    func InitializeData(){
        
        //Get Core Data
        var listProject : [Project] = []
        
        //Harusnya disini dapet project sekarang apa dari page sebelum
        listProject = coreData.getAllData(entity: Project.self)
        
        //Harusnya disini dapet dari page sebelum
        let listScene = coreData.getAllProjectScene(project: listProject[0])
        
        for i in listScene {
            allSubsScenez.append(coreData.getAllSubScene(scene: i))
        }
        
        //Diganti sesuai dari sebelum page
        indexScene = 0
        indexSubscene = 0
        
        CheckButtons()
        
        //Harusnya disini tergantung saat clicknya
        delegateController?.ChangeSubScene(scene: allSubsScenez[indexScene][indexSubscene], counter : "Scene \(indexScene+1) - Subscene \(indexSubscene+1)")
//        delegateController?.ChangeSubScene(scene: allSubsScenez[indexScene][indexSubscene], counter : "\(indexSubscene+1)/\(allSubsScenez[indexScene].count)")
    }
    
    func ChangePage(isNext : Bool){
        
        //Disini ada pengecekan jika click button next padahal max, seharusnya udah gak perlu lagi sih, soalnya buttonnya kan di hide
        if isNext {
            if allSubsScenez[indexScene].count == (indexSubscene+1) {
                if allSubsScenez.count == (indexScene+1){
                    return
                }
                else
                {
                    //Handle jika buat Scene kosong, tidak ada subscene
                    if allSubsScenez[indexScene+1].count != 0 {
                        indexScene += 1
                        indexSubscene = 0
                    }
                }
            }
            else{
                indexSubscene += 1
            }
        }
        else{
            if (indexSubscene-1) < 0 {
                if (indexScene-1) < 0 {
                    return
                }
                else{
                    indexScene -= 1
                    indexSubscene = allSubsScenez[indexScene].count-1
                }
            }
            else{
                indexSubscene -= 1
            }
        }
        
        CheckButtons()
        delegateController?.ChangeSubScene(scene: allSubsScenez[indexScene][indexSubscene], counter : "Scene \(indexScene+1) - Subscene \(indexSubscene+1)")
    }
    
    func CheckButtons(){
        let hideNext : Bool = allSubsScenez[indexScene].count == (indexSubscene+1) && (allSubsScenez[indexScene+1].count == 0 || allSubsScenez.count == (indexScene+1))
        let hidePrev : Bool = (indexScene-1) < 0 && (indexSubscene-1) < 0
        delegateController?.HideButton(isHideNext: hideNext, isHidePrev: hidePrev)
    }
}

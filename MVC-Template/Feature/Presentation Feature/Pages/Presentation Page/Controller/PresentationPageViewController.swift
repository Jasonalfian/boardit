//
//  PresentationPageViewController.swift
//  BoardIt
//
//  Created by Gilbert Nicholas on 08/06/21.
//

import UIKit
import SideMenu

class PresentationPageViewController: UIViewController, SceneListControllerDelegate {

    var sceneMenu : SideMenuNavigationController?
    
    @IBOutlet weak var descriptionText : UILabel!
    @IBOutlet weak var angleText : UILabel!
    @IBOutlet weak var shotText : UILabel!
    @IBOutlet weak var movementText : UILabel!
    
    @IBOutlet weak var counterSceneText : UILabel!
    @IBOutlet weak var thumbnailImage : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let SLC = SceneListController()
        SLC.delegateController = self
        sceneMenu = SideMenuNavigationController(rootViewController: SLC)
        sceneMenu?.leftSide = true
        sceneMenu?.title = "Scenes"
        sceneMenu?.navigationBar.barTintColor = #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.1450980392, alpha: 1)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapSceneMenu(_ sender: UIButton) {
        present(sceneMenu!, animated: true)
    }
    
    func ChangeDescriptionText(named: String) {
        descriptionText.text = named
    }
    
    func ChangeAngleText(named: String) {
        angleText.text = named
    }
    
    func ChangeShotText(named: String) {
        shotText.text = named
    }
    
    func ChangeMovementText(named: String) {
        movementText.text = named
    }
    
    func ChangeCounterText(named: String) {
        counterSceneText.text = named
    }
    
    func ChangeImageText(named: UIImage) {
        thumbnailImage.image = named
    }
}

protocol SceneListControllerDelegate{
    func ChangeDescriptionText(named: String)
    func ChangeAngleText(named: String)
    func ChangeShotText(named: String)
    func ChangeMovementText(named: String)
    func ChangeCounterText(named: String)
    func ChangeImageText(named: UIImage)
}

class SceneListController : UITableViewController{
    
    var totalScenes = [ [1,2,3], [1,2,3,4], [1,2] ]
    
    public var delegateController: SceneListControllerDelegate?
    
    let darkColour = #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.1450980392, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.backgroundColor = darkColour
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //Get Core Data
        totalScenes = [ [1,2,3], [1,2,3,4], [1,2] ]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return totalScenes.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalScenes[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Scene \(section)"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Scene \(indexPath.section+1).\(indexPath.row+1)"
        cell.textLabel?.textColor = .white
        cell.backgroundColor = darkColour
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegateController?.ChangeCounterText(named: "\(indexPath.row+1)/\(tableView.numberOfRows(inSection: indexPath.section))")
        
        delegateController?.ChangeDescriptionText(named: "Description \(indexPath.section+1).\(indexPath.row+1)")
        delegateController?.ChangeShotText(named: "Shot \(indexPath.section+1).\(indexPath.row+1)/")
        delegateController?.ChangeAngleText(named: "Angle \(indexPath.section+1).\(indexPath.row+1)")
        delegateController?.ChangeMovementText(named: "Movement \(indexPath.section+1).\(indexPath.row+1)")
//        otherScript.counterSceneText?.text = "\(indexPath.row)/\(indexPath.section)"
        //Change right side content
    }
}

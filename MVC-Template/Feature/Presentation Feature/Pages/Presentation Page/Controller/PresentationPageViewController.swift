//
//  PresentationPageViewController.swift
//  BoardIt
//
//  Created by Gilbert Nicholas on 08/06/21.
//

import UIKit
import SideMenu

class PresentationPageViewController: UIViewController {

    var sceneMenu : SideMenuNavigationController?
    
    @IBOutlet weak var descriptionText : UILabel!
    @IBOutlet weak var angleText : UILabel!
    @IBOutlet weak var shotText : UILabel!
    @IBOutlet weak var movementText : UILabel!
    
    @IBOutlet weak var counterSceneText : UILabel!
    @IBOutlet weak var thumbnailImage : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneMenu = SideMenuNavigationController(rootViewController: SceneListController())
        sceneMenu?.leftSide = true
        sceneMenu?.title = "Scenes"
//        sceneMenu?.navigationItem.title = "SKIP"
        sceneMenu?.navigationBar.barTintColor = #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.1450980392, alpha: 1)
//        sceneMenu?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.orange]
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapSceneMenu(_ sender: UIButton) {
        present(sceneMenu!, animated: true)
    }
}

class SceneListController : UITableViewController{
    var items = ["A", "B", "C"]
    let darkColour = #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.1450980392, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = darkColour
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = darkColour
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Change right side content
    }
}

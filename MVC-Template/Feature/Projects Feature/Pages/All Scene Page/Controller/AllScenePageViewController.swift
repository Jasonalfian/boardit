//
//  AllScenePageViewController.swift
//  BoardIt
//
//  Created by Gilbert Nicholas on 08/06/21.
//

import UIKit

class AllScenePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
   
    var aspectRatio = 0
    var coreData = CoreDataManager()
    var listProject:[Project] = []
    
    @IBOutlet var table: UITableView!
//    @IBAction func sideBar(_ sender: Any) {
//
//    didTapButton()
//        
//    }
    
    var models = [Model]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        listProject = coreData.getAllData(entity: Project.self)
//        print("jumlah data",listProject.count)
//        for item in listProject {
//            print(item.name,item.ratio,item.number)
//        }

        table.register(CollectionTableViewCell.nib(), forCellReuseIdentifier: CollectionTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self


        models.append(Model(desc: "Toni jalan ke depan rumah", size: "Medium Close Up", angle: "Ground Level", movement: "Static", imageName: "Ground Level"))

        models.append(Model(desc: "Toni tersandung oleh batu", size: "Medium Close Up", angle: "Eye Level", movement: "Static", imageName: "Eye Level"))

        models.append(Model(desc: "Toni jalan ke depan rumah", size: "Medium Close Up", angle: "Ground Level", movement: "Static", imageName: "Ground Level"))

        models.append(Model(desc: "Toni tersandung oleh batu", size: "Medium Close Up", angle: "Eye Level", movement: "Static", imageName: "Eye Level"))
        models.append(Model(desc: "Toni jalan ke depan rumah", size: "Medium Close Up", angle: "Ground Level", movement: "Static", imageName: "Ground Level"))

        models.append(Model(desc: "Toni tersandung oleh batu", size: "Medium Close Up", angle: "Eye Level", movement: "Static", imageName: "Eye Level"))
       
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as! CollectionTableViewCell
    
        cell.textLabel?.text = "      Scene 1"
        cell.textLabel?.font = UIFont(name: "Poppins-SemiBold", size: 20)
        cell.textLabel?.textAlignment = .left

        
//        // Define attributes
//        let labelFont = UIFont(name: "Poppins-Bold", size: 18)
//        let attributes :Dictionary = [NSAttributedString.Key.font : labelFont]
//
//        // Create attributed string
//        var attrString = NSAttributedString(string: "Foo", attributes:attributes as [NSAttributedString.Key : Any])
//
//        cell.textLabel?.attributedText = attrString
        
        cell.configure(with: models)
        
    return cell
        
    }
        
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
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
    let desc: String
    let size: String
    let angle: String
    let movement: String
    
    let imageName: String
    
    init(desc: String, size: String, angle: String, movement: String, imageName: String ) {
        self.desc = desc
        self.size = size
        self.angle = angle
        self.movement = movement
        self.imageName = imageName
    }
    
    
}




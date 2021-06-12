//
//  AllScenePageViewController.swift
//  BoardIt
//
//  Created by Gilbert Nicholas on 08/06/21.
//

import UIKit

class AllScenePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet var table: UITableView!
    
//    private let sectionInsets = UIEdgeInsets(
//      top: 50.0,
//      left: 100.0,
//      bottom: 100.0,
//      right: 50.0)
    
    var models = [Model]()
    override func viewDidLoad() {
        super.viewDidLoad()

        table.register(CollectionTableViewCell.nib(), forCellReuseIdentifier: CollectionTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
    
        
        models.append(Model(title: "Halo bandung ku", tanggal: "Last Edited on 13/12/2021", imageName: "Eye Level"))
       
        models.append(Model(title: "Jakarta Hujan", tanggal: "Last Edited on 12/01/2021", imageName: "Ground Level"))
        
        models.append(Model(title: "Keseleo Kaki nih", tanggal: "Last Edited on 02/01/2020", imageName: "Eye Level"))
        
        models.append(Model(title: "Halo bandung ku", tanggal: "Last Edited on 13/12/2021", imageName: "Eye Level"))
        
        models.append(Model(title: "Jakarta Hujan", tanggal: "Last Edited on 12/01/2021", imageName: "Ground Level"))
        
        models.append(Model(title: "Keseleo Kaki nih", tanggal: "Last Edited on 02/01/2020", imageName: "Eye Level"))
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as! CollectionTableViewCell
    
        cell.textLabel?.text = "              Scene 1"
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
        return 305
    }
    
    }


struct Model {
    let title: String
    let tanggal: String
    let imageName: String
    
    init(title: String, tanggal: String, imageName: String ) {
        self.title = title
        self.tanggal = tanggal
        self.imageName = imageName
    }
    
}

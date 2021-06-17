//
//  ProjectViewController.swift
//  BoardIt
//
//  Created by Harrya Grahila Prabaswara on 15/06/21.
//

import UIKit
class ProjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var coreData = CoreDataManager()
    var listProject:[Project] = []
    var dateFormatter = DateFormatter()
    
    @IBOutlet weak var addProjectButton: UIButton!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NotificationCenter.default.post(name: Notification.Name("loadFromProject"), object:listProject[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listProject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewProjectTableViewCell", for: indexPath) as! NewProjectTableViewCell
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let result = listProject[indexPath.row]
        cell.projectName.text = result.name
        if result.lastModified == nil {
            cell.projectDate.text = dateFormatter.string(from: result.dateCreated!)
        } else {
            cell.projectDate.text = dateFormatter.string(from: result.lastModified!)
        }
        
            return cell
        }
    
    @IBAction func unwindToViewControllerA(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.projectTable.reloadData()
            }
        }
    }
    
    @IBOutlet weak var projectTable: UITableView!
    
    @objc func loadList(notification: NSNotification)
    {
        listProject = coreData.getAllData(entity: Project.self)
        self.projectTable.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadFromProject"), object: nil)
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        listProject = coreData.getAllData(entity: Project.self)
        
//        self.projectTable.register(UINib(nibName: "NewProjectTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        let nib = UINib(nibName: "NewProjectTableViewCell", bundle: nil)
        projectTable.register(nib, forCellReuseIdentifier: "NewProjectTableViewCell")
        self.projectTable.delegate = self
        self.projectTable.dataSource = self
        
        addProjectButton.layer.borderWidth = 1
        addProjectButton.layer.cornerRadius = 30
        
        self.projectTable.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)

    }
}

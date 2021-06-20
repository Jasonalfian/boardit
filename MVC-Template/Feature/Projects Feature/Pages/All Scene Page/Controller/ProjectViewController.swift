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
    
    @objc func tesPopover(_ data: Notification) {
        
        let indexRow = data.object as! Int
        
        let indexPath = NSIndexPath(row: indexRow, section: 0)
        let cell = projectTable.cellForRow(at: indexPath as IndexPath) as! NewProjectTableViewCell
        
        cell.renameProject()
    }
    
    
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
        cell.projectTextView.text = result.name
        cell.viewController = self.navigationController
        cell.indexRowNumber = indexPath.row
        cell.project = result
        
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
    
    @objc func loadList(notification: Notification)
    {
        
        var row = notification.object as! Int
        
        listProject = coreData.getAllData(entity: Project.self)
        
        self.projectTable.reloadData()
        
//        if (row == nil) {
//        self.projectTable.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadFromProject"), object: listProject[0])
//        } else {
            
            if (row == listProject.count){
                row = row - 1
            }
            
            self.projectTable.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .top)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadFromProject"), object: listProject[row])
//        }
        
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        listProject = coreData.getAllData(entity: Project.self)
        
        if (listProject.count == 0){
            coreData.createProject(name: "First Project", ratio: 16)
            listProject = coreData.getAllData(entity: Project.self)
            
            coreData.createScene(project: listProject[0])
        }
        
//        self.projectTable.register(UINib(nibName: "NewProjectTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        let nib = UINib(nibName: "NewProjectTableViewCell", bundle: nil)
        projectTable.register(nib, forCellReuseIdentifier: "NewProjectTableViewCell")
        self.projectTable.delegate = self
        self.projectTable.dataSource = self
        
        addProjectButton.layer.borderWidth = 1
        addProjectButton.layer.cornerRadius = 30
        
        self.projectTable.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(tesPopover), name: NSNotification.Name(rawValue: "renamePopOver"), object: nil)

    }
}

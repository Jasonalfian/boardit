//
//  EditModalTypeController.swift
//  BoardIt
//
//  Created by Gilbert Nicholas on 08/06/21.
//

import UIKit

class EditModalTypeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var listAngle = Angle.generateAngle()
    var listShotSize = ShotSize.generateShotSize()
    var listMovement = Movement.generateMovement()
    var startingIndex:Int!
    
    var prevVC = EditSubscenePageViewController()
    
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var modalTitle: UILabel!
    @IBOutlet weak var listType: UITableView!
    @IBOutlet weak var typeName: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var typeDescriptionTV: UITextView!
    
    var titleSegue:String = ""
    var returnData:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initiateView()
        // Do any additional setup after loading the view.
    }
    
    func displayTutorial(text: String, step: String) {
        let overlay = Tutorial.createPopOver(tutorialText: text, step: step, elementToPoint: typeView, direction: .left, isInsideModal: true, hasSidebar: true)
        DispatchQueue.main.async {
            self.present(overlay, animated: true)
        }
    }
    
    func initiateView() {
        
        //rounded corner modal
        typeView.layer.cornerRadius = 15
        typeView.layer.masksToBounds = true
        
        //border for tableview
        listType.layer.borderWidth = 0.5
        listType.contentInset = UIEdgeInsets(top: 0,left: 5,bottom: 0,right: 0)
        
        //typeDescription
        typeDescriptionTV.isEditable = false
        
        //Register tableview delegate and datasource
        listType.delegate = self
        listType.dataSource = self
        
        //Initial value for description
        
        if titleSegue == "Angle Type"{
            
            if startingIndex == 99 {
                
            listType.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
                
                typeName.text = listAngle[0].name
                typeImage.image = listAngle[0].gambar
                typeDescriptionTV.text = listAngle[0].description
            
            } else {
                
            listType.selectRow(at: IndexPath(row: startingIndex, section: 0), animated: true, scrollPosition: .top)
                typeName.text = listAngle[startingIndex].name
                typeImage.image = listAngle[startingIndex].gambar
                typeDescriptionTV.text = listAngle[startingIndex].description
            }
            
            if UserDefaults.standard.bool(forKey: "isTutorial") {
                displayTutorial(text: Tutorial.getTutorialDataByID(id: 6)!.description, step: "6/17")
                UserDefaults.standard.setValue(7, forKey: "tutorialStep")
            }
        }
        else if (titleSegue == "Shot Type") {
            
            if startingIndex == 99 {
                
            listType.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
                
                typeName.text = listShotSize[0].name
                typeImage.image = listShotSize[0].gambar
                typeDescriptionTV.text = listShotSize[0].description
            
            } else {
                
            listType.selectRow(at: IndexPath(row: startingIndex, section: 0), animated: true, scrollPosition: .top)
                
                typeName.text = listShotSize[startingIndex].name
                typeImage.image = listShotSize[startingIndex].gambar
                typeDescriptionTV.text = listShotSize[startingIndex].description
                
            }
            
            if UserDefaults.standard.bool(forKey: "isTutorial") {
                displayTutorial(text: Tutorial.getTutorialDataByID(id: 8)!.description, step: "8/17")
                UserDefaults.standard.setValue(9, forKey: "tutorialStep")
            }
        }
        else if (titleSegue == "Movement Type") {
            
            
            if startingIndex == 99 {
                
            listType.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
            
                typeName.text = listMovement[0].name
                typeDescriptionTV.text = listMovement[0].description
                
                typeImage.animationImages = [listMovement[0].gambar, listMovement[0].gambar2,
                                             listMovement[0].gambar3, listMovement[0].gambar2 ,listMovement[0].gambar]
            
            } else {
                
            listType.selectRow(at: IndexPath(row: startingIndex, section: 0), animated: true, scrollPosition: .top)
                
                typeName.text = listMovement[startingIndex].name
                typeDescriptionTV.text = listMovement[startingIndex].description
                
                typeImage.animationImages = [listMovement[startingIndex].gambar, listMovement[startingIndex].gambar2,
                                             listMovement[startingIndex].gambar3, listMovement[startingIndex].gambar2 ,listMovement[startingIndex].gambar]
            }
            
            
            
            typeImage.animationDuration = 5
            
            typeImage.animationRepeatCount = 0
            typeImage.startAnimating()
            
            if UserDefaults.standard.bool(forKey: "isTutorial") {
                displayTutorial(text: Tutorial.getTutorialDataByID(id: 10)!.description, step: "10/17")
                UserDefaults.standard.setValue(11, forKey: "tutorialStep")
            }
        }
        
        modalTitle.text = titleSegue
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if titleSegue == "Angle Type"{
            typeName.text = listAngle[indexPath.row].name
            typeImage.image=listAngle[indexPath.row].gambar
            typeDescriptionTV.text = listAngle[indexPath.row].description
        } else if (titleSegue == "Shot Type") {
            typeName.text = listShotSize[indexPath.row].name
            typeImage.image=listShotSize[indexPath.row].gambar
            typeDescriptionTV.text = listShotSize[indexPath.row].description
        } else if (titleSegue == "Movement Type") {
            
            typeName.text = listMovement[indexPath.row].name
            typeDescriptionTV.text = listMovement[indexPath.row].description
            
            if ((indexPath.row == 0) || (indexPath.row == 4)) {
                
            typeImage.animationImages = [listMovement[indexPath.row].gambar, listMovement[indexPath.row].gambar2,
                                         listMovement[indexPath.row].gambar3, listMovement[indexPath.row].gambar2, listMovement[indexPath.row].gambar]
            typeImage.animationDuration = 5
                
            } else {
                typeImage.animationImages = [listMovement[indexPath.row].gambar, listMovement[indexPath.row].gambar2,
                                         listMovement[indexPath.row].gambar3]
                typeImage.animationDuration = 3
            }
            typeImage.animationRepeatCount = 0
            typeImage.startAnimating()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rowCount: Int = 0
        
        if titleSegue == "Angle Type"{
        rowCount = listAngle.count
        } else if (titleSegue == "Shot Type") {
        rowCount = listShotSize.count
        } else if (titleSegue == "Movement Type") {
        rowCount = listMovement.count
        }
        
        return rowCount
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if titleSegue == "Angle Type"{
        cell.textLabel?.text = "\(listAngle[indexPath.row].name)"
        } else if (titleSegue == "Shot Type") {
        cell.textLabel?.text = "\(listShotSize[indexPath.row].name)"
        } else if (titleSegue == "Movement Type") {
        cell.textLabel?.text = "\(listMovement[indexPath.row].name)"
        }

        cell.textLabel?.font = UIFont(name: "Poppins", size: 14)
        cell.detailTextLabel?.font = UIFont(name: "Poppins", size: 24)
            
        cell.detailTextLabel?.text = "???"
        
        return cell
    }
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func selectButton(_ sender: UIButton) {
        
        returnData.append(typeName.text!)
        returnData.append(titleSegue)
        NotificationCenter.default.post(name: Notification.Name("refresh"), object:self.returnData)
        
        self.dismiss(animated: true) {
            self.prevVC.moveTutorial()
        }
    }
    
}

//
//  coreDataExample.swift
//  BoardIt
//
//  Created by Jason Hartanto on 14/06/21.
//

import Foundation
import UIKit

class CoreDataExample: UIViewController {
    
    //Buat objek CoreDataManeger
    var coreData = CoreDataManager()
    
    //Buat array buat dapetin data
    var listProject:[Project] = []
    var listScene:[Scene] = []
    var listSubScene:[SubScene] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Buat project baru input nama dan ratio
        coreData.createProject(name: "Andy pergi ke pasar")
        coreData.createProject(name: "Memasak rendang pagi hari")
        
        //Fetch semua Project yang ada
        listProject = coreData.getAllData(entity: Project.self)
        
        //Create newScene
        coreData.createScene(project: listProject[0])
        coreData.createScene(project: listProject[1])
        
        //Fetch semua scene berdasarkan project (disortir dari scene number ascending)
        listScene = coreData.getAllProjectScene(project: listProject[0])
        
        //Testing 
        var testImage = #imageLiteral(resourceName: "shotSize-closeUp")
        var imageData = testImage.pngData()
        
        print(imageData)
        
//        print(listScene[1].number)
        
        coreData.createSubScene(scene: listScene[0], description: "Ayam Bakar 2", angle: "Eye Level", shotSize: "Long Shot", movement: "Push In", storyboard: imageData)
        coreData.createSubScene(scene: listScene[0], description: "Ayam Bakar 2", angle: "Eye Level", shotSize: "Long Shot", movement: "Push In", storyboard: imageData)
//
        listSubScene = coreData.getAllData(entity: SubScene.self)
        listSubScene = coreData.getAllSubScene(scene: listScene[0])
//
        print(listSubScene.count)
        
        coreData.removeSubScene(subScene: listSubScene[0])
        coreData.removeScene(scene: <#T##Scene#>)
        coreData.removeProject(project: <#T##Project#>)
        
//        for item in listSubScene{
//            coreData.removeSubScene(subScene: item)
//        }
        
//        print(listSubScene.count)
        
        for item in listSubScene{
            
//            coreData.removeSubScene(subScene: item)
//            coreData.updateSubScene(subScene: item, description: "Mcd Enak")
            print(item.number)
//            print(item.sceneDescription)
            print(item.storyboard)
//            print(item.subtoscene!.number)
//            print(item.subtoscene!.scenetoproject!.number)
//            print(item.dateCreated)
        }
        
//        print(listProject[1].dateCreated)
//        print(listProject[1].name)
//        print(listProject[1].number)
        
//        for item in listProject{
//            coreData.removeProject(project: item)
//        }
        
    }
    
    
}

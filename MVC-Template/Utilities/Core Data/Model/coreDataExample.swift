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
        coreData.createProject(name: "Andy pergi ke pasar", ratio: 1)
        coreData.createProject(name: "Memasak rendang pagi hari", ratio: 2)
        
        //Fetch semua Project yang ada
        listProject = coreData.getAllData(entity: Project.self)
        
        //Create newScene
        coreData.createScene(project: listProject[0])
        coreData.createScene(project: listProject[1])
        
        //Fetch semua scene berdasarkan project (disortir dari scene number ascending)
        listScene = coreData.getAllProjectScene(project: listProject[0])
        
        //Testing buat image baru
        var testImage = #imageLiteral(resourceName: "shotSize-closeUp")
        var imageData = testImage.pngData()
        
        //createNewSubscene
        coreData.createSubScene(scene: listScene[0], description: "Ayam Bakar 2", angle: "Eye Level", shotSize: "Long Shot", movement: "Push In", storyboard: imageData)
        coreData.createSubScene(scene: listScene[0], description: "Ayam Bakar 2", angle: "Eye Level", shotSize: "Long Shot", movement: "Push In", storyboard: imageData)
        
        //Fetch smua subscene tanpa filter
        listSubScene = coreData.getAllData(entity: SubScene.self)
        
        //Fetch semua subscene dengan filter scene
        listSubScene = coreData.getAllSubScene(scene: listScene[0])
        
        
        //Hapus scene, subscene, dan project. Hapus scene akan hapus semua subscene didalamnya. Hapua project akan hapus semua scene dan subscene di dalamnya
        coreData.removeSubScene(subScene: listSubScene[0])
        coreData.removeScene(scene: listScene[0])
        coreData.removeProject(project: listProject[0])
        
    }
    
    
}

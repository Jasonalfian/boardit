//
//  CoreDataManager.swift
//  BoardIt
//
//  Created by Jason Hartanto on 08/06/21.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Create Function
    func createProject(name:String, ratio:Int64) {
        
        var tempProjectList:[Project]=[]
        
        tempProjectList = getAllData(entity: Project.self)
        
        var newProject = Project(context: self.context)
        newProject.name = name
        newProject.dateCreated = Date()
        newProject.ratio = ratio
        
        if (tempProjectList.count == 0){
            
            newProject.number = 1
            
        } else {
            
            newProject.number = (tempProjectList.last!.number) + 1
        }
        save()
    }
    
    func createScene(project: Project) {
        
        var tempSceneList:[Scene]=[]
    
        tempSceneList=getAllProjectScene(project: project)
        
        var newScene = Scene(context: self.context)
        newScene.scenetoproject = project
        newScene.dateCreated = Date()
        
        if (tempSceneList.count == 0) {
            newScene.number=1
        } else {
            newScene.number = Int64(tempSceneList.last!.number) + 1
        }

        save()
    }
    
    func createSubScene(scene: Scene!, description: String? = nil, angle: String? = nil, shotSize: String? = nil, movement: String? = nil, storyboard: Data? = nil){
    
        var tempSubSceneList: [SubScene] = []
        
        tempSubSceneList=getAllSubScene(scene: scene)
        
        var newSubScene = SubScene(context: self.context)
        newSubScene.subtoscene = scene
        newSubScene.sceneDescription = description
        newSubScene.angle = angle
        newSubScene.shotSize = shotSize
        newSubScene.movement = movement
        newSubScene.storyboard = storyboard
        
        print(storyboard)
        print(newSubScene.storyboard)
        
        newSubScene.dateCreated = Date()
        
        if (tempSubSceneList.count == 0) {
            
            newSubScene.number = 1
            
        } else {
    
            newSubScene.number = (tempSubSceneList.last!.number) + 1
        }
        
        save()
    }
    
    //Read Function
    func getAllData<T:NSManagedObject>(entity: T.Type) -> [T] {
        
        var data : [T] = []
        let entityName = String(describing: entity)
        
        do{
            
            let request:NSFetchRequest<T> = NSFetchRequest<T>(entityName: entityName)
            
            if (entityName == "Project") {
                request.sortDescriptors = [NSSortDescriptor(key:"dateCreated",ascending: true)]
            }
            
            data = try context.fetch(request)
            
        }
        catch{
            print("Error fetching data")
        }
        return data
    }
    
    
    func getAllProjectScene(project: Project) -> [Scene]{
        
        var tempScene: [Scene] = []
        
        do {
            let request = Scene.fetchRequest() as NSFetchRequest<Scene>
            
            request.sortDescriptors = [NSSortDescriptor(key:"dateCreated",ascending: true)]
            let pred = NSPredicate(format:"scenetoproject == %@", project as Project)
            request.predicate = pred
            
            tempScene = try context.fetch(request)
            
        } catch {
            print("Error fetching Project")
        }
        
        return tempScene
    }
    
    func getAllSubScene(scene: Scene) -> [SubScene] {
        
        var tempSubScene: [SubScene] = []
        
        do {
            let request = SubScene.fetchRequest() as NSFetchRequest<SubScene>
            
            request.sortDescriptors = [NSSortDescriptor(key:"number",ascending: true)]
            let pred = NSPredicate(format:"subtoscene == %@", scene as Scene)
            request.predicate = pred
            
            tempSubScene = try context.fetch(request)
            
        } catch {
            print("Error fetching Project")
        }
        
        return tempSubScene
    }
    
    //Update Data
    func updateProject(project: Project!, name:String?, modifiedDate:Date? ) {
        
        project.name = name ?? project.name
        project.lastModified = modifiedDate ?? project.lastModified
        
        save()
    }
    
    func updateSubScene(subScene: SubScene!, description: String? = nil, angle: String? = nil, shotSize: String? = nil, movement: String? = nil, storyboard: Data? = nil){
    
        subScene.sceneDescription = description
        subScene.angle = angle
        subScene.shotSize = shotSize
        subScene.movement = movement
        subScene.storyboard = storyboard
        
        save()
    }
    
    //Remove Data
    func removeProject(project: Project) {
        
        //Get All Scene and SubScene to delete
        
        var tempListScene:[Scene] = getAllProjectScene(project: project)
        var tempListSubScene:[SubScene] = []
        var tempListSubScene2:[SubScene] = []
        
        for scene in tempListScene {
            tempListSubScene2 = getAllSubScene(scene: scene)
            for subscene in tempListSubScene2{
                tempListSubScene.append(subscene)
            }
            tempListSubScene2=[]
        }
        
        //Delete all subScene
        for subscene in tempListSubScene {
            self.context.delete(subscene)
        }
        
        //Delete all scene
        for scene in tempListScene {
            self.context.delete(scene)
        }
        
        //Delete project
        self.context.delete(project)
        
        save()
    }
    
    func removeScene(scene: Scene){
        self.context.delete(scene)
        save()
    }
    
    func removeSubScene(subScene: SubScene){
        self.context.delete(subScene)
        save()
    }
    
    //Save to core data
    private func save() {
        do {
            try self.context.save()
        }
            catch{
                print("Error initializing default data")
            }
    }
}

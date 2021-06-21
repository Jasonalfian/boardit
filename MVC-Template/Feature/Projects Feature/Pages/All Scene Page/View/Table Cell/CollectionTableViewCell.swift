//
//  CollectionTableViewCell.swift
//  BoardIt
//
//  Created by Nicholas Kusuma on 12/06/21.
//

import UIKit

class CollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TableObserver {

    var navigationController: UINavigationController?
    var observerController: ObserverController!
    var coreData: CoreDataManager!
    var firstCell: MyCollectionViewCell?
    
    var sceneNum: Int!
    
    static let identifier = "CollectionTableViewCell"
    
    var modelCore: [SubScene]!
    var modeStatus: Bool = false
    
    static func nib() -> UINib {
        return UINib( nibName: "CollectionTableViewCell",
                      bundle: nil)
    }
    
    func configure(with models: [Model]){
        self.models = models
        collectionView.reloadData()
        observerController.tableObservers.append(self)
    }
    
    var dictionarySelectedIndexPath: [IndexPath: Bool] = [:]
    
    @IBOutlet var collectionView: UICollectionView!
    
    var models = [Model]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.font = UIFont(name: "Poppins-Bold", size: 12)
        
        collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func changeMultipleSelectStatus(status: Bool) {
        collectionView.allowsMultipleSelection = status == true ? true : false
        modeStatus = status
        
        if modeStatus == false {
            for (key, value) in dictionarySelectedIndexPath {
                if value {
                    collectionView.deselectItem(at: key, animated: true)
                }
            }
        }
        
        dictionarySelectedIndexPath.removeAll()
    }
    
    func didDeleteTapped() {
        var deleteNeededIndexPaths: [IndexPath] = []
        
        for (key, value) in dictionarySelectedIndexPath {
            if value {
                deleteNeededIndexPaths.append(key)
            }
        }
        
        for i in deleteNeededIndexPaths {
            coreData.removeSubScene(subScene: modelCore[i.item])
        }
        
        deleteNeededIndexPaths.removeAll()
        dictionarySelectedIndexPath.removeAll()
        for item in observerController.collObservers {
            item.didChange()
        }
    }
    
    override func updateConstraints() {
        textLabel!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel!.topAnchor.constraint(equalTo: topAnchor),
            textLabel!.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel!.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        super.updateConstraints()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.identifier, for: indexPath) as! MyCollectionViewCell
        
        cell.navigationController = self.navigationController
        cell.configure(with: models[indexPath.row])
        cell.sceneNumber = sceneNum
        cell.subSceneNumber = indexPath.row
        cell.observerController = self.observerController
        cell.setObserver()
        
        if indexPath.row == 0 {
            self.firstCell = cell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch modeStatus {
        case false:
            print("View Status")
        case true:
            
            if models[indexPath.row].addNew == false {
                dictionarySelectedIndexPath[indexPath] = true
                print("TRUE : \(sceneNum) \(indexPath.row) \(indexPath.count)")
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if modeStatus == true {
            dictionarySelectedIndexPath[indexPath] = false
            print("FALSE")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 462, height: 348)
    }
    
    private let sectionInsets = UIEdgeInsets(
          top: 50.0,
          left: 22.0,
          bottom: 60.0,
          right: 50.0)
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
      ) -> UIEdgeInsets {
        return sectionInsets
      }

      func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
      ) -> CGFloat {
        return sectionInsets.right
      }
}


//
//  CollectionTableViewCell.swift
//  BoardIt
//
//  Created by Nicholas Kusuma on 12/06/21.
//

import UIKit

class CollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    static let identifier = "CollectionTableViewCell"
    
    static func nib() -> UINib {
        return UINib( nibName: "CollectionTableViewCell",
                      bundle: nil)
    }
    
    func configure(with models: [Model]){
        self.models = models
        collectionView.reloadData()
        
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    var models = [Model]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.font = UIFont(name: "Poppins-Bold", size: 12)
        
        collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.identifier, for: indexPath) as!  MyCollectionViewCell
        
        cell.configure(with: models[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 300)
    }
    
    private let sectionInsets = UIEdgeInsets(
          top: 50.0,
          left: 55.0,
          bottom: 50.0,
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


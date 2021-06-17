//
//  MyCollectionViewCell.swift
//  BoardIt
//
//  Created by Nicholas Kusuma on 12/06/21.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {

    @IBOutlet var myDesc: UILabel!
    @IBOutlet var myShotSize: UILabel!
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet weak var BaseView: UIView!
    @IBOutlet weak var BaseHitam: UIView!
    @IBOutlet var myShotAngle: UILabel!
    @IBOutlet var myMovement: UILabel!
    
    static let identifier = "MyCollectionViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        BaseView.layer.borderWidth = 1
//        BaseView.layer.borderColor = #colorLiteral(red: 0.1930259168, green: 0.1930313706, blue: 0.19302845, alpha: 1)
        BaseView.layer.cornerRadius = 30
        BaseHitam.layer.cornerRadius = 30
        BaseHitam.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
    }

    public func configure(with model: Model) {
        self.myDesc.text = model.desc
        self.myShotSize.text = model.size
        self.myShotAngle.text = model.angle
        self.myMovement.text = model.movement
        self.myImageView.image = UIImage(data: model.imageName)
        
    }
    
}

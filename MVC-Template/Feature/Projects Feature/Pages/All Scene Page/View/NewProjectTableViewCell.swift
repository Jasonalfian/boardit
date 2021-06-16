//
//  NewProjectTableViewCell.swift
//  BoardIt
//
//  Created by Nicholas Kusuma on 14/06/21.
//

import UIKit

class NewProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var Bulet: UIView!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var projectDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//         Initialization code
//        Bulet.layer.cornerRadius = 9
//        Bulet.layer.borderWidth = 1
//        Bulet.layer.borderColor = #colorLiteral(red: 0.1000000015, green: 0.1000000015, blue: 0.1000000015, alpha: 1)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

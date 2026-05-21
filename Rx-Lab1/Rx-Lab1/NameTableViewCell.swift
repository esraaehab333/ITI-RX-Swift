//
//  NameTableViewCell.swift
//  Rx-Lab1
//
//  Created by Nemo on 20/05/2026.
//

import UIKit

class NameTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    public func setCellData(name:String){
        nameLabel.text = name
    }
}

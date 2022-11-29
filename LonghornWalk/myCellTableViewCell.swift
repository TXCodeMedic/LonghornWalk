//
//  myCellTableViewCell.swift
//  LonghornWalk
//
//  Created by Ronnie Sevilla on 11/28/22.
//

import UIKit

class myCellTableViewCell: UITableViewCell {


    @IBOutlet weak var locationName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

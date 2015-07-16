//
//  AddDetailTableViewCell.swift
//  Triplan
//
//  Created by 박태현 on 2015. 7. 14..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit

class AddDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var addLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

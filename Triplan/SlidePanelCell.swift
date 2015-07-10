//
//  SlidePanelCell.swift
//  Triplan
//
//  Created by 박태현 on 2015. 5. 9..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit

class SlidePanelCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//
//  DetailTableViewCell.swift
//  Triplan
//
//  Created by 박태현 on 2015. 7. 14..
//  Copyright (c) 2015년 태현. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var detailIconImageView: UIImageView!
    @IBOutlet weak var lineImageView: UIImageView!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailBudgetLabel: UILabel!
    @IBOutlet weak var detailContentsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

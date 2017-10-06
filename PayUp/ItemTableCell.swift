//
//  ItemTableCell.swift
//  PayUp
//
//  Created by Hongxuan on 6/10/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class ItemTableCell: UITableViewCell {

	@IBOutlet weak var lblItemName: UILabel!
	@IBOutlet weak var lblPrice: UILabel!
	@IBOutlet weak var lblGST: UILabel!
	@IBOutlet weak var lblTotalPrice: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

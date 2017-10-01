//
//  BillTableCell.swift
//  PayUp
//
//  Created by Hongxuan on 27/9/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

protocol BillTableCellDelegate {
	
	func updateItemName(_ cell: BillTableCell)
	func updateItemPrice(_ cell: BillTableCell)
}

class BillTableCell: UITableViewCell {
	

	@IBOutlet weak var txtName: UITextField!
	@IBOutlet weak var txtPrice: UITextField!
	
	var delegate : BillTableCellDelegate?
	var indexPath : IndexPath?
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
	
	@IBAction func updateItemName(_ sender: Any) {
		
		delegate?.updateItemName(self)
	}
	
	@IBAction func updateItemPrice(_ sender: Any) {
		
		delegate?.updateItemPrice(self)

	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

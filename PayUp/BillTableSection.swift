//
//  BillTableSection.swift
//  PayUp
//
//  Created by Hongxuan on 27/9/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit


protocol BillTableSectionDelegate {
	
	func toggleSection(_ header: BillTableSection, section: Int)
	func updatePersonName(_ header: BillTableSection)
}

class BillTableSection: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	@IBOutlet weak var txtName: UITextField!
	@IBOutlet weak var lblPrice: UILabel!
	@IBOutlet weak var btnAddItem: UIButton!
	
	
	var delegate: BillTableSectionDelegate?
	var section: Int = 0
	
	
	func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
		
		guard let cell = gestureRecognizer.view as? BillTableSection else {
			return
		}
		
		delegate?.toggleSection(self, section: cell.section)
	}
	
	@IBAction func updatePersonName(_ sender: Any) {
		
		delegate?.updatePersonName(self)
	}
}

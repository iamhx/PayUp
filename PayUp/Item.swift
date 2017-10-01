//
//  Item.swift
//  PayUp
//
//  Created by Hongxuan on 27/9/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class Item: NSObject {

	var itemName = ""
	var itemPrice : Decimal = 0.00
	
	init(itemName: String, itemPrice: Decimal) {
		
		self.itemName = itemName
		self.itemPrice = itemPrice
	}
	
}

//
//  Person.swift
//  PayUp
//
//  Created by Hongxuan on 27/9/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class Person: NSObject {
	
	var name = "Person"
	var items : [Item] = []
	var collapsed : Bool!
	
	init(name: String, collapsed: Bool = true) {
		
		self.name = name
		self.collapsed = collapsed
	}
}

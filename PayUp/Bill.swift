//
//  Bill.swift
//  PayUp
//
//  Created by Hongxuan on 6/10/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class Bill: NSObject {
	
	class func calculateBill(_ bill: [Person],_ svcCharge: Bool,_ GST: Bool) -> [Person] {
		
		var mutableBill = bill
		
		for i in 0 ..< mutableBill.count {
			
			for j in 0 ..< mutableBill[i].items.count {
				
				let tax = Bill.getGSTForIndividual(mutableBill[i].items[j].itemPrice, svcCharge, GST)
				mutableBill[i].items[j].itemPrice += tax
			}
		}
		
		return mutableBill
	}
	
	class func getGSTForIndividual(_ individualAmt: Decimal,_ svcCharge: Bool,_ GST: Bool) -> Decimal {
		
		var taxCost : Decimal = 0.00
		let SERVICE_CHARGE = Bill.getServiceCharge()
		let GOODS_SERVICE_TAX = Bill.getGST()
		
		if (svcCharge && GST) {
			
			taxCost = individualAmt * SERVICE_CHARGE
			taxCost = taxCost + ((individualAmt + taxCost) * GOODS_SERVICE_TAX)
		}
		else if (!svcCharge && GST) {
			
			taxCost = individualAmt * GOODS_SERVICE_TAX
		}
		else if (svcCharge && !GST) {
			
			taxCost = individualAmt * SERVICE_CHARGE
		}
		else {
			
			taxCost = 0.00
		}
		
		return taxCost
	}

	
	class func getTotalPrice(_ bill: [Person]) -> Decimal {
		
		var totalCost : Decimal = 0.00
		
		for i in 0..<bill.count {
			
			for j in 0..<bill[i].items.count {
				
				totalCost += bill[i].items[j].itemPrice
			}
		}
		
		return totalCost
	}
	
	class func getIndividualTotalPrice(_ person: Person) -> Decimal {
		
		var total: Decimal = 0.00
		
		for i in 0 ..< person.items.count {
			
			total += person.items[i].itemPrice
		}
		
		return total
	}
	
	class func getServiceCharge() -> Decimal {
		
		return 0.10
	}
	
	class func getGST() -> Decimal {
		
		return 0.07
	}
}

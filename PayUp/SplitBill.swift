//
//  SplitBill.swift
//  BillSplit
//
//  Created by Hongxuan on 21/3/17.
//  Copyright © 2017 hx. All rights reserved.
//

import UIKit

class SplitBill: NSObject {
	
	let SERVICE_CHARGE:Decimal = 0.10
	let GOODS_SERVICE_TAX:Decimal = 0.07
	
	func calculateBill(numOfPax: [Person], svcCharge: Bool, GST: Bool) -> (totalAmount: Decimal, splitByPerson: [Person]) {
		
		var totalCost:Decimal = 0.00
		var finalBill:[Person] = numOfPax
		
		for person in numOfPax {
			
			totalCost += person.amount //Find the total amount before taxes
		}
		
		let taxCost = findTaxCost(totalAmt: totalCost, serviceCharge: svcCharge, goodsServiceTax: GST)
		let taxByPerson = taxCost / Decimal(finalBill.count)
		
		for i in 0..<finalBill.count {
			
			finalBill[i].amount += taxByPerson //Split tax to each person
		}
		
		totalCost += taxCost //Calculate the total amount after taxes
		
		return (totalCost, finalBill)
	}
	
	func findTaxCost(totalAmt: Decimal, serviceCharge: Bool, goodsServiceTax: Bool) -> Decimal {
		
		var taxCost:Decimal = 0.00

		if (serviceCharge && goodsServiceTax) {
			
			taxCost = totalAmt * SERVICE_CHARGE
			taxCost = taxCost + ((totalAmt + taxCost) * GOODS_SERVICE_TAX)
		}
		else if (!serviceCharge && goodsServiceTax) {
			
			taxCost = totalAmt * GOODS_SERVICE_TAX //add GST
		}
		else {
			
			taxCost = 0.00
		}
		
		return taxCost
	}
	
//	func formatCurrency(amount: Double) -> String {
//		
//		var string = ""
//		
//		if (amount.truncatingRemainder(dividingBy: 1) == 0) {
//			
//			string = String(format: "$%.2f", amount)
//		}
//		else {
//			
//			string = String(format: "$%.2f", (amount / 100) * 100)
//		}
//		
//		return string
//	}
	
	func formatCurrency(amount: NSDecimalNumber) -> String {
		
		var string = ""
		
		let formatter = NumberFormatter()
		let usLocale = NSLocale.init(localeIdentifier: "en_US")
		formatter.minimumIntegerDigits = 1
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 3
		formatter.roundingMode = .down
		formatter.locale = usLocale as Locale!
		
		string = String(format: "$%@", formatter.string(from: amount)!)
		
		return string
	}
}

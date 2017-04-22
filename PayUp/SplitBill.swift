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
		var totalTax:Decimal = 0.00
		var bill:[Person] = numOfPax
		
		for i in 0..<bill.count {
			
			for j in 0..<bill[i].item.count {
				
				totalCost += bill[i].item[j].price //Find the total amount before taxes
				let tax = findTaxCost(individualAmt: bill[i].item[j].price, serviceCharge: svcCharge, goodsServiceTax: GST)
				bill[i].item[j].price += tax
				totalTax += tax
			}
		}
		
		totalCost += totalTax
		
		return (totalCost, bill)
	}

	func findTaxCost(individualAmt: Decimal, serviceCharge: Bool, goodsServiceTax: Bool) -> Decimal {
		
		var taxCost:Decimal = 0.00

		if (serviceCharge && goodsServiceTax) {
			
			taxCost = individualAmt * SERVICE_CHARGE
			taxCost = taxCost + ((individualAmt + taxCost) * GOODS_SERVICE_TAX)
		}
		else if (!serviceCharge && goodsServiceTax) {
			
			taxCost = individualAmt * GOODS_SERVICE_TAX //add GST
		}
		else if (serviceCharge && !goodsServiceTax) {
			
			taxCost = individualAmt * SERVICE_CHARGE
		}
		else {
			
			taxCost = 0.00
		}
		
		return taxCost
	}
	
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
	
	func displayIndividualTotal(person: [Person], section: Int) -> String {
		
		var total: Decimal = 0.00
		var string: String = ""
		
		for i in 0..<person[section].item.count {
			
			total += person[section].item[i].price
		}
		
		let formatter = NumberFormatter()
		let usLocale = NSLocale.init(localeIdentifier: "en_US")
		formatter.minimumIntegerDigits = 1
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 3
		formatter.roundingMode = .down
		formatter.locale = usLocale as Locale!
		
		string = String(format: "$%@", formatter.string(from: NSDecimalNumber(decimal: total))!)
		
		return string
	}
}

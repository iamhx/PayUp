//
//  BillSummary.swift
//  BillSplit
//
//  Created by Hongxuan on 21/3/17.
//  Copyright © 2017 hx. All rights reserved.
//

import UIKit

class cellSummary : UITableViewCell {
	
	@IBOutlet weak var lblPerson: UILabel!
	@IBOutlet weak var lblAmount: UILabel!
}

class BillSummary: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var finalBill: UITableView!
	@IBOutlet weak var lblSummary: UILabel!
	
	var billArray:[Person]?
	var totalAmount:Decimal?
	var boolSvcCharge:Bool?
	var boolGST:Bool?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		finalBill.dataSource = self
		finalBill.delegate = self
		finalBill.separatorInset = .zero
		finalBill.layoutMargins = .zero

		self.updateSummaryLabel(label: lblSummary, amount: NSDecimalNumber(decimal: totalAmount!), svcCharge: boolSvcCharge!, GST: boolGST!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return billArray!.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let name = billArray![indexPath.row].name
		let amount = billArray![indexPath.row].amount
		
		let formatter = NumberFormatter()
		let usLocale = NSLocale.init(localeIdentifier: "en_US")
		formatter.minimumIntegerDigits = 1
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 2
		formatter.roundingMode = .down
		formatter.locale = usLocale as Locale!

		let cell = tableView.dequeueReusableCell(withIdentifier: "personBill") as! cellSummary
		
		cell.lblPerson.text = name
		cell.lblAmount.text = String(format: "$%@", formatter.string(from: NSDecimalNumber(decimal: amount))!)

		return cell
	}
	
	func updateSummaryLabel(label: UILabel, amount: NSDecimalNumber, svcCharge: Bool, GST: Bool) {
		
		var targetString = ""
		let formatter = NumberFormatter()
		let usLocale = NSLocale.init(localeIdentifier: "en_US")
		formatter.minimumIntegerDigits = 1
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 2
		formatter.roundingMode = .down
		formatter.locale = usLocale as Locale!
	
		if (svcCharge && GST) {
			
			targetString = " inclusive of service charges and GST."
		}
		else if (!svcCharge && GST) {
	
			targetString = " inclusive of GST."
		}
		else {
			
			targetString = "."
		}
		
		let text = String(format: "The total bill is $%@%@", formatter.string(from: amount)!, targetString)
		
		let range = NSMakeRange(18, formatter.string(from: amount)!.characters.count + 1)
		label.attributedText = attributedString(from: text, nonBoldRange: range)
	}
	
	func attributedString(from string: String, nonBoldRange: NSRange?) -> NSAttributedString {
		
		let fontSize = lblSummary.font.pointSize
		
		let attrs = [
			NSFontAttributeName: UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightSemibold),
			NSForegroundColorAttributeName: UIColor.black
		]
		
		let nonBoldAttribute = [
			NSFontAttributeName: UIFont.systemFont(ofSize: fontSize),
			]
		let attrStr = NSMutableAttributedString(string: string, attributes: nonBoldAttribute)
		
		if let range = nonBoldRange {
			attrStr.setAttributes(attrs, range: range)
		}
		
		return attrStr
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

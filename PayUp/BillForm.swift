//
//  BillForm.swift
//  BillSplit
//
//  Created by Hongxuan on 20/3/17.
//  Copyright © 2017 hx. All rights reserved.
//

import UIKit

/*struct Person {
	
	let name : String
	var amount : Double
}*/

struct Person {
	
	let name : String
	var amount : Decimal
}

class cellPerson : UITableViewCell {
	
	@IBOutlet weak var lblPerson: UILabel!
	@IBOutlet weak var lblAmount: UILabel!
}

class BillForm: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

	
	@IBOutlet weak var lblTotal: UILabel!
	@IBOutlet weak var billTableView: UITableView!
	
	//var structArray:[Person] = []
	//var totalBeforeTax:Double = 0.00

	var structArray:[Person] = []
	var totalBeforeTax:Decimal = 0.00
	
	@IBOutlet weak var switchSvcCharge: UISwitch!
	@IBOutlet weak var switchGST: UISwitch!
	
	@IBAction func btnSplit(_ sender: UIButton) {
		
		if (structArray.count <= 0 || billTableView.numberOfRows(inSection: 0) <= 0) {
			
			let promptEmpty = UIAlertController(title: "Error", message: "You haven't added anyone to split the bill with.", preferredStyle: .alert)
			let actionOK = UIAlertAction(title: "Try Again", style: .cancel, handler: nil)
			promptEmpty.addAction(actionOK)
			
			self.present(promptEmpty, animated: true, completion: nil)
		}
			
		/*else if (structArray.count <= 1 || billTableView.numberOfRows(inSection: 0) <= 1) {
			
			let promptOnePerson = UIAlertController(title: "Error", message: "You can't split the bill with only one person.", preferredStyle: .alert)
			let actionOK = UIAlertAction(title: "Try Again", style: .cancel, handler: nil)
			promptOnePerson.addAction(actionOK)
			
			self.present(promptOnePerson, animated: true, completion: nil)
		}*/
			
		else {
			
			self.performSegue(withIdentifier: "segueSummary", sender: self)
		}
	}
	
	@IBAction func btnSvcCharge(_ sender: UISwitch) {
		
		if (switchSvcCharge.isOn) {
			
			if (!switchGST.isOn) {
				
				switchGST.setOn(true, animated: true)
			}
		}
	}
	
	@IBAction func btnGST(_ sender: UISwitch) {
		
		if (!switchGST.isOn) {
			
			if (switchSvcCharge.isOn) {
				
				switchSvcCharge.setOn(false, animated: true)
			}
		}
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		var maxLength:Int
		
		if (textField.tag == 0) {
			
			maxLength = 15
		}
		else {
			
			maxLength = 13
		}
		
		let currentString:NSString = textField.text! as NSString
		let newString = currentString.replacingCharacters(in: range, with: string) as NSString
		
		return newString.length <= maxLength
	}
	
	@IBAction func addPerson(_ sender: UIBarButtonItem) {
		
		let inputPerson = UIAlertController(title: "Add Person", message: "Enter person's name and amount.", preferredStyle: .alert)
		
		inputPerson.addTextField(configurationHandler: { (textField) -> Void in
			textField.placeholder = "Name"
			textField.textAlignment = .left
			textField.keyboardType = .default
			textField.delegate = self
			textField.tag = 0
		})
		
		inputPerson.addTextField(configurationHandler: { (textField) -> Void in
			textField.placeholder = "Amount"
			textField.textAlignment = .left
			textField.keyboardType = .decimalPad
			textField.delegate = self
			textField.tag = 1
		})
		
		let actionAddPerson = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
			
			let inputName = inputPerson.textFields![0] as UITextField
			let inputAmt = inputPerson.textFields![1] as UITextField
			
			if (inputName.text!.isEmpty || inputAmt.text!.isEmpty) {
				
				self.valError(promptInputAgain: inputPerson)
			}
				
			else {
				
				/*guard let unwrappedInput = Double(inputAmt.text!) else {
					self.valError(promptInputAgain: inputPerson)
					return
				}*/
				
				/*
				let newPerson = Person(name: inputName.text!, amount: unwrappedInput)
				self.structArray.append(newPerson)
				
				self.totalBeforeTax += self.structArray[self.structArray.count - 1].amount
				
				self.billTableView.beginUpdates()
				self.billTableView.insertRows(at: [IndexPath(row: self.structArray.count - 1, section: 0)], with: .automatic)
				self.billTableView.endUpdates()
				
				self.updateTotalLabel(label: self.lblTotal, amount: self.totalBeforeTax)*/
				
				let unwrappedInput = NSDecimalNumber.init(string: inputAmt.text!)
				
				if (unwrappedInput == NSDecimalNumber.notANumber) {
					self.valError(promptInputAgain: inputPerson)
				}
				else {
					
					let newPerson = Person(name: inputName.text!, amount: unwrappedInput.decimalValue)
					self.structArray.append(newPerson)
					
					self.totalBeforeTax += self.structArray[self.structArray.count - 1].amount
					
					self.billTableView.insertRows(at: [IndexPath(row: self.structArray.count - 1, section: 0)], with: .automatic)
					self.billTableView.endUpdates()
					
					self.updateTotalLabel(label: self.lblTotal, amount: NSDecimalNumber(decimal: self.totalBeforeTax))
				}
			}
		})
		
		let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		inputPerson.addAction(actionAddPerson)
		inputPerson.addAction(actionCancel)
		inputPerson.preferredAction = actionAddPerson
	
		self.present(inputPerson, animated: true, completion: nil)
	}
	
	func valError(promptInputAgain: UIAlertController) {
		
		let errorAlert = UIAlertController(title: "Error", message: "One or more fields is missing or invalid.", preferredStyle: .alert)
		errorAlert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: {
			alert -> Void in
			
			self.present(promptInputAgain, animated: true, completion: nil)
		}))
		
		self.present(errorAlert, animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		billTableView.delegate = self
		billTableView.dataSource = self
		billTableView.separatorInset = .zero
		billTableView.layoutMargins = .zero
		
		//updateTotalLabel(label: lblTotal, amount: totalBeforeTax)
		updateTotalLabel(label: lblTotal, amount: NSDecimalNumber(decimal: totalBeforeTax))
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
		
		return structArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "newPerson") as! cellPerson
		
//		cell.lblPerson?.text = "\(structArray[indexPath.row].name)"
//		cell.lblAmount?.text = SplitBill().formatCurrency(amount: structArray[indexPath.row].amount)
		
		cell.lblPerson?.text = "\(structArray[indexPath.row].name)"
		cell.lblAmount?.text = SplitBill().formatCurrency(amount: NSDecimalNumber(decimal: structArray[indexPath.row].amount))

		return cell
	}

	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}
	
	// Override to support editing the table view.
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
		if (editingStyle == .delete) {
			
			// Delete the row from the data source
			
			self.totalBeforeTax -= structArray[indexPath.row].amount

			billTableView.beginUpdates()
			let rowIndex = IndexPath(row: indexPath.row, section: 0)
			structArray.remove(at: indexPath.row)
			billTableView.deleteRows(at: [rowIndex], with: .fade)
			billTableView.endUpdates()
			
			//self.updateTotalLabel(label: lblTotal, amount: totalBeforeTax)
			self.updateTotalLabel(label: lblTotal, amount: NSDecimalNumber(decimal: totalBeforeTax))
		}
	}
	
	func attributedString(from string: String, nonBoldRange: NSRange?) -> NSAttributedString {
		
		let fontSize = lblTotal.font.pointSize
		
		let attrs = [
			NSFontAttributeName: UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightSemibold),
			NSForegroundColorAttributeName: UIColor.black
		]
		
		let nonBoldAttribute = [
			NSFontAttributeName: UIFont.systemFont(ofSize: fontSize),
			]
		let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
		
		if let range = nonBoldRange {
			attrStr.setAttributes(nonBoldAttribute, range: range)
		}
		
		return attrStr
	}
	
	/*func updateTotalLabel(label: UILabel, amount: Double) {
		
		var targetString = ""
		
		if (amount.truncatingRemainder(dividingBy: 1) == 0) {
			
			targetString = String(format: "Total: $%.2f", amount)
		}
		else {
			
			if (amount <= 0.00) {
				
				targetString = "$Total: $0.00"
			}
			else {
				
				targetString = String(format: "Total: $%.2f", (amount / 100) * 100)
			}
		}
		
		let range = NSMakeRange(0, 7)
		label.attributedText = attributedString(from: targetString, nonBoldRange: range)
	}*/
	
	func updateTotalLabel(label: UILabel, amount: NSDecimalNumber) {
		
		var targetString = ""
		let formatter = NumberFormatter()
		let usLocale = NSLocale.init(localeIdentifier: "en_US")
		formatter.minimumIntegerDigits = 1
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 3
		formatter.roundingMode = .down
		formatter.locale = usLocale as Locale!
		
		if (amount.decimalValue <= 0.00) {
			
			targetString = "Total: $0.00"
		}
		else {
			
			targetString = String(format: "Total: $%@", formatter.string(from: amount)!)
		}
	
		let range = NSMakeRange(0, 7)
		label.attributedText = attributedString(from: targetString, nonBoldRange: range)
	}
	
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		
		if (segue.identifier == "segueSummary") {
			
			let result = SplitBill().calculateBill(numOfPax: structArray, svcCharge: switchSvcCharge.isOn, GST: switchGST.isOn)
			let destination = segue.destination as! BillSummary
			destination.billArray = result.splitByPerson
			destination.totalAmount = result.totalAmount
			destination.boolSvcCharge = switchSvcCharge.isOn
			destination.boolGST = switchGST.isOn
		}
    }
	

}

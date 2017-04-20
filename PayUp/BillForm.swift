//
//  BillForm.swift
//  BillSplit
//
//  Created by Hongxuan on 20/3/17.
//  Copyright © 2017 hx. All rights reserved.
//

import UIKit


struct Person {
	
	let name: String
	var amount: Decimal
}

struct Person2 {
	
	let name: String
	var item: [(itemName: String, price: Decimal)]
}

class cellPerson : UITableViewCell {
	
	@IBOutlet weak var lblPerson: UILabel!
	@IBOutlet weak var lblAmount: UILabel!
}

class BillForm: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

	@IBOutlet weak var lblTotal: UILabel!
	@IBOutlet weak var billTableView: UITableView!

	var structArray:[Person] = []
	
	var pickerViewRow: Int = 0
	let pickerPerson = UIPickerView()
	let pickPerson = UIAlertController(title: "Choose Person", message: "Choose the person to add the item to.", preferredStyle: .alert)
	var structArray2: [Person2] = []
	var totalBeforeTax: Decimal = 0.00
	var controllerStyle: UIAlertControllerStyle?
	
	@IBOutlet weak var switchSvcCharge: UISwitch!
	@IBOutlet weak var switchGST: UISwitch!
	
	@IBAction func btnSplit(_ sender: UIButton) {
		
		
		if (structArray.count <= 0 || billTableView.numberOfRows(inSection: 0) <= 0) {
			
			let promptEmpty = UIAlertController(title: "Error", message: "You haven't added anyone to split the bill with.", preferredStyle: .alert)
			let actionOK = UIAlertAction(title: "Try Again", style: .cancel, handler: nil)
			promptEmpty.addAction(actionOK)
			
			self.present(promptEmpty, animated: true, completion: nil)
		}
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
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		
		if (textField.tag == 2)
		{
			textField.text = structArray2[pickerViewRow].name
		}
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		var maxLength:Int
		
		if (textField.tag == 0 || textField.tag == 2) {
			
			maxLength = 15
		}
		else {
			
			maxLength = 11
		}
		
		let currentString:NSString = textField.text! as NSString
		let newString = currentString.replacingCharacters(in: range, with: string) as NSString
		
		return newString.length <= maxLength
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return structArray2.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return structArray2[row].name
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		pickerViewRow = row
		let myTextField = pickPerson.view.viewWithTag(2) as! UITextField
		myTextField.text = structArray2[row].name
		print(pickerViewRow)
	}
	
	@IBAction func chooseOption(_ sender: UIBarButtonItem) {
		
		//let inputPerson = UIAlertController(title: "Add Person", message: "Enter person's name and amount.", preferredStyle: .alert)
		let chooseOption = UIAlertController(title: "Choose an option", message: "", preferredStyle: .alert)
		let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

		
		/*inputPerson.addTextField(configurationHandler: { (textField) -> Void in
			textField.placeholder = "Name"
			textField.textAlignment = .left
			textField.keyboardType = .default
			textField.delegate = self
			textField.tag = 0
		})*/
		
		/*inputPerson.addTextField(configurationHandler: { (textField) -> Void in
			textField.placeholder = "Amount"
			textField.textAlignment = .left
			textField.keyboardType = .decimalPad
			textField.delegate = self
			textField.tag = 1
		})*/
		
		/*let actionAddPerson = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
			
			let inputName = inputPerson.textFields![0] as UITextField
			let inputAmt = inputPerson.textFields![1] as UITextField
			
			if (inputName.text!.isEmpty || inputAmt.text!.isEmpty) {
				
				self.valError(promptInputAgain: inputPerson)
			}
			else {
				
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
		})*/
		
		let chooseAddPerson = UIAlertAction(title: "Add Person", style: .default, handler: { alert -> Void in
			
			let inputPerson = UIAlertController(title: "Add Person", message: "Enter the name of the person.", preferredStyle: .alert)
			
			inputPerson.addTextField(configurationHandler: { (textField) -> Void in
				textField.placeholder = "Name"
				textField.textAlignment = .left
				textField.keyboardType = .default
				textField.delegate = self
				textField.tag = 0
			})
			
			let actionAddPerson = UIAlertAction(title: "Add", style: .default, handler: { action in
				
				let inputName = inputPerson.textFields![0] as UITextField
				
				if (inputName.text!.isEmpty) {
					
					self.valError(promptInputAgain: inputPerson)
				}
				else {
					
					let newPerson = Person2(name: inputName.text!, item: [])
					self.structArray2.append(newPerson)
					
					//self.billTableView.insertRows(at: [IndexPath(row: self.structArray2.count - 1, section: 0)], with: .automatic)
					//self.billTableView.endUpdates()
					print(self.structArray2[self.structArray2.count - 1])
				}
			})
			
			inputPerson.addAction(actionAddPerson)
			inputPerson.addAction(actionCancel)
			self.present(inputPerson, animated: true, completion: nil)
		})

		
		let chooseAddItem = UIAlertAction(title: "Add Item", style: .default, handler: { action in

//			let pickPerson = UIAlertController(title: "Choose Person", message: "Choose the person to add the item to.", preferredStyle: .alert)
			
			self.pickPerson.addTextField(configurationHandler: { (textField) -> Void in
				textField.placeholder = "Choose a Person"
				textField.textAlignment = .left
				textField.inputView = self.pickerPerson
				textField.delegate = self
				textField.tag = 2
			})
			
			let choosePerson = UIAlertAction(title: "Choose", style: .default, handler: { action in
			
				let inputItem = UIAlertController(title: "Add Item", message: "Enter the item's name, price and choose the person to add to.", preferredStyle: .alert)
				
				inputItem.addTextField(configurationHandler: { (textField) -> Void in
					textField.placeholder = "Item Name"
					textField.textAlignment = .left
					textField.keyboardType = .default
					textField.delegate = self
					textField.tag = 0
				})
				
				inputItem.addTextField(configurationHandler: { (textField) -> Void in
					textField.placeholder = "Price"
					textField.textAlignment = .left
					textField.keyboardType = .decimalPad
					textField.delegate = self
					textField.tag = 1
				})
				
				let actionAddItem = UIAlertAction(title: "Add", style: .default, handler: { action in
					
					let inputItemName = inputItem.textFields![0] as UITextField
					let inputPrice = inputItem.textFields![1] as UITextField
					
					if (inputItemName.text!.isEmpty || inputPrice.text!.isEmpty) {
						
						self.valError(promptInputAgain: inputItem)
					}
					else {
						
						let unwrappedInput = NSDecimalNumber.init(string: inputPrice.text!)
						
						if (unwrappedInput == NSDecimalNumber.notANumber) {
							self.valError(promptInputAgain: inputItem)
						}
						else {
							
							self.structArray2[self.pickerViewRow].item.append((itemName: inputItemName.text!, price: unwrappedInput.decimalValue))
							
							//self.totalBeforeTax += self.structArray2[self.pickerViewRow!].item[self.pickerViewRow!].price!
							
							//self.billTableView.insertRows(at: [IndexPath(row: self.structArray.count - 1, section: 0)], with: .automatic)
							//self.billTableView.endUpdates()
							//self.updateTotalLabel(label: self.lblTotal, amount: NSDecimalNumber(decimal: self.totalBeforeTax))
							print(self.structArray2)

						}
					}
				})
				
				inputItem.addAction(actionAddItem)
				inputItem.addAction(actionCancel)
				self.present(inputItem, animated: true, completion: nil)
			})
			
			self.pickPerson.addAction(choosePerson)
			self.pickPerson.addAction(actionCancel)
			self.present(self.pickPerson, animated: true, completion: nil)
		})
		
		//inputPerson.addAction(actionAddPerson)
		//inputPerson.addAction(actionCancel)
		//inputPerson.preferredAction = actionAddPerson
	
		//self.present(inputPerson, animated: true, completion: nil)
		
		
		if (self.structArray2.count <= 0) {
			
			chooseOption.addAction(chooseAddPerson)
		}
		else {
			
			chooseOption.addAction(chooseAddPerson)
			chooseOption.addAction(chooseAddItem)

		}
		
		chooseOption.addAction(actionCancel)
		self.present(chooseOption, animated: true, completion: nil)
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
		
		//self.navigationController?.navigationBar.isTranslucent = false
		//self.navigationController?.navigationBar.barTintColor = UIColor(red: 255.0/255.0, green: 147.0/255.0, blue: 44.0/255.0, alpha: 1.0)
		
		if ( UI_USER_INTERFACE_IDIOM() == .pad )
		{
			controllerStyle = .alert
		}
		else {
			controllerStyle = .actionSheet
		}
		
		billTableView.delegate = self
		billTableView.dataSource = self
		pickerPerson.delegate = self
		pickerPerson.delegate = self
		billTableView.separatorInset = .zero
		billTableView.layoutMargins = .zero
		
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
	
	@IBAction func btnMainMenu(_ sender: UIBarButtonItem) {
		
		let promptAlert = UIAlertController(title: "", message: "Do you want to return back to the main menu? All changes made will not be saved.", preferredStyle: controllerStyle!)
		let yesAction = UIAlertAction(title: "Return to main menu", style: .destructive) { action in
			
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let rootVC = storyboard.instantiateViewController(withIdentifier: "mainRootViewController")
			self.present(rootVC, animated: true, completion: nil)
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		promptAlert.addAction(yesAction)
		promptAlert.addAction(cancelAction)
		
		self.present(promptAlert, animated: true, completion: nil)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "newPerson") as! cellPerson
		
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

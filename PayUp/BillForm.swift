//
//  BillForm.swift
//  BillSplit
//
//  Created by Hongxuan on 20/3/17.
//  Copyright © 2017 hx. All rights reserved.
//

import UIKit

protocol CollapsibleTableViewHeaderDelegate {
	
	func toggleSection(_ header: TableSectionHeader, section: Int)
}

extension BillForm: CollapsibleTableViewHeaderDelegate {
	
	func toggleSection(_ header: TableSectionHeader, section: Int) {
		
		let collapsed = !structArray[section].collapsed
		
		// Toggle collapse
		structArray[section].collapsed = collapsed
		
		// Adjust the height of the rows inside the section
		billTableView.beginUpdates()
		for i in 0 ..< structArray[section].item.count {
			
			billTableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
		}
		
		billTableView.endUpdates()
	}
}

struct Person {
	
	let name: String
	var item: [(itemName: String, price: Decimal)]
	var collapsed: Bool!
	
	init(name: String, item: [(itemName: String, price: Decimal)], collapsed: Bool = false) {
		self.name = name
		self.item = item
		self.collapsed = collapsed
	}
}

class cellPersonItem : UITableViewCell {
	
	@IBOutlet weak var lblItem: UILabel!
	@IBOutlet weak var lblPrice: UILabel!
}

class TableSectionHeader : UITableViewHeaderFooterView {
	
	var delegate: CollapsibleTableViewHeaderDelegate?
	var section: Int = 0
	
	@IBOutlet weak var lblPerson: UILabel!
	@IBOutlet weak var lblTotal: UILabel!
	
	func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
		
		guard let cell = gestureRecognizer.view as? TableSectionHeader else {
			return
		}
		
		delegate?.toggleSection(self, section: cell.section)
	}
}

class BillForm: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

	@IBOutlet weak var lblTotal: UILabel!
	@IBOutlet weak var billTableView: UITableView!
	
	var launchOnce : Bool = false
	let pickerPerson = UIPickerView()
	var pickPersonRef: UIAlertController?
	var structArray: [Person] = []
	var totalBeforeTax: Decimal = 0.00
	var controllerStyle: UIAlertControllerStyle?
	
	@IBOutlet weak var switchSvcCharge: UISwitch!
	@IBOutlet weak var switchGST: UISwitch!
	
	@IBAction func btnSplit(_ sender: UIButton) {
		
		if (structArray.count <= 0 || billTableView.numberOfSections <= 0) {
			
			let promptEmpty = UIAlertController(title: "Error", message: "You haven't added anyone to split the bill with.", preferredStyle: .alert)
			let actionOK = UIAlertAction(title: "Try Again", style: .cancel, handler: nil)
			promptEmpty.addAction(actionOK)
			
			self.present(promptEmpty, animated: true, completion: nil)
		}
		else {
			
			self.performSegue(withIdentifier: "segueSummary", sender: self)
		}
	}
	
	/*@IBAction func btnSvcCharge(_ sender: UISwitch) {
		
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
	}*/
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		
		if (textField.tag == 2)
		{
			textField.text = structArray[pickerPerson.selectedRow(inComponent: 0)].name
		}
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		var maxLength:Int
		
		if (textField.tag == 5) {
	
			maxLength = 11
		}
		else {
			
			maxLength = 50
		}
		
		let currentString:NSString = textField.text! as NSString
		let newString = currentString.replacingCharacters(in: range, with: string) as NSString
		
		return newString.length <= maxLength
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
		return structArray.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		return structArray[row].name
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		let myTextField = pickPersonRef?.view.viewWithTag(2) as! UITextField
		myTextField.text = structArray[row].name
	}
	
	@IBAction func chooseOption(_ sender: UIBarButtonItem) {
		
		let chooseOption = UIAlertController(title: "Choose an option", message: "", preferredStyle: .alert)
		let pickPerson = UIAlertController(title: "Choose Person", message: "Choose the person to add the item to.", preferredStyle: .alert)
		
		pickPerson.addTextField(configurationHandler: { (textField) -> Void in
			
			textField.placeholder = "Choose a Person"
			textField.textAlignment = .left
			textField.inputView = self.pickerPerson
			textField.delegate = self
			textField.tag = 2
		})

		let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

		let chooseAddPerson = UIAlertAction(title: "Add Person", style: .default, handler: { alert -> Void in
			
			let inputPerson = UIAlertController(title: "Add Person", message: "Enter the name of the person.", preferredStyle: .alert)
			
			inputPerson.addTextField(configurationHandler: { (textField) -> Void in
				textField.placeholder = "Name"
				textField.textAlignment = .left
				textField.keyboardType = .default
				textField.delegate = self
				textField.tag = 1
			})
			
			let actionAddPerson = UIAlertAction(title: "Add", style: .default, handler: { action in
				
				let inputName = inputPerson.textFields![0] as UITextField
				
				if (inputName.text!.isEmpty) {
					
					self.valError(promptInputAgain: inputPerson)
				}
				else {
					
					let helpView = self.view.viewWithTag(4)
					helpView?.removeFromSuperview()
					
					let newPerson = Person(name: inputName.text!, item: [])
					
					self.structArray.append(newPerson)
					
					self.billTableView.insertSections(IndexSet(integer: (self.structArray.count - 1)), with: .automatic)
				}
			})
			
			inputPerson.addAction(actionAddPerson)
			inputPerson.addAction(actionCancel)
			self.present(inputPerson, animated: true, completion: nil)
		})
		
		let chooseAddItem = UIAlertAction(title: "Add Item", style: .default, handler: { action in

			let pickPerson = UIAlertController(title: "Choose Person", message: "Choose the person to add the item to.", preferredStyle: .alert)
			
			pickPerson.addTextField(configurationHandler: { (textField) -> Void in
				textField.placeholder = "Choose a Person"
				textField.textAlignment = .left
				textField.inputView = self.pickerPerson
				textField.delegate = self
				textField.tag = 2
			})
			
			let choosePerson = UIAlertAction(title: "Choose", style: .default, handler: { action in
				
				let inputItem = UIAlertController(title: "Add Item", message: "Enter the item's name and price.", preferredStyle: .alert)
				
				inputItem.addTextField(configurationHandler: { (textField) -> Void in
					textField.placeholder = "Item Name"
					textField.textAlignment = .left
					textField.keyboardType = .default
					textField.delegate = self
					textField.tag = 3
				})
				
				inputItem.addTextField(configurationHandler: { (textField) -> Void in
					textField.placeholder = "Price"
					textField.textAlignment = .left
					textField.keyboardType = .decimalPad
					textField.delegate = self
					textField.tag = 5
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
							
							self.structArray[self.pickerPerson.selectedRow(inComponent: 0)].item.append((itemName: inputItemName.text!, price: unwrappedInput.decimalValue))
							
							self.totalBeforeTax += unwrappedInput.decimalValue
							self.billTableView.insertRows(at: [IndexPath(row: self.structArray[self.pickerPerson.selectedRow(inComponent: 0)].item.count - 1, section: self.pickerPerson.selectedRow(inComponent: 0))], with: .automatic)
							let header = self.billTableView.headerView(forSection: self.pickerPerson.selectedRow(inComponent: 0)) as! TableSectionHeader
							header.lblTotal.text = "\(SplitBill().displayIndividualTotal(person: self.structArray, section: self.pickerPerson.selectedRow(inComponent: 0)))"
							
							self.updateTotalLabel(label: self.lblTotal, amount: NSDecimalNumber(decimal: self.totalBeforeTax))
						}
					}
				})
				
				inputItem.addAction(actionAddItem)
				inputItem.addAction(actionCancel)
				self.present(inputItem, animated: true, completion: nil)
			})
			
			pickPerson.addAction(choosePerson)
			pickPerson.addAction(actionCancel)
			self.pickPersonRef = pickPerson
			self.present(pickPerson, animated: true, completion: nil)
		})
		
		let chooseRemovePerson = UIAlertAction(title: "Remove Person", style: .destructive, handler: { action in
			
			let pickPerson = UIAlertController(title: "Choose Person", message: "Choose the person to remove.", preferredStyle: .alert)
			
			pickPerson.addTextField(configurationHandler: { (textField) -> Void in
				textField.placeholder = "Choose a Person"
				textField.textAlignment = .left
				textField.inputView = self.pickerPerson
				textField.delegate = self
				textField.tag = 2
			})
			
			let choosePerson = UIAlertAction(title: "Remove", style: .destructive, handler: { action in
				
				var individualTotal: Decimal = 0.00
				
				for i in 0..<self.structArray[self.pickerPerson.selectedRow(inComponent: 0)].item.count {
					
					individualTotal += self.structArray[self.pickerPerson.selectedRow(inComponent: 0)].item[i].price
				}
				
				for i in (0..<self.structArray[self.pickerPerson.selectedRow(inComponent: 0)].item.count).reversed() {
					
					let rowIndex = IndexPath(row: i, section: self.pickerPerson.selectedRow(inComponent: 0))
					self.structArray[self.pickerPerson.selectedRow(inComponent: 0)].item.remove(at: i)
					self.billTableView.deleteRows(at: [rowIndex], with: .right)
				}
				
				self.totalBeforeTax -= individualTotal
				self.updateTotalLabel(label: self.lblTotal, amount: NSDecimalNumber(decimal: self.totalBeforeTax))
				self.structArray.remove(at: self.pickerPerson.selectedRow(inComponent: 0))
				self.billTableView.deleteSections(IndexSet(integer: self.pickerPerson.selectedRow(inComponent: 0)), with: .right)
				
				if (self.structArray.count > 0) {
				
					let indexSet = IndexSet(integer: self.structArray.count - 1)
					self.billTableView.reloadSections(indexSet, with: .automatic)
				}
				self.pickerPerson.reloadAllComponents()
			})
			
			pickPerson.addAction(choosePerson)
			pickPerson.addAction(actionCancel)
			self.pickPersonRef = pickPerson
			self.present(pickPerson, animated: true, completion: nil)
		})
		
		if (self.structArray.count <= 0) {
			
			chooseOption.addAction(chooseAddPerson)
		}
		else {
			
			chooseOption.addAction(chooseAddPerson)
			chooseOption.addAction(chooseAddItem)
			chooseOption.addAction(chooseRemovePerson)
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
		
		let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
		billTableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
		
		billTableView.delegate = self
		billTableView.dataSource = self
		pickerPerson.delegate = self
		pickerPerson.delegate = self
		billTableView.separatorInset = .zero
		billTableView.layoutMargins = .zero
		
		updateTotalLabel(label: lblTotal, amount: NSDecimalNumber(decimal: totalBeforeTax))
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if (launchOnce == false) {
			
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let HelpVC = storyboard.instantiateViewController(withIdentifier: "HelpID")
			self.addChildViewController(HelpVC)
			HelpVC.view.frame = self.view.bounds
			self.view.addSubview(HelpVC.view)
			HelpVC.didMove(toParentViewController: self)
			launchOnce = true
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		
		return structArray.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		
		return structArray[section].item.count
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
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "newPersonItem") as! cellPersonItem
		
		cell.lblItem?.text = "\(structArray[indexPath.section].item[indexPath.row].itemName)"
		cell.lblPrice?.text = SplitBill().formatCurrency(amount: NSDecimalNumber(decimal: structArray[indexPath.section].item[indexPath.row].price))
		
		return cell
	}

	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		

		let cell = billTableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader")
		let header = cell as! TableSectionHeader
		
		header.section = section
		header.delegate = self
		header.lblPerson.text = structArray[section].name
		header.lblTotal.text = SplitBill().displayIndividualTotal(person: structArray, section: section)
		header.addGestureRecognizer(UITapGestureRecognizer(target: header.self, action: #selector(header.tapHeader(_:))))
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		return structArray[indexPath.section].collapsed! ? 0 : 44.0
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		
		return 44
	}
	
	// Override to support editing the table view.
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
		if (editingStyle == .delete) {
			
			// Delete the row from the data source
			
			self.totalBeforeTax -= structArray[indexPath.section].item[indexPath.row].price

			let rowIndex = IndexPath(row: indexPath.row, section: indexPath.section)
			structArray[indexPath.section].item.remove(at: indexPath.row)
			billTableView.deleteRows(at: [rowIndex], with: .fade)
			
			let header = self.billTableView.headerView(forSection: indexPath.section) as! TableSectionHeader
			header.lblTotal.text = "\(SplitBill().displayIndividualTotal(person: self.structArray, section: indexPath.section))"
			
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

//
//  BillForm.swift
//  BillSplit
//
//  Created by Hongxuan on 20/3/17.
//  Copyright © 2017 hx. All rights reserved.
//

import UIKit

struct Person {
	
	let name : String
	var amount : Double
}

class CustomCell : UITableViewCell {
	
	@IBOutlet weak var lblPerson: UILabel!
	@IBOutlet weak var lblAmount: UILabel!
}

class BillForm: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var billTableView: UITableView!
	var structArray:[Person] = []
	
	@IBOutlet weak var switchSvcCharge: UISwitch!
	@IBOutlet weak var switchGST: UISwitch!
	
	@IBAction func btnSplit(_ sender: UIButton) {
		
		if (structArray.count <= 0 || billTableView.numberOfRows(inSection: 0) <= 0) {
			
			let promptEmpty = UIAlertController(title: "Error", message: "You haven't added anyone to split the bill with.", preferredStyle: .alert)
			let actionOK = UIAlertAction(title: "Try Again", style: .cancel, handler: nil)
			promptEmpty.addAction(actionOK)
			
			self.present(promptEmpty, animated: true, completion: nil)
		}
			
		else if (structArray.count <= 1 || billTableView.numberOfRows(inSection: 0) <= 1) {
			
			let promptOnePerson = UIAlertController(title: "Error", message: "You can't split the bill with only one person.", preferredStyle: .alert)
			let actionOK = UIAlertAction(title: "Try Again", style: .cancel, handler: nil)
			promptOnePerson.addAction(actionOK)
			
			self.present(promptOnePerson, animated: true, completion: nil)
		}
			
		else {
			
			let result = SplitBill().calculateBill(numOfPax: structArray, svcCharge: switchSvcCharge.isOn, GST: switchGST.isOn)
			
			for this in result.splitByPerson {
				print("\(this.name), \(this.amount)")
			}
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
	
	@IBAction func addPerson(_ sender: UIBarButtonItem) {
		
		let inputPerson = UIAlertController(title: "Add Person", message: "Enter person's name and amount.", preferredStyle: .alert)
		
		inputPerson.addTextField(configurationHandler: { (textField) -> Void in
			textField.placeholder = "Name"
			textField.textAlignment = .left
			textField.keyboardType = .default
		})
		
		inputPerson.addTextField(configurationHandler: { (textField) -> Void in
			textField.placeholder = "Amount"
			textField.textAlignment = .left
			textField.keyboardType = .decimalPad
		})
		
		let actionAddPerson = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
			
			let inputName = inputPerson.textFields![0] as UITextField
			let inputAmt = inputPerson.textFields![1] as UITextField
			
			if (inputName.text!.isEmpty || inputAmt.text!.isEmpty) {
				
				self.valError(promptInputAgain: inputPerson)
			}
				
			else {
				
				guard let wrappedInput = Double(inputAmt.text!) else {
					self.valError(promptInputAgain: inputPerson)
					return
				}
				
				let newPerson = Person(name: inputName.text!, amount: wrappedInput)
				
				self.structArray.append(newPerson)
				self.billTableView.beginUpdates()
				self.billTableView.insertRows(at: [IndexPath(row: self.structArray.count - 1, section: 0)], with: .automatic)
				self.billTableView.endUpdates()
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
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "newPerson") as! CustomCell
		
		cell.lblPerson?.text = "\(structArray[indexPath.row].name)"
		
		if (structArray[indexPath.row].amount.truncatingRemainder(dividingBy: 1) == 0) {
			cell.lblAmount?.text = String(format: "$%.2f", structArray[indexPath.row].amount)
		}
		else {
			
			cell.lblAmount?.text = "$\(structArray[indexPath.row].amount)"
		}
		
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
			billTableView.beginUpdates()
			let rowIndex = IndexPath(row: indexPath.row, section: 0)
			structArray.remove(at: indexPath.row)
			billTableView.deleteRows(at: [rowIndex], with: .fade)
			billTableView.endUpdates()
		}
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
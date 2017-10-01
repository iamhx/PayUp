//
//  BillViewController.swift
//  PayUp
//
//  Created by Hongxuan on 27/9/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit


// MARK: - BillViewController Class

class BillViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, BillTableCellDelegate, BillTableSectionDelegate {

	
	//MARK: - TextField Toolbar properties
	
	@IBOutlet var txtFieldToolBar: UIToolbar!
	
	
	@IBAction func btnDone(_ sender: Any) {
		
		view.endEditing(true)
	}
	
	
	//MARK: - View Controller properties
	@IBOutlet weak var billTableView: UITableView!
	var bill = [Person]()
	
	
	//MARK: - viewDidLoad Implementation
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		self.hideKeyboardWhenTappedAround()
		let nib = UINib(nibName: "BillTableSection", bundle: nil)
		billTableView.register(nib, forHeaderFooterViewReuseIdentifier: "BillTableSection")
		
		//Instantiate initial person
		bill.append(Person(name: ""))
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - TableView delegates
	
	func numberOfSections(in tableView: UITableView) -> Int {
		
		return bill.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return bill[section].items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! BillTableCell
		cell.txtName.delegate = self
		cell.txtPrice.delegate = self
		
		cell.delegate = self
		cell.indexPath = indexPath
		
		cell.txtName.text = bill[indexPath.section].items[indexPath.row].itemName
		cell.txtPrice.text = formatCurrency(bill[indexPath.section].items[indexPath.row].itemPrice)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		
		let cell = billTableView.dequeueReusableHeaderFooterView(withIdentifier: "BillTableSection")
		
		let header = cell as! BillTableSection
		header.section = section
		header.delegate = self
		header.txtName.delegate = self
		header.txtName.text = bill[section].name
		
		//Encrypt section into tag by multiplying 100
		header.btnAddItem.tag = section * 100
		header.btnAddItem.addTarget(self, action: #selector(addItemToRow(_:)), for: .touchUpInside)
		header.txtName.tag = section * 100
		
		//Add gesture for toggle collapse
		header.addGestureRecognizer(UITapGestureRecognizer(target: header.self, action: #selector(header.tapHeader(_:))))
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		return bill[indexPath.section].collapsed! ? 0 : 44.0
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		
		return 44.0
	}
	
	//MARK: - Custom Delegates
	
	func updateItemName(_ cell: BillTableCell) {
		
		let indexPath = cell.indexPath!
		bill[indexPath.section].items[indexPath.row].itemName = cell.txtName.text!
	}
	
	func updateItemPrice(_ cell: BillTableCell) {
		
		if (cell.txtPrice.text!.isEmpty) {
			
			cell.txtPrice.text! = "0.00"
		}
		
		guard let price = Decimal(string: cell.txtPrice.text!) else {
			
			cell.txtPrice.text = "$0.00"

			let errorAlert = UIAlertController(title: "Error", message: "Please enter a valid price.", preferredStyle: .alert)
			errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			
			self.present(errorAlert, animated: true, completion: nil)
			
			return
		}
		
		let indexPath = cell.indexPath!
		bill[indexPath.section].items[indexPath.row].itemPrice = price
		cell.txtPrice.text = formatCurrency(price)
		print(bill[indexPath.section].items[indexPath.row].itemPrice)
	}
	
	func toggleSection(_ header: BillTableSection, section: Int) {
		
		let collapsed = !bill[section].collapsed
		
		//Toggle collapse
		bill[section].collapsed = collapsed
		
		// Adjust the height of the rows inside the section
		reloadRows(section)
	}
	
	func updatePersonName (_ header: BillTableSection) {
		
		let section = header.txtName.tag / 100
		
		bill[section].name = header.txtName.text!
	}
	
	// MARK: - Actions
	
	@IBAction func addPerson(_ sender: Any) {
		
		let person = Person(name: "")
		bill.append(person)
		
		billTableView.insertSections(IndexSet(integer: (bill.count - 1)), with: .automatic)
	}
	
	func addItemToRow(_ sender: UIButton) {
		
		//Decrypt tag to get section
		let section = sender.tag / 100
		
		let item = Item(itemName: "", itemPrice: 0.00)
		bill[section].items.append(item)
		
		billTableView.insertRows(at: [IndexPath(row: bill[section].items.count - 1, section: section)], with: .automatic)
		
		if (bill[section].collapsed) {
			
			bill[section].collapsed = false
			reloadRows(section)
		}
	}
	
	func reloadRows(_ section: Int) {
		
		billTableView.beginUpdates()
		for i in 0 ..< bill[section].items.count {
			
			billTableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
		}
		
		billTableView.endUpdates()
	}
	
	func formatCurrency(_ amount: Decimal) -> String {
		
		var string = ""
		
		let formatter = NumberFormatter()
		let usLocale = Locale.init(identifier: "en_US")
		formatter.minimumIntegerDigits = 1
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 3
		formatter.roundingMode = .down
		formatter.locale = usLocale
		
		string = String(format: "$%@", formatter.string(from: NSDecimalNumber(decimal: amount))!)
		return string
	}
	
	// MARK: - TextField Delegates
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		
		textField.inputAccessoryView = txtFieldToolBar
		
		return true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		textField.resignFirstResponder()

		return true
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

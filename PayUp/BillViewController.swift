//
//  BillViewController.swift
//  PayUp
//
//  Created by Hongxuan on 27/9/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit


// MARK: - BillViewController Class

class BillViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, BillTableCellDelegate, BillTableSectionDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

	
	//MARK: - IBOutlets
	
	@IBOutlet var txtFieldToolBar: UIToolbar!
	@IBOutlet weak var backOutlet: UIBarButtonItem!
	@IBOutlet weak var forwardOutlet: UIBarButtonItem!
	@IBOutlet weak var billTableView: UITableView!
	@IBOutlet weak var bottomToolbar: UIToolbar!
	
	
	//MARK: - IBActions
	
	@IBAction func btnDone(_ sender: Any) {
		
		view.endEditing(true)
	}
	
	@IBAction func btnBack(_ sender: Any) {
		
		guard let cell = billTableView.cellForRow(at: toolBarIndexPath!) as? BillTableCell else {
			
			//Scroll to row if cell is not visible
			billTableView.scrollToRow(at: toolBarIndexPath!, at: .none, animated: false)
			let cell = billTableView.cellForRow(at: toolBarIndexPath!) as! BillTableCell
			cell.txtName.becomeFirstResponder()
			return
		}
		
		cell.txtName.becomeFirstResponder()
	}
	
	@IBAction func btnForward(_ sender: Any) {
		
		guard let cell = billTableView.cellForRow(at: toolBarIndexPath!) as? BillTableCell else {
			
			//Scroll to row if cell is not visible
			billTableView.scrollToRow(at: toolBarIndexPath!, at: .none, animated: false)
			let cell = billTableView.cellForRow(at: toolBarIndexPath!) as! BillTableCell
			cell.txtPrice.becomeFirstResponder()
			return
		}
		
		cell.txtPrice.becomeFirstResponder()
	}
	
	//MARK: - View Controller properties
	
	let btnEdit = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(toolBarEditingMode))
	let btnDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(toolBarNotEditingMode))
	let btnAdd = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addPerson))
	let btnRemovePerson = UIBarButtonItem(title: "Remove Person", style: UIBarButtonItemStyle.plain, target: self, action: #selector(removePerson))
	let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
	
	let pickerViewToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 375, height: 44))
	let personPickerView = UIPickerView()
	let btnCancel = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnDone(_:)))
	let btnChoose = UIBarButtonItem(title: "Remove", style: UIBarButtonItemStyle.done, target: self, action: #selector(choose))
	
	var bill = [Person]()
	var toolBarIndexPath : IndexPath?
	var keyboardIsShowing : Bool = false
	
	//MARK: - viewDidLoad Implementation
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		self.hideKeyboardWhenTappedAround()
		let nib = UINib(nibName: "BillTableSection", bundle: nil)
		billTableView.register(nib, forHeaderFooterViewReuseIdentifier: "BillTableSection")
		personPickerView.dataSource = self
		personPickerView.delegate = self
		personPickerView.showsSelectionIndicator = true
		
		//Instantiate initial person
		bill.append(Person(name: ""))
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardDidShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardDidHide, object: nil)
		
		btnRemovePerson.tintColor = .red
		btnChoose.tintColor = .red
		toolBarNotEditingMode()
		self.title = "$0.00"
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	deinit {
		
		NotificationCenter.default.removeObserver(self)
	}
	
	// MARK: - TableView delegates
	
	
		// MARK: Required delegate functions
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return bill[section].items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! BillTableCell
		cell.txtName.delegate = self
		cell.txtPrice.delegate = self
		//cell.txtName.tag = 1
		cell.txtPrice.tag = 2
		
		cell.delegate = self
		cell.indexPath = indexPath
		
		//Disable editing of textfields if billTableView is in editing state
		if (billTableView.isEditing) {
			
			cell.txtName.isEnabled = false
			cell.txtPrice.isEnabled = false
		}
		else {
			
			cell.txtName.isEnabled = true
			cell.txtPrice.isEnabled = true
		}
		
		cell.txtName.text = bill[indexPath.section].items[indexPath.row].itemName
		cell.txtPrice.text = formatCurrency(bill[indexPath.section].items[indexPath.row].itemPrice)
		
		resetPriceFieldIfZero(cell.txtPrice)
		
		return cell
	}

	
		// MARK: Editing style
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
		if (editingStyle == .delete) {
			
			let rowIndex = IndexPath(row: indexPath.row, section: indexPath.section)

			//Remove selected item from data, then delete row from tableView
			bill[indexPath.section].items.remove(at: indexPath.row)
			billTableView.deleteRows(at: [rowIndex], with: .fade)
			
			if let header = billTableView.headerView(forSection: indexPath.section) as? BillTableSection {
				
				header.lblPrice.text = formatCurrency(displayIndividualTotal(section: indexPath.section))
			}
			
			self.title = formatCurrency(Bill.getTotalPrice(bill))
			
			//Reset indexPath only if tableView is not editing
			if (!billTableView.isEditing) {
				
				for i in 0 ..< bill.count {
					
					for j in 0 ..< bill[i].items.count {
						
						let indexPath = IndexPath(row: j, section: i)
						
						if let cell = billTableView.cellForRow(at: indexPath) as? BillTableCell {
							
							cell.indexPath = indexPath
						}
					}
				}
			}
		}
	}
	
	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		
		let rowToMove = bill[sourceIndexPath.section].items[sourceIndexPath.row]
		
		//Remove selected item from data and insert to chosen path (No need to reset indexPath)
		bill[sourceIndexPath.section].items.remove(at: sourceIndexPath.row)
		bill[destinationIndexPath.section].items.insert(rowToMove, at: destinationIndexPath.row)
		
		if let header = tableView.headerView(forSection: sourceIndexPath.section) as? BillTableSection {
			
			header.lblPrice.text = formatCurrency(displayIndividualTotal(section: sourceIndexPath.section))
		}

		if let header = tableView.headerView(forSection: destinationIndexPath.section) as? BillTableSection {
			
			header.lblPrice.text = formatCurrency(displayIndividualTotal(section: destinationIndexPath.section))
		}
	}
	
	
		// MARK: Header properties
	
	func numberOfSections(in tableView: UITableView) -> Int {
		
		return bill.count
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		let header = billTableView.dequeueReusableHeaderFooterView(withIdentifier: "BillTableSection") as! BillTableSection
		
		header.section = section
		header.delegate = self
		header.txtName.delegate = self
		header.txtName.text = bill[section].name
		header.lblPrice.adjustsFontSizeToFitWidth = true
		header.lblPrice.minimumScaleFactor = 14.0 / UIFont.labelFontSize
		header.lblPrice.text = formatCurrency(displayIndividualTotal(section: section))
		
		if (bill[section].collapsed) {
			
			header.expandOrCollapse.image = UIImage(named: "expand")
		}
		else {
			
			header.expandOrCollapse.image = UIImage(named: "collapse")
		}
		
		//Encrypt section into tag by multiplying 100
		header.btnAddItem.tag = section * 100
		header.txtName.tag = section * 100
		
		header.btnAddItem.addTarget(self, action: #selector(addItemToRow(_:)), for: .touchUpInside)
		
		//Add gesture for toggle collapse
		header.addGestureRecognizer(UITapGestureRecognizer(target: header.self, action: #selector(header.tapHeader(_:))))

		if (billTableView.isEditing) {
			
			header.gestureRecognizers?.removeAll()
		}
		
		return header
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		return (bill[indexPath.section].collapsed!) ? 0 : 44.0
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		
		return 44.0
	}
	
	//MARK: - PickerView Delegates
	
		//MARK: Required delegate functions
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
		return bill.count
	}
	
		//MARK: Title properties
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		var name = bill[row].name
		
		if (name.isEmpty) {
			
			name = "Person \(row + 1)"
		}
		
		return  "(\(formatCurrency(displayIndividualTotal(section: row)))) \(name)"
	}
	
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		
		var textUIView = view as? UILabel
		
		if (textUIView == nil) {
			
			textUIView = UILabel()
			textUIView?.textAlignment = .center
			textUIView?.adjustsFontSizeToFitWidth = true
			textUIView?.minimumScaleFactor = 17.0 / UIFont.labelFontSize
			
			// Setup label properties - frame, font, colors etc
		}
		
		textUIView?.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
		
		//Add any logic you want here
		
		return textUIView!
	}
	
	//MARK: - Custom Delegates
	
		//MARK: Updating object array properties
	
	func updatePersonName (_ header: BillTableSection) {
		
		//Decrypt tag to get section
		let section = header.txtName.tag / 100
		
		bill[section].name = header.txtName.text!
	}
	
	func updateItemName(_ cell: BillTableCell) {
		
		let indexPath = cell.indexPath!
		bill[indexPath.section].items[indexPath.row].itemName = cell.txtName.text!
	}
	
	func updateItemPrice(_ cell: BillTableCell) {
		
		let indexPath = cell.indexPath!
		
		if (cell.txtPrice.text!.isEmpty) {
			
			cell.txtPrice.text! = "0.00"
		}
		
		guard let price = Decimal(string: cell.txtPrice.text!) else {
			
			cell.txtPrice.text = ""
			bill[indexPath.section].items[indexPath.row].itemPrice = 0.00
			if let header = billTableView.headerView(forSection: indexPath.section) as? BillTableSection {
				
				header.lblPrice.text = formatCurrency(displayIndividualTotal(section: indexPath.section))
			}

			self.title = formatCurrency(Bill.getTotalPrice(bill))

			let errorAlert = UIAlertController(title: "Error", message: "Please enter a valid price.", preferredStyle: .alert)
			errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			
			self.present(errorAlert, animated: true, completion: nil)
			
			return
		}
		
		bill[indexPath.section].items[indexPath.row].itemPrice = price
		if let header = billTableView.headerView(forSection: indexPath.section) as? BillTableSection {
			
			header.lblPrice.text = formatCurrency(displayIndividualTotal(section: indexPath.section))
		}
		self.title = formatCurrency(Bill.getTotalPrice(bill))
		cell.txtPrice.text = formatCurrency(price)
		
		resetPriceFieldIfZero(cell.txtPrice)
	}
	
		//MARK: Collapsible Table Header Section
	
	func toggleSection(_ header: BillTableSection, section: Int) {
		
		let collapsed = !bill[section].collapsed
		
		//Toggle collapse
		bill[section].collapsed = collapsed
		
		if (bill[section].collapsed) {
			
			animateImage(header.expandOrCollapse, imageName: "expand")
		}
		else {
			
			animateImage(header.expandOrCollapse, imageName: "collapse")
		}
		
		// Adjust the height of the rows inside the section
		billTableView.beginUpdates()
		reloadRows(section)
		billTableView.endUpdates()
	}
	
	// MARK: - Functions
	
		// MARK: Removing a Person
	
	func choose() {
		
		view.endEditing(true)
		
		//Remove all items in selected person
		for i in (0 ..< bill[personPickerView.selectedRow(inComponent: 0)].items.count).reversed() {
			
			let rowIndex = IndexPath(row: i, section: personPickerView.selectedRow(inComponent: 0))
			bill[personPickerView.selectedRow(inComponent: 0)].items.remove(at: i)
			billTableView.deleteRows(at: [rowIndex], with: .right)
		}
		
		//Remove person and delete section from tableView
		bill.remove(at: personPickerView.selectedRow(inComponent: 0))
		billTableView.deleteSections(IndexSet(integer: personPickerView.selectedRow(inComponent: 0)), with: .right)
		
		//Reload sections
		let indexSet = IndexSet(integer: bill.count - 1)
		billTableView.reloadSections(indexSet, with: .automatic)
		
		
		//Reset tableView and their properties
		for i in 0 ..< bill.count {
			
			if let header = billTableView.headerView(forSection: i) as? BillTableSection {
				
				header.section = i
				header.btnAddItem.tag = i * 100
				header.txtName.tag = i * 100
				header.gestureRecognizers?.removeAll()
				header.expandOrCollapse.image = UIImage(named: "collapse")
				header.lblPrice.text = formatCurrency(displayIndividualTotal(section: i))

			}
			
			for j in 0 ..< bill[i].items.count {
				
				let indexPath = IndexPath(row: j, section: i)
				
				if let cell = billTableView.cellForRow(at: indexPath) as? BillTableCell {
					
					cell.indexPath = indexPath
				}
			}
		}
		
		self.title = formatCurrency(Bill.getTotalPrice(bill))
		personPickerView.reloadAllComponents()
	}
	
	func removePerson() {
		
		if (billTableView.numberOfSections == 1) {
			
			let alertController = UIAlertController(title: "Unable to Remove Person", message: "You must have at least 1 person in the bill.", preferredStyle: .alert)
			
			alertController.addAction(.init(title: "OK", style: .default, handler: nil))
			
			present(alertController, animated: true, completion: nil)
		}
		else {
			
			let textField = UITextField(frame: .zero)
			self.view.addSubview(textField)
			
			textField.inputView = personPickerView;
			personPickerView.selectRow(0, inComponent: 0, animated: false)
			pickerViewToolBar.setItems([btnCancel, flexibleSpace, btnChoose], animated: false)
			textField.inputAccessoryView = pickerViewToolBar
			
			textField.becomeFirstResponder()
		}
	}
	
	func toolBarEditingMode() {
		
		billTableView.beginUpdates()
		
		//Expand all sections and disable toggle section
		for i in 0 ..< bill.count {
			
			if let header = billTableView.headerView(forSection: i) as? BillTableSection {
				
				if (bill[i].collapsed) {
				
					bill[i].collapsed = false
					header.gestureRecognizers?.removeAll()
					animateImage(header.expandOrCollapse, imageName: "collapse")
					reloadRows(i)
				}
			}
			
			//Disable all cell textFields
			for j in 0 ..< bill[i].items.count {
				
				if let cell = billTableView.cellForRow(at: IndexPath(row: j, section: i)) as? BillTableCell {
				
					cell.txtPrice.isEnabled = false
					cell.txtName.isEnabled = false
				}
			}
			
			bill[i].collapsed = false
		}
		
		billTableView.endUpdates()
		
		let isEditing = [btnDone, flexibleSpace, btnRemovePerson]
		bottomToolbar.setItems(isEditing, animated: true)
		billTableView.setEditing(true, animated: true)
	}
	
	func toolBarNotEditingMode() {
		
		//If not viewDidLoad
		if (billTableView.isEditing) {
			
			//Enable toggle section again and all disabled textFields
			for i in 0 ..< bill.count {
				
				if let header = billTableView.headerView(forSection: i) as? BillTableSection {
					
					header.addGestureRecognizer(UITapGestureRecognizer(target: header.self, action: #selector(header.tapHeader(_:))))
				}
				
				for j in 0 ..< bill[i].items.count {
					
					let indexPath = IndexPath(row: j, section: i)
					
					if let cell = billTableView.cellForRow(at: indexPath) as? BillTableCell {
						
						cell.txtPrice.isEnabled = true
						cell.txtName.isEnabled = true
						
						//Reset indexPath if rows were reordered
						cell.indexPath = indexPath
					}
				}
			}
		}
		
		let notEditing = [btnEdit, flexibleSpace, btnAdd]
		bottomToolbar.setItems(notEditing, animated: true)
		billTableView.setEditing(false, animated: true)
	}
	
		// MARK: UI Updates
	
	func animateImage(_ imageView: UIImageView, imageName: String)  {
		
		UIView.transition(with: imageView,
		                  duration: 0.2,
		                  options: .transitionFlipFromTop,
		                  animations: { imageView.image = UIImage(named: imageName)},
		                  completion: nil)
		
	}
	
	func resetPriceFieldIfZero(_ cell: UITextField) {
		
		if (cell.text == "$0.00") {
			
			cell.text = ""
		}
	}
	
	func reloadRows(_ section: Int) {
		
		for i in 0 ..< bill[section].items.count {
			
			billTableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
		}
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
	
	func displayIndividualTotal(section: Int) -> Decimal {
		
		var total: Decimal = 0.00
		
		for i in 0 ..< bill[section].items.count {
			
			total += bill[section].items[i].itemPrice
		}
		
		return total
	}
	
		//MARK: Adding object array properties
	
	func addPerson() {
		
		let person = Person(name: "")
		bill.append(person)
		
		billTableView.insertSections(IndexSet(integer: (bill.count - 1)), with: .automatic)
		let indexPath = IndexPath(row: NSNotFound, section: bill.count - 1)
		
		//Don't scroll to row if keyboard is showing (Scroll fix when done editing)
		if (!keyboardIsShowing) {
			
			billTableView.scrollToRow(at: indexPath, at: .none, animated: true)
		}
	}
	
	func addItemToRow(_ sender: UIButton) {
		
		//Decrypt tag to get section
		let section = sender.tag / 100
		
		let item = Item(itemName: "", itemPrice: 0.00)
		bill[section].items.append(item)
		
		billTableView.insertRows(at: [IndexPath(row: bill[section].items.count - 1, section: section)], with: .automatic)
		
		if (bill[section].collapsed) {
			
			bill[section].collapsed = false
			if let header = billTableView.headerView(forSection: section) as? BillTableSection {
				
				animateImage(header.expandOrCollapse, imageName: "collapse")
			}
			
			billTableView.beginUpdates()
			reloadRows(section)
			billTableView.endUpdates()
		}
		
		//Don't scroll to row if keyboard is showing (Scroll fix when done editing)
		if (!keyboardIsShowing) {
			
			billTableView.scrollToRow(at: IndexPath(row: bill[section].items.count - 1, section: section), at: .none, animated: true)
		}
	}
	
	// MARK: - TextField Delegates
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		
		textField.inputAccessoryView = txtFieldToolBar
		
		if (textField.superview?.superview?.isKind(of: BillTableCell.self))! {
		
			let cell = textField.superview?.superview as! BillTableCell
			//Set indexPath to toolbarIndexPath to capture next or previous textField
			toolBarIndexPath = cell.indexPath
			
			if (textField.tag == cell.txtName.tag) {
				
				forwardOutlet.isEnabled = true
				backOutlet.isEnabled = false
			}
			else {
				
				backOutlet.isEnabled = true
				forwardOutlet.isEnabled = false
			}
		}
		else if (textField.superview?.superview?.isKind(of: BillTableSection.self))! {
			
			forwardOutlet.isEnabled = false
			backOutlet.isEnabled = false
		}
		
		//Remove the $ sign to prevent invalid updatePriceItem
		if (textField.tag == 2 && !textField.text!.isEmpty) {
			
			textField.text?.remove(at: (textField.text?.startIndex)!)
		}
		
		return true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		textField.resignFirstResponder()

		return true
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		//Scroll to current field if not visible
		if (textField.superview?.superview?.isKind(of: BillTableCell.self))! {
			
			let cell = textField.superview?.superview as! BillTableCell
			
			billTableView.scrollToRow(at: cell.indexPath!, at: .none, animated: false)
		}
		else if (textField.superview?.superview?.isKind(of: BillTableSection.self))! {
			
			let header = textField.superview?.superview as! BillTableSection

			billTableView.scrollToRow(at: IndexPath(row: NSNotFound, section: header.section), at: .none, animated: false)
		}
		
		return true
	}
	
	// MARK: - NotificationCenter Observers
	
	func keyboardWillShow(notification: Notification) {
		
		if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
			billTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
		}
		
		keyboardIsShowing = true
	}
	
	func keyboardWillHide(notification: Notification) {
		
		UIView.animate(withDuration: 0.2, animations: {
			
			// For some reason adding inset in keyboardWillShow is animated by itself but removing is not, that's why we have to use animateWithDuration here
			self.billTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
		})
		
		keyboardIsShowing = false
	}

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		
		if (segue.identifier == "nextPage") {
			
			let vc = segue.destination as! GSTViewController
			vc.bill = bill
			vc.totalTitle = self.title
		}
    }
	

}

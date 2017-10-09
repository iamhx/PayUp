//
//  PersonViewController.swift
//  PayUp
//
//  Created by Hongxuan on 6/10/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	//MARK: - View Controller properties
	
	@IBOutlet weak var itemTableView: UITableView!
	
	var person : Person?
	var gst : (svcCharge: Bool, GST: Bool)?
	var vc : SummaryViewController?
	
	//MARK: - viewDidLoad Implementation
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

		title = person!.name
		
		let backButton = UIBarButtonItem(image: UIImage(named: "previouspage"), style: .plain, target: self, action: #selector(back))
		backButton.tintColor = .white
		navigationItem.setLeftBarButton(backButton, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//MARK - TableView Required delegates
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return (person!.items.isEmpty) ? 1 : person!.items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "detailedItemCell") as! ItemTableCell
		
		if (person!.items.isEmpty) {
			
			cell.lblItemName.text = "No Item"
			cell.lblPrice.text = "$0.00"
			cell.lblGST.text = "(+$0.00)"
			
			cell.lblTotalPrice.text = "Total: $0.00"
		}
		else {
			
			let itemPrice = person!.items[indexPath.row].itemPrice
			let GST = Bill.getGSTForIndividual(itemPrice, gst!.svcCharge, gst!.GST)
			let total = itemPrice + GST
			
			cell.lblItemName.text = person!.items[indexPath.row].itemName
			cell.lblPrice.text = "\(formatCurrency(itemPrice, 2))"
			cell.lblGST.text = "(+\(formatCurrency(GST, 2)))"
			
			cell.lblTotalPrice.text = "Total: \(formatCurrency(total, 2))"
		}
		
		return cell
	}
	
	//MARK: - Actions
	
	func back() {
		
		navigationController?.popToViewController(vc!, animated: true)
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

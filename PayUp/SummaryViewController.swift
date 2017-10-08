//
//  SummaryViewController.swift
//  PayUp
//
//  Created by Hongxuan on 6/10/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	//MARK: - View Controller properties
	
	var bill : [Person] = []
	var gst : (svcCharge: Bool, GST: Bool)?
	var row : Int?
	@IBOutlet weak var summaryTableView: UITableView!
	@IBOutlet weak var lblTotal: UILabel!
	
	
	//MARK: - viewDidLoad Implementation
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		navigationItem.setHidesBackButton(true, animated: false)
		
		let btnStartOver = UIBarButtonItem(title: "Start Over", style: .plain, target: self, action: #selector(startOver))
		navigationItem.setRightBarButton(btnStartOver, animated: true)
		
		let total = Bill.getTotalPrice(bill)
		let GST = Bill.getGSTForIndividual(total, gst!.svcCharge, gst!.GST)
		
		lblTotal.text = "Total: $\(formatCurrency(total + GST, 2))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(true, animated: false)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
    //MARK: - TableView required delegates
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return bill.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell")
		cell!.textLabel!.text = "\(formatCurrency(Bill.calculateBill(bill[indexPath.row], gst!.svcCharge, gst!.GST), 2))"
		cell!.detailTextLabel!.text = bill[indexPath.row].name
		
		return cell!
	}
	
	//MARK: - TableView accessory tapped delegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		row = indexPath.row
		
		performSegue(withIdentifier: "showPerson", sender: self)
	}
	
	func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		row = indexPath.row
		
		performSegue(withIdentifier: "showPerson", sender: self)
	}
	
	// MARK: - Actions
	
	func startOver() {
		
		let promptAlert = UIAlertController(title: "", message: "Do you want to start over?", preferredStyle: .actionSheet)
		let yesAction = UIAlertAction(title: "Start Over", style: .destructive) { action in
			
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let vc = storyboard.instantiateViewController(withIdentifier: "billVC")
			self.present(vc, animated: true, completion: nil)
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		promptAlert.addAction(yesAction)
		promptAlert.addAction(cancelAction)
		
		self.present(promptAlert, animated: true, completion: nil)
		
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		
		if (segue.identifier == "showPerson") {
			
			let vc = segue.destination as! PersonViewController
			vc.person = bill[row!]
			vc.gst = gst!
			vc.vc = self
		}
    }
}

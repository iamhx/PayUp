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
	
	var billBeforeGST : [Person] = []
	var finalBill : [Person] = []
	var gst : (svcCharge: Bool, GST: Bool)?
	var row : Int?
	@IBOutlet weak var summaryTableView: UITableView!
	
	//MARK - IBActions
	
	@IBAction func btnStartOver(_ sender: Any) {
		
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
	
	
	//MARK: - viewDidLoad Implementation
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.navigationItem.setHidesBackButton(true, animated: false)
		
		print(billBeforeGST[0].items[0].itemPrice)
		print(finalBill[0].items[0].itemPrice)
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
		
		return finalBill.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell")
		cell!.textLabel!.text = "\(formatCurrency(Bill.getIndividualTotalPrice(finalBill[indexPath.row]), 2))"
		cell!.detailTextLabel!.text = finalBill[indexPath.row].name
		
		return cell!
	}
	
	//MARK: - TableView accessory tapped delegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		row = indexPath.row
		
		performSegue(withIdentifier: "showPerson", sender: self)
	}

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		
		if (segue.identifier == "showPerson") {
			
			let vc = segue.destination as! PersonViewController
			vc.person = billBeforeGST[row!]
			vc.gst = gst!
		}
    }
}

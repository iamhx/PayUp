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
	
	var billBeforeGST : [Person]?
	var bill : [Person]?
	@IBOutlet weak var summaryTableView: UITableView!
	
	//MARK: - viewDidLoad Implementation
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.navigationItem.setHidesBackButton(true, animated: false)

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
		
		return bill!.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell")
		cell!.textLabel!.text = "\(formatCurrency(Bill.getIndividualTotalPrice(bill!, indexPath.row), 2))"
		cell!.detailTextLabel!.text = bill![indexPath.row].name
		
		return cell!
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

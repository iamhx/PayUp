//
//  GSTViewController.swift
//  PayUp
//
//  Created by Hongxuan on 6/10/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class GSTViewController: UIViewController {

	//MARK: - View Controller properties
	
	var bill : [Person] = []
	var totalTitle : String?
	
	@IBOutlet weak var lblGST: UILabel!
	@IBOutlet weak var switchGST: UISwitch!
	@IBOutlet weak var lblServiceCharge: UILabel!
	@IBOutlet weak var switchServiceCharge: UISwitch!
	
	
	//MARK: - viewDidLoad Implementation
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		let backButton = UIBarButtonItem(image: UIImage(named: "previouspage"), style: .plain, target: self, action: #selector(back))
		let nextButton = UIBarButtonItem(title: "Split", style: .done, target: self, action: #selector(split))
		navigationItem.setRightBarButton(nextButton, animated: true)
		navigationItem.setLeftBarButton(backButton, animated: true)
		navigationItem.prompt = "Select GST"
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		animateTitle(0.3)
		self.title = totalTitle!
		
		UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
			self.switchGST.alpha = 1.0
			self.switchServiceCharge.alpha = 1.0
			self.lblGST.alpha = 1.0
			self.lblServiceCharge.alpha = 1.0
		}, completion: nil)
	}

	
	//MARK - Actions
	
	func back() {
		
		navigationController?.popViewController(animated: true)
	}
	
	func split() {
	
		let confirmation = UIAlertController(title: "Split Bill", message: "You have selected:\n\(selectedOptions())\n\nDo you want to split the bill?", preferredStyle: .alert)
		
		confirmation.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
			
			self.showOverlayOnTask(message: "Splitting bill...")
			Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.calculate), userInfo: nil, repeats: false)
		}))
		confirmation.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		present(confirmation, animated: true, completion: nil)
	}
	
	func selectedOptions() -> String {
		
		var string = "No GST"
		
		if (switchGST.isOn && !switchServiceCharge.isOn) {
			
			string = "7% GST"
		}
		else if (!switchGST.isOn && switchServiceCharge.isOn) {
			
			string = "10% Service Charge"
		}
		else if (switchGST.isOn && switchServiceCharge.isOn) {
			
			string = "7% GST\n10% Service Charge"
		}
		
		return string
	}
	
	func calculate() {
		
		renameEmptyNameFields()
		
		dismiss(animated: true, completion: { action in
			
			self.performSegue(withIdentifier: "showSummary", sender: self)
		})
	}
	
	func renameEmptyNameFields() {
		
		for i in 0 ..< bill.count {
			
			if (bill[i].name.isEmpty) {
				
				bill[i].name = "Person \(i + 1)"
			}
			
			for j in 0 ..< bill[i].items.count {
				
				if (bill[i].items[j].itemName.isEmpty) {
					
					bill[i].items[j].itemName = "Item \(j + 1)"
				}
			}
		}
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		
		if (segue.identifier == "showSummary") {
			
			let vc = segue.destination as! SummaryViewController
			vc.bill = bill
			vc.gst = (switchServiceCharge.isOn, switchGST.isOn)
		}
    }
}

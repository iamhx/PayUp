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
	
	var bill : [Person]?
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
		
		let fadeTextAnimation = CATransition()
		fadeTextAnimation.duration = 0.25
		fadeTextAnimation.type = kCATransitionFade
		
		navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
		self.title = totalTitle!
		
		UIView.animate(withDuration: 0.5, delay: 0.25, options: .transitionCrossDissolve, animations: {
			self.lblGST.alpha = 1.0
			self.switchGST.alpha = 1.0
			self.lblServiceCharge.alpha = 1.0
			self.switchServiceCharge.alpha = 1.0
		}, completion: nil)
	}

	
	//MARK - Actions
	
	func back() {
		
		navigationController?.popViewController(animated: true)
	}
	
	func split() {
	
		let confirmation = UIAlertController(title: "Split Bill", message: "You have selected:\n\(selectedOptions())\n\nDo you want to split the bill?", preferredStyle: .alert)
		
		confirmation.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
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
	

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

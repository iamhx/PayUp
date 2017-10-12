//
//  GSTViewController.swift
//  PayUp
//
//  Created by Hongxuan on 6/10/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit
import Instructions
import GoogleMobileAds

class GSTViewController: UIViewController, CoachMarksControllerDataSource, CoachMarksControllerDelegate, GADInterstitialDelegate {

	//MARK: - View Controller properties
	
	var bill : [Person] = []
	var totalTitle : String?
	
	@IBOutlet weak var lblGST: UILabel!
	@IBOutlet weak var switchGST: UISwitch!
	@IBOutlet weak var lblServiceCharge: UILabel!
	@IBOutlet weak var switchServiceCharge: UISwitch!
	@IBOutlet weak var btnSplitOutlet: UIButton!
	
	let coachMarksController = CoachMarksController()
	
	var interstitial: GADInterstitial!
	
	@IBAction func btnSplit(_ sender: Any) {
		
		let confirmation = UIAlertController(title: "", message: "You have selected:\n\(selectedOptions())\n\nDo you want to split the bill?", preferredStyle: .alert)
		
		confirmation.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
			
			self.showOverlayOnTask(message: "Splitting bill...")
			
			if (!UserDefaults.standard.bool(forKey: "removeAds")){
				
				self.interstitial = self.createAndLoadInterstitial()
			}
			else {
				
				Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.calculate), userInfo: nil, repeats: false)
			}
		}))
		confirmation.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		present(confirmation, animated: true, completion: nil)
	}
	
	//MARK: - viewDidLoad Implementation
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		let backButton = UIBarButtonItem(image: UIImage(named: "previouspage"), style: .plain, target: self, action: #selector(back))
		backButton.tintColor = .white
		
		navigationItem.setLeftBarButton(backButton, animated: true)
		
		if (!UserDefaults.standard.bool(forKey: "firstLaunch")) {
			navigationItem.leftBarButtonItem?.isEnabled = false
		}
		navigationItem.prompt = "Select GST"
		
		coachMarksController.dataSource = self
		coachMarksController.delegate = self
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.title = totalTitle!
		animateTitle(0.3)
		
		UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
			self.switchGST.alpha = 1.0
			self.switchServiceCharge.alpha = 1.0
			self.lblGST.alpha = 1.0
			self.lblServiceCharge.alpha = 1.0
			self.btnSplitOutlet.alpha = 1.0
		}, completion: { action in
		
			if (!UserDefaults.standard.bool(forKey: "firstLaunch")) {
			
				let skipView = CoachMarkSkipDefaultView()
				skipView.setTitle("Skip", for: .normal)
				self.coachMarksController.skipView = skipView
				self.coachMarksController.overlay.allowTap = true
				self.navigationItem.leftBarButtonItem?.isEnabled = true
				self.coachMarksController.start(on: self)
			}
		})
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		coachMarksController.stop(immediately: true)
	}
	
	// MARK: CoachMarksController Delegates
	
	func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
		
		return 4
	}
	
	func coachMarksController(_ coachMarksController: CoachMarksController,
	                          coachMarkAt index: Int) -> CoachMark {
		
		var coachMark = coachMarksController.helper.makeCoachMark()
		
		switch(index) {
		case 0:
			coachMark = coachMarksController.helper.makeCoachMark(for: switchGST)
			return coachMark
		case 1:
			coachMark = coachMarksController.helper.makeCoachMark(for: btnSplitOutlet)
			return coachMark
		case 2:
			return coachMarksController.helper.makeCoachMark(for: navigationController?.navigationBar) { (frame: CGRect) -> UIBezierPath in
				return UIBezierPath(rect: frame)
			}
		default:
			return coachMarksController.helper.makeCoachMark()
		}
	}
	
	func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
		
		
		var coachView = coachMarksController.helper.makeDefaultCoachViews()
		var hintText = ""
		
		switch(index) {
		case 0:
			hintText = "Select service charge and/or\nGST if required."
			coachView = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation, hintText: hintText, nextText: nil)
		case 1:
			
			hintText = "When you are ready, tap on the\nSplit Bill button."
			coachView = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, withNextText: false, arrowOrientation: coachMark.arrowOrientation)
			coachView.bodyView.hintLabel.text = hintText
		case 2:
			
			hintText = "Ready to split a bill?"
			coachView = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, withNextText: true, arrowOrientation: coachMark.arrowOrientation)
			coachView.bodyView.hintLabel.text = hintText
			coachView.bodyView.nextLabel.text = "Go!"
		default:
			break

		}
		
		return (bodyView: coachView.bodyView, arrowView: coachView.arrowView)
	}
	
	func coachMarksController(_ coachMarksController: CoachMarksController,
	                          willShow coachMark: inout CoachMark,
	                          afterSizeTransition: Bool,
	                          at index: Int) {
		if (index == 1) {
			
			if (!afterSizeTransition) {
				
				switchServiceCharge.setOn(true, animated: true)
				switchGST.setOn(true, animated: true)
			}
		}
		else if (index == 3) {

			if (!afterSizeTransition) {
				
				UserDefaults.standard.set(true, forKey: "firstLaunch")
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				let vc = storyboard.instantiateInitialViewController()
				present(vc!, animated: true, completion: nil)
			}
		}
	}
	
	func coachMarksController(_ coachMarksController: CoachMarksController,
	                          didEndShowingBySkipping skipped: Bool) {
		
		UserDefaults.standard.set(true, forKey: "firstLaunch")
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateInitialViewController()
		present(vc!, animated: true, completion: nil)

	}
	
	
	//MARK: - GADInterstitial delegates
	
	func interstitialDidDismissScreen(_ ad: GADInterstitial) {
		
		renameEmptyNameFields()
		performSegue(withIdentifier: "showSummary", sender: self)
	}
	
	func interstitialDidReceiveAd(_ ad: GADInterstitial) {
		
		dismiss(animated: true, completion: { action in
			
			ad.present(fromRootViewController: self)
		})
	}
	
	//MARK: - Actions
	
	func back() {
		
		navigationController?.popViewController(animated: true)
	}
	
	func createAndLoadInterstitial() -> GADInterstitial {
		
		interstitial = GADInterstitial(adUnitID: "ca-app-pub-6031268230658463/3221489240")
		interstitial.delegate = self
		let request = GADRequest()
		interstitial.load(request)
		return interstitial
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
	
	func calculate() {
		
		dismiss(animated: true, completion: { action in
			
			self.renameEmptyNameFields()
			self.performSegue(withIdentifier: "showSummary", sender: self)
		})
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

//
//  SideBarMenuViewController.swift
//  PayUp
//
//  Created by Hongxuan on 8/10/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class SideBarMenuViewController: MenuViewController {
	
	/*override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}*/
	
	@IBOutlet weak var splitABill: UIView!
	@IBOutlet weak var splitABillSelected: UIView!
	@IBOutlet weak var splitABillLabel: UILabel!
	@IBOutlet weak var settings: UIView!
	@IBOutlet weak var settingsSelected: UIView!
	@IBOutlet weak var settingsLabel: UILabel!
	
	var controllerStyle : UIAlertControllerStyle?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		if ( UI_USER_INTERFACE_IDIOM() == .pad )
		{
			controllerStyle = .alert
		}
		else {
			controllerStyle = .actionSheet
		}
		
		splitABill.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseSplitABill)))
		settings.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseSettings)))
		
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func chooseSplitABill() {
		
		guard let menuContainerViewController = self.menuContainerViewController else {
			return
		}
		
		if (menuContainerViewController.selectedContentViewController.isKind(of: BillViewController.self) || menuContainerViewController.selectedContentViewController.isKind(of: SummaryViewController.self)) {
			
			let alertController = UIAlertController(title: nil, message: nil, preferredStyle: controllerStyle!)
			alertController.addAction(UIAlertAction(title: "Start Over", style: .destructive, handler: {action in
				
				menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[1])
				menuContainerViewController.hideSideMenu()
			}))
			alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
			
			present(alertController, animated: true, completion: nil)
		}
		else {
			
			setSelectedFor(splitABill, splitABillSelected, splitABillLabel, true)
			setSelectedFor(settings, settingsSelected, settingsLabel, false)
			menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[1])
			menuContainerViewController.hideSideMenu()
		}
	}
	
	func chooseSettings() {
		
		guard let menuContainerViewController = self.menuContainerViewController else {
			return
		}
		
		if (menuContainerViewController.selectedContentViewController.isKind(of: BillViewController.self)) {
			
			let alertController = UIAlertController(title: "", message: "Changes made to the current bill will not be saved.", preferredStyle: controllerStyle!)
			alertController.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: {action in
				
				self.setSelectedFor(self.settings, self.settingsSelected, self.settingsLabel, true)
				self.setSelectedFor(self.splitABill, self.splitABillSelected, self.splitABillLabel, false)
				menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[2])
				menuContainerViewController.hideSideMenu()
			}))
			alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
			
			present(alertController, animated: true, completion: nil)
		}
		else if (menuContainerViewController.selectedContentViewController.isKind(of: SummaryViewController.self)) {
			
			let alertController = UIAlertController(title: "", message: "Leave current bill summary?", preferredStyle: controllerStyle!)
			alertController.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: {action in
				
				self.setSelectedFor(self.settings, self.settingsSelected, self.settingsLabel, true)
				self.setSelectedFor(self.splitABill, self.splitABillSelected, self.splitABillLabel, false)
				menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[2])
				menuContainerViewController.hideSideMenu()
			}))
			alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
			
			present(alertController, animated: true, completion: nil)
		}
		else {
			
			menuContainerViewController.hideSideMenu()
		}
	}
	
	func setSelectedFor(_ itemView: UIView,_ selectedView: UIView,_ label: UILabel, _ selected: Bool) {
		
		if (selected) {
			
			itemView.backgroundColor = .white
			selectedView.backgroundColor = .lightGray
			label.textColor = .darkGray
		}
		else {
			
			itemView.backgroundColor = UIColor(red: 239.0/255.0, green: 51.0/255.0, blue: 64.0/255.0, alpha: 1.0)
			selectedView.backgroundColor = .white
			label.textColor = .white
		}
	}
	
	@IBAction func btnInfo(_ sender: Any) {
		
		guard let menuContainerViewController = self.menuContainerViewController else {
			return
		}
		
		let alertController = UIAlertController(title: "", message: "Do you want to replay the tutorial?", preferredStyle: controllerStyle!)
		alertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {action in
			
			UserDefaults.standard.set(false, forKey: "firstLaunch")
			self.setSelectedFor(self.splitABill, self.splitABillSelected, self.splitABillLabel, true)
			self.setSelectedFor(self.settings, self.settingsSelected, self.settingsLabel, false)
			menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[1])
			menuContainerViewController.hideSideMenu()
		}))
		
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		present(alertController, animated: true, completion: nil)
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

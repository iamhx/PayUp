//
//  OpenSLTableViewController.swift
//  PayUp
//
//  Created by Hongxuan on 10/10/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class OpenSLTableViewController: UITableViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem()
		
		let backButton = UIBarButtonItem(image: UIImage(named: "previouspage"), style: .plain, target: self, action: #selector(back))
		backButton.tintColor = .white
		navigationItem.setLeftBarButton(backButton, animated: false)
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if (indexPath.section == 0) {
			
			switch (indexPath.row) {
				
			case 0:
				SettingsTableViewController.launchURL(string: "https://github.com/handsomecode/InteractiveSideMenu")
				break
			case 1:
				SettingsTableViewController.launchURL(string: "https://github.com/PiXeL16/RevealingSplashView")
			case 2:
				SettingsTableViewController.launchURL(string: "https://github.com/ephread/Instructions")
			default:
				break
			}
		}
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		
		if let headerTitle = view as? UITableViewHeaderFooterView {
			
			headerTitle.textLabel?.textColor = UIColor.white
		}
	}
	
	func back() {
		
		navigationController?.popViewController(animated: true)
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

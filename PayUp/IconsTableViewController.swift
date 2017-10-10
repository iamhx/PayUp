//
//  IconsTableViewController.swift
//  PayUp
//
//  Created by Hongxuan on 10/10/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class IconsTableViewController: UITableViewController {

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
				launchURL(string: "https://icons8.com/icon/61/Forward")
				break
			case 1:
				launchURL(string: "https://icons8.com/icon/1806/Back")
				break
			case 2:
				launchURL(string: "https://icons8.com/icon/10721/Collapse-Arrow")
				break
			case 3:
				launchURL(string: "https://icons8.com/icon/10720/Expand-Arrow")
				break
			case 4:
				launchURL(string: "https://icons8.com/icon/26196/forward-button-filled")
				break
			case 5:
				launchURL(string: "https://icons8.com/icon/26191/back-arrow-filled")
				break
			case 6:
				launchURL(string: "https://icons8.com/icon/3096/menu")
				break
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
	
	func launchURL(string: String) {
		
		guard let url = URL(string: string) else {
			return
		}
		
		if (UIApplication.shared.canOpenURL(url)) {
			
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
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

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
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		let splitABill = view.viewWithTag(5)
		splitABill?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseSplitABill)))
		
    }
	
	func chooseSplitABill() {
		
		guard let menuContainerViewController = self.menuContainerViewController else {
			return
		}

		if (menuContainerViewController.selectedContentViewController.isKind(of: BillViewController.self) || menuContainerViewController.selectedContentViewController.isKind(of: SummaryViewController.self)) {
			
			let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
			alertController.addAction(UIAlertAction(title: "Start Over", style: .destructive, handler: {action in
				
				menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[1])
				menuContainerViewController.hideSideMenu()
			}))
			alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
			
			present(alertController, animated: true, completion: nil)
		}
		else {
			
			menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[1])
			menuContainerViewController.hideSideMenu()
		}
		/*else {
			
			let alertController = UIAlertController(title: "", message: "Changes made in this bill will not be saved!", preferredStyle: .actionSheet)
			alertController.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { action in
				
				menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[1])
				menuContainerViewController.hideSideMenu()
			}))
			
			alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
			
			present(alertController, animated: true, completion: nil)
		}*/
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

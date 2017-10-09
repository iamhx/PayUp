//
//  BillNavigationController.swift
//  PayUp
//
//  Created by Hongxuan on 8/10/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class BillNavigationController: UINavigationController, SideMenuItemContent {
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		navigationBar.barTintColor = UIColor(red: 239.0/255.0, green: 51.0/255.0, blue: 64.0/255.0, alpha: 1.0)
		navigationBar.isTranslucent = false
		navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
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

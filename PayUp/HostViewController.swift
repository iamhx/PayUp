//
//  HostViewController.swift
//  PayUp
//
//  Created by Hongxuan on 8/10/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class HostViewController: MenuContainerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		let screenSize: CGRect = UIScreen.main.bounds
		transitionOptions = TransitionOptions(duration: 0.4, visibleContentWidth: screenSize.width / 6)
		
		// Instantiate menu view controller by identifier
		menuViewController = self.storyboard!.instantiateViewController(withIdentifier: "menuVC") as! MenuViewController
		
		// Gather content items controllers
		contentViewControllers = contentControllers()
		
		// Select initial content controller. It's needed even if the first view controller should be selected.
		selectContentViewController(contentViewControllers.first!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func contentControllers() -> [UIViewController] {
		
		let controllersIdentifiers = ["billVC"]
		var contentList = [UIViewController]()
		
		/*
		Instantiate items controllers from storyboard.
		*/
		for identifier in controllersIdentifiers {
			
			if let viewController = self.storyboard?.instantiateViewController(withIdentifier: identifier) {
				
				contentList.append(viewController)
			}
		}
		
		return contentList
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

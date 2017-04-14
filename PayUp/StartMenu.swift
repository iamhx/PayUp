//
//  StartMenu.swift
//  PayUp
//
//  Created by Hongxuan on 14/4/17.
//  Copyright © 2017 hx. All rights reserved.
//

import UIKit

class StartMenu: UIViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.view.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func btnNewSplit(_ sender: UIButton) {
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let rootVC = storyboard.instantiateViewController(withIdentifier: "billRootViewController")
		self.present(rootVC, animated: true, completion: nil)
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

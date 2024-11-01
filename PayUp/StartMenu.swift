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

		//self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		//self.navigationController?.navigationBar.shadowImage = UIImage()
		//self.navigationController?.view.backgroundColor = UIColor.clear
		//self.navigationController?.navigationBar.isTranslucent = true
		//self.navigationController?.navigationBar.barTintColor = UIColor(red: 255.0/255.0, green: 147.0/255.0, blue: 44.0/255.0, alpha: 1.0)
		
		let image : UIImage = UIImage(named: "AppTitle")!
		let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 80, height: 40))
		imageView.contentMode = .scaleAspectFit
		imageView.image = image
		
		self.navigationItem.titleView = imageView
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

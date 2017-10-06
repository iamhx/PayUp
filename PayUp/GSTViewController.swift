//
//  GSTViewController.swift
//  PayUp
//
//  Created by Hongxuan on 6/10/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit

class GSTViewController: UIViewController {

	var bill : [Person]?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		let backButton = UIBarButtonItem(image: UIImage(named: "previouspage"), style: .plain, target: self, action: #selector(back))
		navigationItem.setLeftBarButton(backButton, animated: true)
		navigationItem.prompt = "Your Bill"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func back() {
		
		navigationController?.popViewController(animated: true)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		let fadeTextAnimation = CATransition()
		fadeTextAnimation.duration = 0.5
		fadeTextAnimation.type = kCATransitionFade
		
		navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
		self.title = "$0.00"		
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

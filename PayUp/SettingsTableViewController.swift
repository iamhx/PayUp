//
//  SettingsTableViewController.swift
//  PayUp
//
//  Created by Hongxuan on 10/10/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit
import InteractiveSideMenu
import MessageUI

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let image : UIImage = UIImage(named: "AppTitle")!
		let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 80, height: 40))
		imageView.contentMode = .scaleAspectFit
		imageView.image = image
		imageView.tintColor = .white
		
		navigationItem.titleView = imageView

		let btnMenu = UIButton(type: .custom)
		let menuImage = UIImage(named: "menu")
		btnMenu.setImage(menuImage, for: .normal)
		btnMenu.frame =  CGRect(x: 0, y: 0, width: 25, height: 25)
		btnMenu.showsTouchWhenHighlighted = false
		btnMenu.tintColor = .white
		btnMenu.addTarget(self, action: #selector(menu), for: .touchUpInside)
		
		let btnMenuBarItem = UIBarButtonItem(customView: btnMenu)
		navigationItem.setLeftBarButton(btnMenuBarItem, animated: true)
		
		if let navigationViewController = self.navigationController as? SideMenuItemContent {
			
			navigationViewController.setSelectedContentViewController(controller: self)
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		
		if let headerTitle = view as? UITableViewHeaderFooterView {
			
			headerTitle.textLabel?.textColor = UIColor.white
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if (indexPath.section == 0) {
			
			switch (indexPath.row) {
				
			case 0:
				
				let promptReport = UIAlertController(title: "Report a Problem", message: "", preferredStyle: .alert)
				let reportBug = UIAlertAction(title: "Something isn't Working", style: .default, handler: { action in
					
					self.sendEmail(title: "Report a Problem — Something isn't Working", message:"Briefly explain what happened:")
				})
				let submitFeedback = UIAlertAction(title: "Feedback/Suggestions", style: .default, handler: { action in
					
					self.sendEmail(title: "Report a Problem — Feedback/Suggestions", message:"Tell us what you like about this app, or how we can improve:")
				})
				let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
				
				promptReport.addAction(reportBug)
				promptReport.addAction(submitFeedback)
				promptReport.addAction(cancelAction)
				
				self.present(promptReport, animated: true, completion: nil)
				break
			default:
				break
			}
		}
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func menu() {
		
		if let navigationViewController = self.navigationController as? SideMenuItemContent {
			
			navigationViewController.showSideMenu()
		}
	}
	
	func sendEmail(title: String, message: String) {
		
		if MFMailComposeViewController.canSendMail() {
			
			let mail = MFMailComposeViewController()
			mail.mailComposeDelegate = self
			mail.setSubject(title)
			mail.setToRecipients(["neoville.sg@gmail.com"])
			mail.setMessageBody("<p>\(message)<p><br><br>", isHTML: true)
			
			present(mail, animated: true)
		}
		else {
			
			let promptAddEmail = UIAlertController(title: "Couldn't find any existing email accounts", message: "Please add an email account in order to submit a report to us.", preferredStyle: .alert)
			let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
			let openMail = UIAlertAction(title: "Open Mail", style: .default, handler: { action in
				
				var newTitle = title.replacingOccurrences(of: " ", with: "%20")
				newTitle = newTitle.replacingOccurrences(of: "—", with: "%E2%80%94")
				newTitle = newTitle.replacingOccurrences(of: "'", with: "%27")
				newTitle = newTitle.replacingOccurrences(of: "/", with: "%2F")
				
				var newMessage = message.replacingOccurrences(of: " ", with: "%20")
				newMessage = newMessage.replacingOccurrences(of: ",", with: "%2C")
				newMessage = newMessage.replacingOccurrences(of: ":", with: "%3A")
				newMessage.append("%0D%0A%0D%0A%0D%0A")
				
				if let url = URL(string: "mailto:neoville.sg@gmail.com?subject=\(newTitle)&body=\(newMessage)")
				{
					UIApplication.shared.open(url)
				}
				
			})
			
			promptAddEmail.addAction(openMail)
			promptAddEmail.addAction(cancelAction)
			
			self.present(promptAddEmail, animated: true, completion: nil)
		}
	}
	
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		
		controller.dismiss(animated: true)
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

//
//  Settings.swift
//  PayUp
//
//  Created by Hongxuan on 15/4/17.
//  Copyright © 2017 hx. All rights reserved.
//

import UIKit
import MessageUI

class Settings: UITableViewController, MFMailComposeViewControllerDelegate {
	
	@IBAction func btnFacebook(_ sender: UIButton) {
		
		guard let facebookURL = URL(string: "fb://page/?id=1896250340630689") else {
			return
		}
		
		if (UIApplication.shared.canOpenURL(facebookURL)) {
			
			UIApplication.shared.open(facebookURL, options: [:], completionHandler: nil)
		}
		else {
			
			guard let webpageURL = URL(string: "http://facebook.com/SRSoftworks/") else {
				return
			}
			
			UIApplication.shared.open(webpageURL, options: [:], completionHandler: nil)
		}
	}

	@IBAction func btnTwitter(_ sender: UIButton) {
		
		guard let twitterURL = URL(string: "twitter://user?screen_name=srsoftworks") else {
			
			return
		}
		
		if (UIApplication.shared.canOpenURL(twitterURL)) {
			
			UIApplication.shared.open(twitterURL, options: [:], completionHandler: nil)
		}
		else {
			
			guard let webpageURL = URL(string: "http://twitter.com/srsoftworks/") else {
				return
			}
			
			UIApplication.shared.open(webpageURL, options: [:], completionHandler: nil)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		
		self.navigationController?.navigationBar.tintColor = .black
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if (indexPath.section == 0)
		{
			if (indexPath.row == 0)
			{
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
			}
		}
	}
	
	func sendEmail(title: String, message: String) {
		
		if MFMailComposeViewController.canSendMail() {
			
			let mail = MFMailComposeViewController()
			mail.mailComposeDelegate = self
			mail.setSubject(title)
			mail.setToRecipients(["srsoftworks@gmail.com"])
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
				
				if let url = URL(string: "mailto:srsoftworks@gmail.com?subject=\(newTitle)&body=\(newMessage)")
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

    // MARK: - Table view data source

    /* override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    } */

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

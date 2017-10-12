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
import StoreKit


class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate {

	@IBOutlet weak var removeAds: UILabel!
	
	var productID = "com.Hongxuan.PayUp.removeAds"
	
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
		btnMenu.adjustsImageWhenDisabled = false
		btnMenu.adjustsImageWhenHighlighted = false
		btnMenu.tintColor = .white
		btnMenu.addTarget(self, action: #selector(menu), for: .touchUpInside)
		
		let btnMenuBarItem = UIBarButtonItem(customView: btnMenu)
		navigationItem.setLeftBarButton(btnMenuBarItem, animated: true)
		
		if let navigationViewController = self.navigationController as? SideMenuItemContent {
			
			navigationViewController.setSelectedContentViewController(controller: self)
		}
		
		SKPaymentQueue.default().add(self)
		
		if (UserDefaults.standard.bool(forKey: "removeAds")){
			
			removeAds.text = "✅"
		}
		else {
			
			removeAds.text = "Buy"
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
			case 1:
				
				guard let facebookURL = URL(string: "fb://page/?id=1896250340630689") else {
					return
				}
				
				if (UIApplication.shared.canOpenURL(facebookURL)) {
					
					SettingsTableViewController.launchURL(string: "fb://page/?id=1896250340630689")
				}
				else {
					
					SettingsTableViewController.launchURL(string: "http://facebook.com/Neoville.SG/")
				}
				break
			default:
				break
			}
		}
		else if (indexPath.section == 1) {
			
			switch (indexPath.row) {
				
			case 0:
				
				if (!UserDefaults.standard.bool(forKey: "removeAds")){
					
					requestRemoveAds()
				}
				break
			case 1:
				let alertController = UIAlertController(title: "Restore Purchases", message: "Do you want to restore purchases for this device?", preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
				
					SKPaymentQueue.default().restoreCompletedTransactions()
				}))
				alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
				
				present(alertController, animated: true, completion: nil)
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
	
	
	func requestRemoveAds() {
		
		showOverlayOnTask(message: "Please wait...")
		
		// We check that we are allow to make the purchase.
		if (SKPaymentQueue.canMakePayments()) {
			
			let productID : NSSet = NSSet(object: self.productID)
			let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
			
			productsRequest.delegate = self
	
			productsRequest.start()
		}
		else {
			
			dismiss(animated: true, completion: {action in
			
				self.promptAlert(title: "Unable to authorize payment", message: "You do not have permission to authorize payment.")
			})
		}
	}
	
	func buyProduct(product: SKProduct) {
		
		let payment = SKPayment(product: product)
		SKPaymentQueue.default().add(payment)
	}
	
	func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
		
		if (response.products.count > 0) {
			
			let validProduct: SKProduct = response.products[0] as SKProduct
			
			if (validProduct.productIdentifier == self.productID) {
				
				dismiss(animated: true, completion: {action in
				
					self.buyProduct(product: validProduct)
				})
			}
		}
	}
	
	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
		
		for transaction:AnyObject in transactions {
			
			if let trans : SKPaymentTransaction = transaction as? SKPaymentTransaction {
				
				switch trans.transactionState {
				case .purchased:
					
					UserDefaults.standard.set(true , forKey: "removeAds")
					removeAds.text = "✅"
					SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
					break
				case .failed:
					
					if let transactionError = transaction.error as? NSError {
						
							if transactionError.code != SKError.paymentCancelled.rawValue {
								
								print("Transaction Error: \(transactionError.localizedDescription)")
						}
					}
					
					SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
					break
				case .restored:
					
					UserDefaults.standard.set(true , forKey: "removeAds")
					removeAds.text = "✅"
					SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
				default:
					break
				}
			}
		}
	}
	
	func request(_ request: SKRequest, didFailWithError error: Error) {

		dismiss(animated: true, completion: {action in
		
			self.promptAlert(title: "Unable to request payment", message: "Please check that you have internet connection enabled.")
		})
	}
	
	func promptAlert(title: String, message: String) {
		
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		
		present(alertController, animated: true, completion: nil)
	}
	
	class func launchURL(string: String) {
		
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

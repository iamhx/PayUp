//
//  AppDelegate.swift
//  PayUp
//
//  Created by Hongxuan on 27/9/17.
//  Copyright © 2017 Hongxuan. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	func showOverlayOnTask(message: String) {
		
		let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		
		let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
		loadingIndicator.hidesWhenStopped = true
		loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
		loadingIndicator.startAnimating();
		
		alert.view.addSubview(loadingIndicator)
		self.present(alert, animated: true, completion: nil)
	}
	
	func formatCurrency(_ amount: Decimal,_ fractionDigits: Int) -> String {
		
		var string = ""
		
		let formatter = NumberFormatter()
		let usLocale = Locale.init(identifier: "en_US")
		formatter.minimumIntegerDigits = 1
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = fractionDigits
		formatter.roundingMode = .down
		formatter.locale = usLocale
		
		string = String(format: "$%@", formatter.string(from: NSDecimalNumber(decimal: amount))!)
		return string
	}
	
	func animateTitle(_ duration: Double) {
		
		let fadeTextAnimation = CATransition()
		fadeTextAnimation.duration = duration
		fadeTextAnimation.type = kCATransitionFade
		
		navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
	}
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		if (UserDefaults.standard.bool(forKey: "animatedLogo")) {
			
			UserDefaults.standard.set(false, forKey: "animatedLogo")
		}
		
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
		
		self.saveContext()
	}

	// MARK: - Core Data stack

	lazy var persistentContainer: NSPersistentContainer = {
	    /*
	     The persistent container for the application. This implementation
	     creates and returns a container, having loaded the store for the
	     application to it. This property is optional since there are legitimate
	     error conditions that could cause the creation of the store to fail.
	    */
	    let container = NSPersistentContainer(name: "PayUp")
	    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
	        if let error = error as NSError? {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	             
	            /*
	             Typical reasons for an error here include:
	             * The parent directory does not exist, cannot be created, or disallows writing.
	             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
	             * The device is out of space.
	             * The store could not be migrated to the current model version.
	             Check the error message to determine what the actual problem was.
	             */
	            fatalError("Unresolved error \(error), \(error.userInfo)")
	        }
	    })
	    return container
	}()

	// MARK: - Core Data Saving support

	func saveContext () {
	    let context = persistentContainer.viewContext
	    if context.hasChanges {
	        do {
	            try context.save()
	        } catch {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	            let nserror = error as NSError
	            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
	        }
	    }
	}

}


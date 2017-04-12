//
//  ViewController.swift
//  SWAdjustViews
//
//  Created by DonMag on 10/28/16.
//  Copyright © 2016 DonMag. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

	@IBOutlet weak var myImageView: UIImageView!
	
	@IBOutlet weak var myTableView: UITableView!
	
	@IBOutlet weak var mySearchBar: UISearchBar!
	
	@IBOutlet weak var myImageViewTop: NSLayoutConstraint!
	@IBOutlet weak var myTableViewBottom: NSLayoutConstraint!
	
	var origImageTop: CGFloat = 0
	var origTableViewBottom: CGFloat = 0
	
	var animationDuration: TimeInterval = 0
	var animationCurve: UIViewAnimationCurve = UIViewAnimationCurve.easeIn
	var animatingRotation: Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		myTableView.delegate = self
		myTableView.dataSource = self
		
		myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		
		mySearchBar.delegate = self
	
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
		
		myTableViewBottom.constant = 8
		
		origImageTop = myImageViewTop.constant
		origTableViewBottom = myTableViewBottom.constant
		
		self.view.backgroundColor = UIColor.black
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func animateViewChange(_ newTop: CGFloat) -> Void {
		
		UIView.animate(withDuration: 0.5, animations: {
			self.myImageViewTop.constant = newTop
			self.view.layoutIfNeeded()
		})
		
	}
	
	// https://gist.github.com/smnh/e864896ba37bc4cfdce6
	
	func adjustForKeyboard(notification: Notification) {
		let userInfo = notification.userInfo!
		
		let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
		
		var t = (keyboardViewEndFrame.height + 8)
		
		
		
		
		if notification.name == Notification.Name.UIKeyboardWillHide {
//			myTableView.contentInset = UIEdgeInsets.zero

			t = origTableViewBottom
			
		} else {
//			myTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
			
			// nothing to do
		
		}

		self.myTableViewBottom.constant = t
		
//		myTableView.scrollIndicatorInsets = myTableView.contentInset

	}

	func keyboardWillChangeFrame(notification: Notification) -> Void {
		self.adjustForKeyboard(notification: notification)
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		
		super.viewWillTransition(to: size, with: coordinator)
		
		coordinator.animate(alongsideTransition: { context in
			self.animationDuration = context.transitionDuration
			self.animationCurve = context.completionCurve
			self.animatingRotation = true
		},
		                    completion: { context in
								self.animatingRotation = false
		}
		)
		
		print("trans... ", size)
	}
	
	// MARK: - Search Bar delegate
	
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		self.animateViewChange(origImageTop - self.myImageView.frame.size.height)
		searchBar.showsCancelButton = true
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		searchBar.showsCancelButton = false
		self.animateViewChange(origImageTop)
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.text = ""
		searchBar.resignFirstResponder()
	}
	
	// MARK: - Table view data source
	
	 func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return 32
	}
	
	 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		
		// Configure the cell...
		
		cell.textLabel?.text = "Row: \(indexPath.row)"
		
		return cell
	}

	// MARK: - Table view delegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// do something
	}
	

}


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
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func animateViewChange(_ newTop: CGFloat) -> Void {
		
		self.myImageViewTop.constant = newTop
		
		UIView.animate(withDuration: 0.5, animations: {
			self.view.layoutIfNeeded()
		}) 
		
	}
	
	func adjustForKeyboard(notification: Notification) {
		let userInfo = notification.userInfo!
		
		let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
		
		if notification.name == Notification.Name.UIKeyboardWillHide {
			myTableView.contentInset = UIEdgeInsets.zero
		} else {
			myTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
		}
		
		myTableView.scrollIndicatorInsets = myTableView.contentInset
		
//		let selectedRange = myTableView.selectedRange
//		myTableView.scrollRangeToVisible(selectedRange)
	}
	
	// MARK: - Search Bar delegate
	
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		self.animateViewChange(-(self.myImageView.frame.size.height))
		searchBar.showsCancelButton = true
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		searchBar.showsCancelButton = false
		self.animateViewChange(0)
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


//
//  RWTFlickSearchViewController.swift
//  MVVM_Tutorial
//
//  Created by Waratnan Suriyasorn on 6/22/2559 BE.
//  Copyright © 2559 Waratnan Suriyasorn. All rights reserved.
//

import UIKit

class RWTFlickSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	@IBOutlet weak var searchTextField: UITextField!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
	@IBOutlet weak var searchHistoryTable: UITableView!

	var viewModel: RWTFlickrSearchViewModel! {
		didSet {
			self.bindViewModel()
		}
	}

	override func viewDidLoad() {
		self.viewModel = RWTFlickrSearchViewModel(services: RWTViewModelServicesImpl(navigationController: self.navigationController))
	}

	func bindViewModel() {

		self.title = viewModel.title
		self.searchTextField.text = viewModel.searchText

		RAC(self.viewModel, "searchText").assignSignal(self.searchTextField.rac_textSignal())
		self.searchButton.rac_command = self.viewModel.executeSearch

		RAC(UIApplication.sharedApplication(), "networkActivityIndicatorVisible").assignSignal(self.viewModel.executeSearch.executing)
		RAC(self.loadingIndicator, "hidden").assignSignal(self.viewModel.executeSearch.executing.not())

		self.viewModel.executeSearch.executionSignals.subscribeNext { _ in
			self.searchTextField.resignFirstResponder()
		}

	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("RecentSearchItem")!

		return cell
	}

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

	}

}

//
//  RWTSearchResultsViewController.swift
//  MVVM_Tutorial
//
//  Created by Waratnan Suriyasorn on 6/22/2559 BE.
//  Copyright © 2559 Waratnan Suriyasorn. All rights reserved.
//

import UIKit

class RWTSearchResultsViewController: UITableViewController {

	var viewModel: RWTSearchResultsViewModel! {
		didSet {
			self.bindViewModel()

		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

	}

	func bindViewModel() {
		self.title = viewModel.title
	}
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.searchResults.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! RWTSearchResultsTableViewCell
        cell.viewModel = viewModel.searchResults[indexPath.row]
        
        return cell
    }
}

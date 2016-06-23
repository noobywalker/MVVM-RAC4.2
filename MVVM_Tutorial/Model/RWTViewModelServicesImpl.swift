//
//  RWTViewModelServicesImpl.swift
//  MVVM_Tutorial
//
//  Created by Waratnan Suriyasorn on 6/22/2559 BE.
//  Copyright © 2559 Waratnan Suriyasorn. All rights reserved.
//

import UIKit

class RWTViewModelServicesImpl: NSObject, RWTViewModelServices {

	var searchService: RWTFlickrSearch!
	var searchResultViewModel: RWTSearchResultsViewModel!
	var navigationController: UINavigationController?
	func getFlickrSearchService() -> RWTFlickrSearch {
		return self.searchService
	}

	init(navigationController: UINavigationController?) {
		super.init()
		self.searchService = RWTFlickrSearchImpl()
		self.navigationController = navigationController
	}

	func pushViewModel(viewModel: AnyObject) {

		if let vm = viewModel as? RWTSearchResultsViewModel {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			if let searchResultVC = storyboard.instantiateViewControllerWithIdentifier("RWTSearchResultsViewController") as? RWTSearchResultsViewController {
				searchResultVC.viewModel = vm
				navigationController?.pushViewController(searchResultVC, animated: true)
			}
		} else {
			print("an unknown ViewModel was pushed!")
		}
	}
}
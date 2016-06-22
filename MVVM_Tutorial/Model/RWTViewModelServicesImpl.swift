//
//  RWTViewModelServicesImpl.swift
//  MVVM_Tutorial
//
//  Created by Waratnan Suriyasorn on 6/22/2559 BE.
//  Copyright © 2559 Waratnan Suriyasorn. All rights reserved.
//

import Foundation

class RWTViewModelServicesImpl: NSObject, RWTViewModelServices {

	var searchService: RWTFlickrSearch!

	func getFlickrSearchService() -> RWTFlickrSearch {
		return self.searchService
	}

	override init() {
		super.init()
		self.searchService = RWTFlickrSearchImpl()
	}

}
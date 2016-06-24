//
//  RWTSearchResultsViewModel.swift
//  MVVM_Tutorial
//
//  Created by Waratnan Suriyasorn on 6/23/2559 BE.
//  Copyright © 2559 Waratnan Suriyasorn. All rights reserved.
//

import Foundation

class RWTSearchResultsViewModel: NSObject {

	var title: String!
	var searchResults: [RWTSearchResultsItemViewModel]

	init(result: RWTFlickrSearchResults) {

		self.searchResults = result.photos.map { RWTSearchResultsItemViewModel(photo: $0) }
		self.title = result.searchString
		super.init()
	}
}
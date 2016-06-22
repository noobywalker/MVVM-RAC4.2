//
//  RWTFlickrSearchResults.swift
//  MVVM_Tutorial
//
//  Created by Waratnan Suriyasorn on 6/22/2559 BE.
//  Copyright © 2559 Waratnan Suriyasorn. All rights reserved.
//

import Foundation

class RWTFlickrSearchResults: NSObject {
	var searchString: String!
	var photos: [RWTFlickrPhoto]!
	var totalResults: Int!

	func getDescription() -> String {
		return "searchString=\(self.searchString), totalresults=\(self.totalResults), photos=\(self.photos)"
	}
}
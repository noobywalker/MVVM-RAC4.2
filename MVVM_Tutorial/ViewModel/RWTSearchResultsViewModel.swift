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
	var searchResults: [RWTFlickrPhoto]!
    
    init(result:RWTFlickrSearchResults) {
        super.init()
        self.searchResults = result.photos
        self.title = result.searchString
    }
}
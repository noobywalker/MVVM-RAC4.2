//
//  RWTFlickrSearchViewModel.swift
//  MVVM_Tutorial
//
//  Created by Waratnan Suriyasorn on 6/22/2559 BE.
//  Copyright © 2559 Waratnan Suriyasorn. All rights reserved.
//

import Foundation
import ReactiveCocoa

class RWTFlickrSearchViewModel: NSObject {
	var searchText: String!
	var title: String!

	var services: RWTViewModelServices!
	var executeSearch: RACCommand!

	init(services: RWTViewModelServices) {
		super.init()
        self.services = services
		self.searchText = "search text"
		self.title = "Flickr Search"

		let validSearchSignal = RACObserve(self, keyPath: "searchText")
			.map { value in
				let text = value as! String
				return text.characters.count > 3
		}.distinctUntilChanged()

		validSearchSignal.subscribeNext {
			print("search text is valid \($0)")
		}

		self.executeSearch = RACCommand(enabled: validSearchSignal, signalBlock: { (_) -> RACSignal! in
			return self.executeSearchSignal()
		})

	}

	func executeSearchSignal() -> RACSignal {
		return self.services.getFlickrSearchService().flickrSearchSignal(self.searchText)
	}
}

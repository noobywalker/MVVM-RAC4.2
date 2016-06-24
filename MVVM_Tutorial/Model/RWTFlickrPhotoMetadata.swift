//
//  RWTFlickrPhotoMetadata.swift
//  MVVM_Tutorial
//
//  Created by Waratnan Suriyasorn on 6/24/2559 BE.
//  Copyright © 2559 Waratnan Suriyasorn. All rights reserved.
//

import Foundation

class RWTFlickrPhotoMetadata {
	let favourites: Int
	let comments: Int

	init(favourites: Int?, comments: Int?) {
		self.favourites = favourites ?? 0
		self.comments = comments ?? 0
	}
}
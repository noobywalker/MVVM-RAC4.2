//
//  RWTFlickrPhoto.swift
//  MVVM_Tutorial
//
//  Created by Waratnan Suriyasorn on 6/22/2559 BE.
//  Copyright © 2559 Waratnan Suriyasorn. All rights reserved.
//

import Foundation

class RWTFlickrPhoto: NSObject {
	var title: String!
	var url: NSURL!
	var identifier: String!

	func getDescription() -> String {
		return title
	}
}

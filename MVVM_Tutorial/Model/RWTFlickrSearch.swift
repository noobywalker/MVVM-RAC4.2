//
//  RWTFlickrSearch.swift
//  MVVM_Tutorial
//
//  Created by Waratnan Suriyasorn on 6/22/2559 BE.
//  Copyright © 2559 Waratnan Suriyasorn. All rights reserved.
//

import Foundation
import ReactiveCocoa

protocol RWTFlickrSearch {
    func flickrSearchSignal(searchString:String) -> RACSignal
}

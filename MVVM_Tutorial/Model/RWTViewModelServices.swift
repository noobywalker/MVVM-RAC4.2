//
//  RWTViewModelServices.swift
//  MVVM_Tutorial
//
//  Created by Waratnan Suriyasorn on 6/22/2559 BE.
//  Copyright © 2559 Waratnan Suriyasorn. All rights reserved.
//

import Foundation

protocol RWTViewModelServices {
    
    func getFlickrSearchService() -> RWTFlickrSearch
    func pushViewModel(viewModel:AnyObject)
}
//
//  RWTFlickrSearchImpl.swift
//  MVVM_Tutorial
//
//  Created by Waratnan Suriyasorn on 6/22/2559 BE.
//  Copyright © 2559 Waratnan Suriyasorn. All rights reserved.
//

import Foundation
import ReactiveCocoa
import objectiveflickr
import SwiftyJSON

class RWTFlickrSearchImpl: NSObject, RWTFlickrSearch, OFFlickrAPIRequestDelegate {

	var flickrContext: OFFlickrAPIContext!
	var request: NSMutableSet!

	func flickrSearchSignal(searchString: String) -> RACSignal {
		return self.signalFromAPIMethod("flickr.photos.search", args: ["text": searchString, "sort": "interestingness-desc"]){ data -> AnyObject! in
            
            print(data)
            
            let json = JSON(data)
            
            let result = RWTFlickrSearchResults()
            result.searchString = searchString
            result.totalResults = json["photos"]["total"].intValue
            
            let array = json["photos"]["photo"].arrayValue
            var photos:[RWTFlickrPhoto] = []
            for jsonObj in array {
                
                let photo = RWTFlickrPhoto()
                photo.title = jsonObj["title"].stringValue
                photo.identifier = jsonObj["id"].stringValue
                photo.url = self.flickrContext.photoSourceURLFromDictionary(jsonObj.dictionaryObject, size: OFFlickrSmallSize)
                
                photos.append(photo)
            }
            result.photos = photos
            
            return result
        }
	}

	override init() {
		super.init()
		let key = "a3bfd21b1bf7fff0a1f1f876f0daa9e9"
		let secret = "8d9df7824cd982af"
		self.flickrContext = OFFlickrAPIContext(APIKey: key, sharedSecret: secret)
		self.request = NSMutableSet()
	}

	func signalFromAPIMethod(method: String, args: [String: AnyObject], transform:(AnyObject!) -> AnyObject!) -> RACSignal {
		return RACSignal.createSignal { subscriber -> RACDisposable! in
			let flickrRequest = OFFlickrAPIRequest(APIContext: self.flickrContext)
			flickrRequest.delegate = self
			self.request.addObject(flickrRequest)

			let successSignal = self.rac_signalForSelector(#selector(OFFlickrAPIRequestDelegate.flickrAPIRequest(_: didCompleteWithResponse:)), fromProtocol: OFFlickrAPIRequestDelegate.self)
            
			successSignal.map { data in
				let tuple = data as! RACTuple
				return tuple.second
			}.map(transform)
            .subscribeNext { (obj) in
                print(obj)
				subscriber.sendNext(obj)
				subscriber.sendCompleted()
			}

			flickrRequest.callAPIMethodWithGET(method, arguments: args)

			return RACDisposable.init(block: {
				self.request .removeObject(flickrRequest)
			})
		}
	}
}
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
		return self.signalFromAPIMethod("flickr.photos.search", args: ["text": searchString, "sort": "interestingness-desc"]) { data -> AnyObject! in

			let json = JSON(data)

			let result = RWTFlickrSearchResults()
			result.searchString = searchString
			result.totalResults = json["photos"]["total"].intValue

			let array = json["photos"]["photo"].arrayValue
			var photos: [RWTFlickrPhoto] = []
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

	func signalFromAPIMethod(method: String, args: [String: AnyObject], transform: (AnyObject!) -> AnyObject!) -> RACSignal {
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
					subscriber.sendNext(obj)
					subscriber.sendCompleted()
			}

			flickrRequest.callAPIMethodWithGET(method, arguments: args)

			return RACDisposable.init(block: {
				self.request .removeObject(flickrRequest)
			})
		}
	}
    
    func flickrImageMetadata(photoId: String) -> SignalProducer<RWTFlickrPhotoMetadata, NSError> {
        
        let favouritesSignal = signalFromAPIMethod("flickr.photos.getFavorites",
                                                   arguments: ["photo_id": photoId]) { (response: NSDictionary) -> NSString in
                                                    return response.valueForKeyPath("photo.total") as! String
        }
        
        let commentsSignal = signalFromAPIMethod("flickr.photos.getInfo",
                                                 arguments: ["photo_id": photoId]) { (response: NSDictionary) -> NSString in
                                                    return response.valueForKeyPath("photo.comments._text") as! String
        }
        
        return combineLatest(favouritesSignal, commentsSignal).map { (f, c) -> RWTFlickrPhotoMetadata in
            return RWTFlickrPhotoMetadata(favourites: f.integerValue, comments: c.integerValue)
        }
        
    }
    
    private func signalFromAPIMethod<T: AnyObject>(method: String, arguments: [String:String], logging: Bool = false, transform: (NSDictionary) -> T) -> SignalProducer<T, NSError> {
        
        return SignalProducer { (observer: Observer<T, NSError>, disposable: CompositeDisposable) -> () in
            
            let flickrRequest = OFFlickrAPIRequest(APIContext: self.flickrContext)
            flickrRequest.delegate = self
            self.request.addObject(flickrRequest)
            
            // Success
            let successSignal = self.rac_signalForSelector(#selector(OFFlickrAPIRequestDelegate.flickrAPIRequest(_:didCompleteWithResponse:)), fromProtocol: OFFlickrAPIRequestDelegate.self).doNext({ (obj) -> Void in
                if (logging) {
                    NSLog("\(obj)")
                }
            })
                .toSignalProducer().map { $0 as! RACTuple }.map { (req: $0.first as? OFFlickrAPIRequest, resp: $0.second as? NSDictionary) }
            
            successSignal.filter { $0.req! == flickrRequest }
                .map { $0.resp! }
                .map(transform)
                .startWithNext{ (next: T) -> () in
                    observer.sendNext(next)
                    observer.sendCompleted()
            }
            
            // Fail
            let failSignal = self.rac_signalForSelector(#selector(OFFlickrAPIRequestDelegate.flickrAPIRequest(_:didFailWithError:)), fromProtocol: OFFlickrAPIRequestDelegate.self)
                .toSignalProducer()
                .map { $0 as! RACTuple }
                .map {
                    (req: $0.first as? OFFlickrAPIRequest, resp: $0.second as? NSError!)
            }
            
            failSignal.map { $0.resp }
                .startWithNext { (error) -> () in
                    observer.sendFailed(error!)
            }
            
            // Fire
            flickrRequest.callAPIMethodWithGET(method, arguments: arguments)
            
            // Schedule cleanup
            disposable.addDisposable({ () -> () in
                self.request.removeObject(flickrRequest)
            })
        }
        
    }

}
//
//  RWTSearchResultsTableViewCell.swift
//  MVVM_Tutorial
//
//  Created by Waratnan Suriyasorn on 6/22/2559 BE.
//  Copyright © 2559 Waratnan Suriyasorn. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SDWebImage
class RWTSearchResultsTableViewCell: UITableViewCell {

	@IBOutlet weak var imageThumbnailView: UIImageView!

	@IBOutlet weak var titleLabel: UILabel!

	@IBOutlet weak var commentsIcon: UIImageView!
	@IBOutlet weak var commentsLabel: UILabel!

	@IBOutlet weak var favouritesIcon: UIImageView!
	@IBOutlet weak var favouritesLabel: UILabel!
    
    var viewModel: RWTSearchResultsItemViewModel! {
        didSet {
            self.bindViewModel()
        }
    }
    
    func bindViewModel() {
        let photo = viewModel
        
        titleLabel.text = photo.title
//        signalForImage(photo.url).startOn(backgroundScheduler())
//            .takeUntil(self.rac_prepareForReuseSignal.toSignalProducer().map { _ in () }.mapError { $0 as! NoError })
//            .observeOn(UIScheduler())
//            .startWithNext { (image) -> () in
//                self.imageThumbnailView.image = image
//        }
        
        self.imageThumbnailView.sd_setImageWithURL(photo.url)
        
        photo.favourites.producer.startWithNext {
            self.favouritesLabel.text = $0 == nil ? "" : "\($0!)"
            self.favouritesIcon.hidden = $0 == nil
        }
        
        photo.comments.producer.startWithNext {
            self.commentsLabel.text = $0 == nil ? "" : "\($0!)"
            self.commentsIcon.hidden = $0 == nil
        }
        
        photo.isVisible.value = true
        self.rac_prepareForReuseSignal.toSignalProducer().startWithNext { _ in
            self.imageThumbnailView.image = nil
            self.viewModel.isVisible.value = false
        }
        
    }
    
    func signalForImage(imageUrl: NSURL) -> SignalProducer<UIImage, NSError> {
        let signal = SignalProducer<UIImage, NSError> {
            (observer, _) in
            let data = NSData(contentsOfURL: imageUrl)!
            let image = UIImage(data: data)!
            observer.sendNext(image)
            observer.sendCompleted()
        }
        
        return signal
    }

}

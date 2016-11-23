/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
import UIKit

public class RatingView_default_like: BaseScreenletView, RatingViewModel {

	@IBOutlet weak var likeButton: UIButton? {
		didSet {
			let image = NSBundle.imageInBundles(
				name: "default-thumb-up",
				currentClass: RatingView_default_like.self)?.imageWithRenderingMode(.AlwaysTemplate)
			self.likeButton?.setBackgroundImage(image, forState: .Normal)
		}
	}
	
	@IBOutlet weak var countLabel: UILabel?
	
	public var defaultRatingsGroupCount: Int32 = 1
	
	//MARK: BaseScreenletView
	
	public override func createProgressPresenter() -> ProgressPresenter {
		return NetworkActivityIndicatorPresenter()
	}
	
	override public var progressMessages: [String:ProgressMessages] {
		return [
			RatingScreenlet.LoadRatingsAction : [.Working : ""],
			RatingScreenlet.UpdateRatingAction : [.Working : ""],
			RatingScreenlet.DeleteRatingAction : [.Working : ""],
		]
	}

	public var ratingEntry: RatingEntry? {
		didSet {
			if let rating = ratingEntry {
				self.countLabel?.text = NSString.localizedStringWithFormat(LocalizedString("default", key: "rating-total", obj: self), rating.totalCount) as String

				if rating.userScore == -1 {
					self.likeButton?.tintColor = UIColor.grayColor()
					self.likeButton?.restorationIdentifier = RatingScreenlet.UpdateRatingAction
				}
				else {
					self.likeButton?.tintColor = DefaultThemeBasicBlue
					self.likeButton?.restorationIdentifier = RatingScreenlet.DeleteRatingAction
				}
			}
		}
	}
	
	@IBAction func likeButtonClicked(sender: AnyObject) {
		self.userAction(
			name: self.likeButton?.restorationIdentifier,
			sender: self.ratingEntry?.userScore == -1 ? 1 : 0)
	}
	
}

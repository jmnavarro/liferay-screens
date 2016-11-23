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
import Cosmos

public class RatingView_default_stars: BaseScreenletView, RatingViewModel {
	
	@IBOutlet weak var userRatingBar: CosmosView? {
		didSet {
			userRatingBar?.didFinishTouchingCosmos = {
				let score = $0 / Double(self.userRatingBar!.settings.totalStars)
				
				if (self.selectedUserScore != score) {
					self.selectedUserScore = score
					self.userAction(
						name: RatingScreenlet.UpdateRatingAction,
						sender: score)
				}
			}
		}
	}
	
	@IBOutlet weak var averageRatingBar: CosmosView?
	
	public var defaultRatingsGroupCount: Int32 = 1

	private var selectedUserScore: NSNumber?


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
				averageRatingBar?.rating =
					rating.average * Double(self.averageRatingBar!.settings.totalStars)
				averageRatingBar?.text = LocalizedPlural("default",
					keySingular: "rating-ratings.one", keyPlural: "rating-ratings.other",
					obj: self, count: rating.totalCount)
				userRatingBar?.rating = rating.userScore * Double(self.userRatingBar!.settings.totalStars)
				selectedUserScore = rating.userScore
			}
		}
	}
}

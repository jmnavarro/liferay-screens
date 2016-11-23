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
import LRMobileSDK

public class RatingUpdateLiferayConnector: ServerConnector {
	
	let classPK: Int64
	let className: String
	let score: Double
	let ratingsGroupCount: Int32
	
	var resultRating: RatingEntry?
	
	public init(classPK: Int64, className: String, score: Double, ratingsGroupCount: Int32) {
		self.ratingsGroupCount = ratingsGroupCount
		self.score = score
		self.className = className
		self.classPK = classPK
		super.init()
	}
	
	public override func validateData() -> ValidationError? {
		let error = super.validateData()
		
		if error == nil {
			if classPK == 0 {
				return ValidationError("rating-screenlet", "undefined-classPK")
			}
			else if className == "" {
				return ValidationError("rating-screenlet", "undefined-className")
			}
			else if ratingsGroupCount < 1 {
				return ValidationError("rating-screenlet", "wrong-ratingsGroupCount")
			}
			else if score < 0 || score > 1 {
				return ValidationError("rating-screenlet", "wrong-score")
			}
		}
		
		return error
	}
	
}

public class Liferay70RatingUpdateConnector: RatingUpdateLiferayConnector {
	
	override public func doRun(session session: LRSession) {
		let service = LRScreensratingsentryService_v70(session: session)
		
		do {
			let result = try service.updateRatingsEntryWithClassPK(classPK, className: className, score: score, ratingsLength: ratingsGroupCount)
			lastError = nil
			resultRating = RatingEntry(attributes: result as! [String: AnyObject])
		}
		catch let error as NSError {
			lastError = error
			resultRating = nil
		}
	}
	
}

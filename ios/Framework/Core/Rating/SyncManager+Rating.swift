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
import Foundation

extension SyncManager {

	func ratingsSynchronizer(
			key: String,
			attributes: [String:AnyObject])
			-> Signal -> () {

		if key.hasPrefix("delete-") {
			return deleteRatingSynchronizer(key, attributes: attributes)
		}
		else if key.hasPrefix("update-") {
			return updateRatingSynchronizer(key, attributes: attributes)
		}

		return { _ in }
	}

	func deleteRatingSynchronizer(
			key: String,
			attributes: [String:AnyObject])
			-> Signal -> () {
		return { signal in
			let className = attributes["className"] as! String
			let classPK = (attributes["classPK"] as! NSNumber).longLongValue
			let ratingsGroupCount = Int32(attributes["ratingsGroupCount"] as! Int)

			let interactor = DeleteRatingInteractor(
					className: className,
					classPK: classPK,
					ratingsGroupCount: ratingsGroupCount)

			self.prepareInteractorForSync(interactor,
					key: key,
					attributes: attributes,
					signal: signal,
					screenletClassName: "RatingsScreenlet")

			if !interactor.start() {
				self.delegate?.syncManager?(self,
						onItemSyncScreenlet: "RatingsScreenlet",
						failedKey: key,
						attributes: attributes,
						error: NSError.errorWithCause(.NotAvailable))
				signal()
			}
		}
	}

	func updateRatingSynchronizer(
			key: String,
			attributes: [String:AnyObject])
			-> Signal -> () {
		return { signal in
			let className = attributes["className"] as! String
			let classPK = (attributes["classPK"] as! NSNumber).longLongValue
			let ratingsGroupCount = Int32(attributes["ratingsGroupCount"] as! Int)
			let score = (attributes["score"] as! NSNumber).doubleValue

			let interactor = UpdateRatingInteractor(
					className: className,
					classPK: classPK,
					score: score,
					ratingsGroupCount: ratingsGroupCount)

			self.prepareInteractorForSync(interactor,
					key: key,
					attributes: attributes,
					signal: signal,
					screenletClassName: "RatingsScreenlet")

			if !interactor.start() {
				self.delegate?.syncManager?(self,
						onItemSyncScreenlet: "RatingsScreenlet",
						failedKey: key,
						attributes: attributes,
						error: NSError.errorWithCause(.NotAvailable))
				signal()
			}
		}
	}

}

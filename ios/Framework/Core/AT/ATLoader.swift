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


@objc public class ATAsset : NSObject {
	let className: String
	let classPK: Int64

	init(className: String, classPK: Int64) {
		self.className = className
		self.classPK = classPK

		super.init()
	}
}

@objc public protocol ATLoaderDelegate {

	optional func audienceTargetingLoader(loader: ATLoader,
			onAssetRetrieved asset: ATAsset?,
			forPlaceholderId: String)

	optional func audienceTargetingLoader(loader: ATLoader,
			onCustomContentRetrieved customContent: String?,
			forPlaceholderId: String)

	optional func audienceTargetingLoader(loader: ATLoader,
			onRetrieveCompleted placeholderIds: [String])

	optional func audienceTargetingLoader(loader: ATLoader,
			onRetrieveError error: NSError,
			forPlaceholderIds: [String])

}

@objc public class ATLoader : NSObject {

	public weak var delegate: ATLoaderDelegate?

	private var groupId: Int64
	private var appId: String

	private var customContentCache: [String: String] = [:]
	private var assetCache: [String: ATAsset] = [:]

	private var lastUserSegmentIds = [Int64]()

	public init(groupId: Int64, appId: String) {
		self.groupId = groupId
		self.appId = appId

		super.init()
	}

	public class func computeUserContext() -> [String:String] {
		var result = [String:String]()

		if SessionContext.hasSession {
			result["userId"] = (SessionContext.userAttribute("userId") as! Int).description
		}

		// device
		result["os-name"] = "ios"
		result["os-version"] = NSProcessInfo.processInfo().operatingSystemVersionString

		result["locale"] = NSLocale.currentLocaleString

		// more...

		return result
	}

	public func clearCache() {
		customContentCache.removeAll(keepCapacity: true)
		assetCache.removeAll(keepCapacity: true)
	}

	public func clearCache(#key: String) {
		customContentCache.removeValueForKey(key)
		assetCache.removeValueForKey(key)
	}

	public func isCached(#placeholderId: String) -> Bool {
		return customContentCache[placeholderId] != nil
				|| assetCache[placeholderId] != nil
	}

	public func belongsToSegment(segmentId: Int64) -> Bool {
		return contains(lastUserSegmentIds, segmentId)
	}

	public func customContent(
			#placeholderId: String,
			context: [String:String]?,
			result: (String?, NSError?) -> Void) {

		if let cachedValue = customContentCache[placeholderId] {
			result(cachedValue, nil)
		}
		else {
			retrieveCustomContent(
					placeholderId: placeholderId,
					context: context,
					result: result)
		}
	}

	public func retrieveCustomContent(
			#placeholderId: String,
			context: [String:String]?,
			result: (String?, NSError?) -> Void) {

		let operation = ATLoadPlaceholderOperation()

		operation.groupId = (groupId != 0) ? groupId : LiferayServerContext.groupId
		operation.appId = appId
		operation.placeholderIds = [placeholderId]
		operation.userContext = ((ATLoader.computeUserContext() + (context ?? [:])) as! [String:String])

		// TODO retain-cycle on operation?
		operation.onComplete = {
			let loadOp = $0 as! ATLoadPlaceholderOperation

			if let error = $0.lastError {
				result(nil, error)

				self.delegate?.audienceTargetingLoader?(self,
						onRetrieveError: error,
						forPlaceholderIds: loadOp.placeholderIds!)
			}
			else {
				let placeholderId = loadOp.placeholderIds!.first!
				let resultMap = loadOp.firstResultForPlaceholderId(placeholderId)
				self.lastUserSegmentIds = resultMap?.segmentIds
						?? self.lastUserSegmentIds

				if let customContent = resultMap?.customContent,
					localizedContent = customContent[NSLocale.currentLanguageString]
						?? customContent["en_US"] {
					self.customContentCache[placeholderId] = localizedContent

					result(localizedContent, nil)

					self.delegate?.audienceTargetingLoader?(self,
							onCustomContentRetrieved: localizedContent,
							forPlaceholderId: placeholderId)
				}
				else {
					// no error, no content
					result(nil, nil)

					self.delegate?.audienceTargetingLoader?(self,
							onCustomContentRetrieved: nil,
							forPlaceholderId: placeholderId)
				}
			}
		}

		if !operation.validateAndEnqueue() {
			let error = NSError.errorWithCause(.AbortedDueToPreconditions)

			result(nil, error)

			self.delegate?.audienceTargetingLoader?(self,
					onRetrieveError: error,
					forPlaceholderIds: operation.placeholderIds!)
		}
	}

	public func assetContent(
			#placeholderId: String,
			context: [String:String]?,
			result: (ATAsset?, NSError?) -> Void) {

		if let cachedValue = assetCache[placeholderId] {
			result(cachedValue, nil)
		}
		else {
			retrieveAsset(
					placeholderId: placeholderId,
					context: context,
					result: result)
		}
	}

	public func retrieveAsset(
			#placeholderId: String,
			context: [String:String]?,
			result: (ATAsset?, NSError?) -> Void) {

		let operation = ATLoadPlaceholderOperation()

		operation.groupId = (groupId != 0) ? groupId : LiferayServerContext.groupId
		operation.appId = appId
		operation.placeholderIds = [placeholderId]
		operation.userContext = ((ATLoader.computeUserContext() + (context ?? [:])) as! [String:String])

		// TODO retain-cycle on operation?
		operation.onComplete = {
			let loadOp = $0 as! ATLoadPlaceholderOperation

			if let error = $0.lastError {
				result(nil, error)

				self.delegate?.audienceTargetingLoader?(self,
						onRetrieveError: error,
						forPlaceholderIds: loadOp.placeholderIds!)
			}
			else {
				let placeholderId = loadOp.placeholderIds!.first!
				let resultMap = loadOp.firstResultForPlaceholderId(placeholderId)
				self.lastUserSegmentIds = resultMap?.segmentIds
						?? self.lastUserSegmentIds

				if let className = resultMap?.className,
						classPK = resultMap?.classPK {
					let asset = ATAsset(className: className, classPK: classPK)
					self.assetCache[placeholderId] = asset

					result(asset, nil)

					self.delegate?.audienceTargetingLoader?(self,
							onAssetRetrieved: asset,
							forPlaceholderId: placeholderId)
				}
				else {
					// no error, no content
					result(nil, nil)

					self.delegate?.audienceTargetingLoader?(self,
							onAssetRetrieved: nil,
							forPlaceholderId: placeholderId)
				}
			}
		}

		if !operation.validateAndEnqueue() {
			let error = NSError.errorWithCause(.AbortedDueToPreconditions)

			result(nil, error)

			self.delegate?.audienceTargetingLoader?(self,
					onRetrieveError: error,
					forPlaceholderIds: operation.placeholderIds!)
		}
	}

	public func retrieveAll(
			#context: [String:String]?,
			onResult: (String, AnyObject?) -> Void,
			onError: (NSError) -> Void) {

		retrieveAll(placeholderIds: [], context: context, onResult: onResult, onError: onError)
	}

	public func retrieveAll(
			#placeholderIds: [String],
			context: [String:String]?,
			onResult: (String, AnyObject?) -> Void,
			onError: (NSError) -> Void) {

		let operation = ATLoadPlaceholderOperation()

		operation.groupId = (groupId != 0) ? groupId : LiferayServerContext.groupId
		operation.appId = appId
		operation.placeholderIds = placeholderIds.isEmpty ? nil : placeholderIds
		operation.userContext = ((ATLoader.computeUserContext() + (context ?? [:])) as! [String:String])

		// TODO retain-cycle on operation?
		operation.onComplete = {
			let loadOp = $0 as! ATLoadPlaceholderOperation

			if let error = $0.lastError {
				onError(error)

				self.delegate?.audienceTargetingLoader?(self,
						onRetrieveError: error,
						forPlaceholderIds: loadOp.placeholderIds!)
			}
			else {
				let loadOp = $0 as! ATLoadPlaceholderOperation

				var retrievedIds = [String]()

				for (placeholderId, maps) in loadOp.results! {
					let map = maps.first!

					self.lastUserSegmentIds = map.segmentIds
							?? self.lastUserSegmentIds

					if let customContent = map.customContent,
							localizedContent = customContent[NSLocale.currentLanguageString]
								?? customContent["en_US"] {
						self.customContentCache[placeholderId] = localizedContent

						onResult(placeholderId, localizedContent)

						self.delegate?.audienceTargetingLoader?(self,
								onCustomContentRetrieved: localizedContent,
								forPlaceholderId: placeholderId)

						retrievedIds.append(placeholderId)
					}
					else if let className = map.className,
							classPK = map.classPK {
						let asset = ATAsset(className: className, classPK: classPK)
						self.assetCache[placeholderId] = asset

						onResult(placeholderId, asset)

						self.delegate?.audienceTargetingLoader?(self,
								onAssetRetrieved: asset,
								forPlaceholderId: placeholderId)

						retrievedIds.append(placeholderId)
					}
					else {
						// no error, no content
						onResult(placeholderId, nil)

						self.delegate?.audienceTargetingLoader?(self,
							onAssetRetrieved: nil,
							forPlaceholderId: placeholderId)
					}
				}

				self.delegate?.audienceTargetingLoader?(self,
						onRetrieveCompleted: retrievedIds)
			}
		}

		if !operation.validateAndEnqueue() {
			let error = NSError.errorWithCause(.AbortedDueToPreconditions)

			onError(error)

			self.delegate?.audienceTargetingLoader?(self,
					onRetrieveError: error,
					forPlaceholderIds: placeholderIds)
		}
	}

}

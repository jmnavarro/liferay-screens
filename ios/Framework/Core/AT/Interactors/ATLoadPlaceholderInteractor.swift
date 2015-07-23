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


class AudienceTargetingLoadPlaceholderInteractor: Interactor {

	let groupId: Int64
	let appId: String
	let placeholderId: String
	let context: [String:String]

	var resultClassPK: String?
	var resultClassName: String?
	var resultCustomContent: [String:String]?

	var resultContent: AnyObject?
	var resultMimeType: String?


	init(screenlet: BaseScreenlet,
			groupId: Int64,
			appId: String,
			placeholderId: String,
			context: [String:String]) {

		self.groupId = (groupId != 0) ? groupId : LiferayServerContext.groupId
		self.appId = appId
		self.placeholderId = placeholderId
		self.context = context

		super.init(screenlet: screenlet)
	}

	override func start() -> Bool {
		let result = createAudienceTargetingOperation().validateAndEnqueue()

		if !result {
			self.callOnFailure(NSError.errorWithCause(.AbortedDueToPreconditions))
		}

		return result
	}

	func createAudienceTargetingOperation() -> AudienceTargetingLoadPlaceholderOperation {
		let operation = AudienceTargetingLoadPlaceholderOperation(screenlet: self.screenlet)

		operation.groupId = self.groupId
		operation.appId = self.appId
		operation.placeholderIds = [self.placeholderId]
		operation.userContext = ((AudienceTargetingLoader.computeUserContext() + context) as! [String:String])

		// TODO retain-cycle on operation?
		operation.onComplete = {
			let loadOp = ($0 as! AudienceTargetingLoadPlaceholderOperation)

			if let error = $0.lastError {
				self.callOnFailure(error)
			}
			else if let result = loadOp.firstResultForPlaceholderId(self.placeholderId) {
				if let customContent = result.customContent {
					self.resultCustomContent = customContent
					self.resultClassName = nil
					self.resultClassPK = nil

					self.callOnSuccess()
				}
				else {
					if let className = result.className,
							classPK = result.classPK?.description {
						self.resultClassName = className
						self.resultClassPK = classPK

						self.startContentOperation(
								className: className,
								classPK: classPK);
					}
					else {
						self.callOnFailure(NSError.errorWithCause(.InvalidServerResponse))
					}
				}
			}
			else {
				// no content
				self.resultCustomContent = nil
				self.resultClassName = nil
				self.resultClassPK = nil

				self.callOnSuccess()
			}
		}

		return operation
	}

	func startContentOperation(#className: String, classPK: String) {
		if let op = createContentOperation(className: className, classPK: classPK) {
			if !op.validateAndEnqueue() {
				self.callOnFailure(NSError.errorWithCause(.InvalidServerResponse))
			}
		}
		else {
			self.callOnFailure(NSError.errorWithCause(.InvalidServerResponse))
		}
	}

	func createContentOperation(#className: String, classPK: String) -> ServerOperation? {
		var operation: ServerOperation? = nil

		if className == "com.liferay.portlet.documentlibrary.model.DLFileEntry" {
			let op = LoadDLEntryOperation(screenlet: self.screenlet)

			if let fileEntryId = classPK.toInt() {
				op.fileEntryId = Int64(fileEntryId)

				// TODO retain-cycle on operation?
				op.onComplete = {
					if let error = $0.lastError {
						self.callOnFailure(error)
					}
					else if let loadOp = ($0 as? LoadDLEntryOperation),
							resultGroupId = loadOp.resultGroupId,
							resultFolderId = loadOp.resultFolderId,
							resultName = loadOp.resultName,
							resultUUID = loadOp.resultUUID,
							resultMimeType = loadOp.resultMimeType {

						self.resultContent = "\(LiferayServerContext.server)/documents/" +
								"\(resultGroupId)/\(resultFolderId)/" +
								"\(resultName)/\(resultUUID)"
						self.resultMimeType = resultMimeType

						self.callOnSuccess()
					}
					else {
						self.callOnFailure(NSError.errorWithCause(.InvalidServerResponse))
					}
				}

				operation = op
			}
		}

		return operation
	}

}

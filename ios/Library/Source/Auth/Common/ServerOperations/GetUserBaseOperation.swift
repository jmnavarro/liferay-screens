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

public class GetUserBaseOperation: ServerOperation {

	public var resultUserAttributes: [String:AnyObject]?

	public var userName: String?
	public var password: String?

	//MARK: ServerOperation

	override internal func validateData() -> Bool {
		if userName == nil || password == nil {
			userName = SessionContext.currentUserName
			password = SessionContext.currentPassword
		}

		return (userName != nil && password != nil)
	}

	override internal func preRun() -> Bool {
		if !SessionContext.hasSession {
			SessionContext.createSession(
					username: userName!,
					password: password!,
					userAttributes: [:])
		}

		return true
	}

	override internal func postRun() {
		if SessionContext.userAttribute("userId") == nil {
			// the session was created ad-hoc for self.userName
			if lastError == nil {
				SessionContext.createSession(
						username: userName!,
						password: password!,
						userAttributes: resultUserAttributes!)
			}
			else {
				SessionContext.clearSession()
			}
		}
	}

	override internal func doRun(#session: LRSession) {
		var outError: NSError?

		resultUserAttributes = nil

		let result = sendGetUserRequest(
				service: LRUserService_v62(session: session),
				error: &outError)

		if outError != nil {
			lastError = outError
			resultUserAttributes = nil
		}
		else if result?["userId"] == nil {
			lastError = createError(cause: .InvalidServerResponse, userInfo: nil)
			resultUserAttributes = nil
		}
		else {
			lastError = nil
			resultUserAttributes = result as? [String:AnyObject]
		}
	}


	// MARK: Template methods

	internal func sendGetUserRequest(
			#service: LRUserService_v62,
			error: NSErrorPointer)
			-> NSDictionary? {

		assertionFailure("sendGetUserRequest must be overriden")

		return nil
	}

   
}

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

//@objc(LoginWidget)
class LoginWidget: BaseWidget {

	override func onCreate()  {
		loginView().emailField.text = "test@liferay.com"
	}

	override func onCustomAction(actionName: String, sender: UIControl) {
		if actionName == "login-action" {
			sendLoginWithUsername(loginView().emailField.text, password:loginView().passwordField.text)
		}
	}

	func loginView() -> LoginView {
		return self.widgetView as LoginView
	}

	func sendLoginWithUsername(username:String, password:String) {
		showHUDWithMessage("Sending sign in...", details:"Wait few seconds...")

		LiferayContext.instance.currentSession = nil

		let session = LiferayContext.instance.createSession(username, password: password)
		session.callback = self

		let service = LRUserService_v62(session: session)

		let companyId: CLongLong = (LiferayContext.instance.companyId as NSNumber).longLongValue
		var outError: NSError?

		service.getUserByEmailAddressWithCompanyId(companyId, emailAddress: username, error: &outError)

		if let error = outError {
			self.onFailure(error)
		}
	}

	override func onServerError(error: NSError) {
		LiferayContext.instance.clearSession()
		self.hideHUDWithMessage("Error signing in!", details: nil)
	}

	override func onServerResult(result: AnyObject!) {
		self.hideHUDWithMessage("Sign in completed", details: nil)
	}

}

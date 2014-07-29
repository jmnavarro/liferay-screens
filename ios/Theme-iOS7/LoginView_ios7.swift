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

class LoginView_ios7: LoginView {

	@IBOutlet var usernamePlaceholder: UILabel?
	@IBOutlet var passwordPlaceholder: UILabel?

	func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {

		let newText = textField.text.bridgeToObjectiveC().stringByReplacingCharactersInRange(range, withString:string)

		let placeHolder = textField == usernameField ? usernamePlaceholder : passwordPlaceholder

		showPlaceholder(placeHolder!, show:newText == "")

		return true

	}

	private func showPlaceholder(placeholder:UILabel, show:Bool) {
		UIView.animateWithDuration(0.3, animations: {
			placeholder.alpha = show ? 1.0 : 0.0
		})
	}

	override func setAuthType(authType: String) {
		super.setAuthType(authType)

		usernameField!.text = "";

		if usernameField!.text != "" {
			usernamePlaceholder!.text = ""
		}
		else {
			usernamePlaceholder!.text = usernameField!.placeholder;
		}

		if passwordField!.text != "" {
			passwordPlaceholder!.text = ""
		}
		else {
			passwordPlaceholder!.text = passwordField!.placeholder;
		}

		usernameField!.placeholder = "";
		passwordField!.placeholder = "";
	}


}

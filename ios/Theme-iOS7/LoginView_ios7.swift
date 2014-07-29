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

	@IBOutlet var titleLabel: UILabel?
	@IBOutlet var subtitleLabel: UILabel?
	@IBOutlet var usernamePlaceholder: UILabel?
	@IBOutlet var passwordPlaceholder: UILabel?

	override public func setTranslations(bundle:NSBundle) {
		super.setTranslations(bundle)

		titleLabel!.text = NSLocalizedString("theme-ios7-login-title", tableName: "ios7", bundle: bundle, value: "", comment: "")
		subtitleLabel!.text = NSLocalizedString("theme-ios7-login-subtitle", tableName: "ios7", bundle: bundle, value: "", comment: "")
		usernamePlaceholder!.text = NSLocalizedString("theme-ios7-login-email", tableName: "ios7", bundle: bundle, value: "", comment: "")
		passwordPlaceholder!.text = NSLocalizedString("theme-ios7-login-password", tableName: "ios7", bundle: bundle, value: "", comment: "")

		let str = loginButton!.attributedTitleForState(UIControlState.Normal)
		let translated = NSLocalizedString("theme-ios7-login-login", tableName: "ios7", bundle: bundle, value: "", comment: "")
		let newStr = NSMutableAttributedString(attributedString: str)
		newStr.replaceCharactersInRange(NSMakeRange(0, str.length), withString:translated)
		loginButton!.setAttributedTitle(newStr, forState: UIControlState.Normal)
	}

	func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {

		let newText = textField.text.bridgeToObjectiveC().stringByReplacingCharactersInRange(range, withString:string)

		let placeHolder = textField == usernameField ? usernamePlaceholder : passwordPlaceholder

		showPlaceholder(placeHolder!, show:newText == "")

		return true

	}

	private func showPlaceholder(placeholder:UILabel, show:Bool) {
		UIView.animateWithDuration(0.4, animations: {
			placeholder.alpha = show ? 1.0 : 0.0
		})
	}

	override func setAuthType(authType: String) {
		super.setAuthType(authType)

		usernameField!.placeholder = "";
		passwordField!.placeholder = "";
	}


}

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

enum AuthType: String {
	case Email = "email"
	case Screenname = "screenname"
}

class LoginView: BaseWidgetView, UITextFieldDelegate {

	@IBOutlet var usernameLabel: UILabel
	@IBOutlet var usernameField: UITextField
	@IBOutlet var passwordField: UITextField
	@IBOutlet var rememberSwitch: UISwitch?
	@IBOutlet var loginButton: UIButton

	var shouldRememberCredentials: Bool {
		println("should remember")
		if let rememberSwitchValue = rememberSwitch {
			return rememberSwitchValue.on
		}
		else {
			return false
		}
	}
	
	var authType : AuthType? {
	didSet {
		println("didSet auth" + authType!.toRaw())
        switch authType! {
        case AuthType.Email:
            usernameLabel.text = "Email"
            usernameField.keyboardType = UIKeyboardType.EmailAddress
        case AuthType.Screenname:
            usernameLabel.text = "Screen name"
            usernameField.keyboardType = UIKeyboardType.ASCIICapable
        default:
            usernameLabel.text = "Unknown"
        }
	}
	}


	// BaseWidgetView METHODS
    
    
    override func becomeFirstResponder() -> Bool {
        return usernameField.becomeFirstResponder()
    }
    
    
    // UITextFieldDelegate METHODS
    
    
	func textFieldShouldReturn(textField: UITextField!) -> Bool {
		if textField == usernameField {
			textField.resignFirstResponder()
			passwordField.becomeFirstResponder()
		}
		else if textField == passwordField {
			textField.resignFirstResponder()
			loginButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
			
		}

        return true
	}

}

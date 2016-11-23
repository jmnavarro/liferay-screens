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


public class SignUpView_default: BaseScreenletView, SignUpViewModel {

	@IBOutlet public var emailAddressField: UITextField?
	@IBOutlet public var passwordField: UITextField?
	@IBOutlet public var firstNameField: UITextField?
	@IBOutlet public var lastNameField: UITextField?
	@IBOutlet public var signUpButton: UIButton?

	@IBOutlet public var scrollView: UIScrollView?


	//MARK: BaseScreenletView

	override public var progressMessages: [String:ProgressMessages] {
		return [
			"signup-action" :
				[.Working : LocalizedString("default", key: "signup-loading-message", obj: self),
				.Failure : LocalizedString("default", key: "signup-loading-error", obj: self)],
			"save-action" :
				[.Working : LocalizedString("default", key: "signup-saving-message", obj: self),
				.Failure : LocalizedString("default", key: "signup-saving-error", obj: self)],
		]
	}

	override public func onStartInteraction() {
		signUpButton?.enabled = false
	}

	override public func onFinishInteraction(result: AnyObject?, error: NSError?) {
		signUpButton?.enabled = true
	}


	//MARK: BaseScreenletView

	override public func onCreated() {
		super.onCreated()

		setButtonDefaultStyle(signUpButton)
	}

	override public func onSetTranslations() {
		firstNameField?.placeholder = LocalizedString("default", key: "first-name-placeholder", obj: self)
		lastNameField?.placeholder = LocalizedString("default", key: "last-name-placeholder", obj: self)
		emailAddressField?.placeholder = LocalizedString("default", key: "auth-method-email", obj: self)
		passwordField?.placeholder = LocalizedString("default", key: "password-placeholder", obj: self)

		signUpButton?.replaceAttributedTitle(
				LocalizedString("default", key: "signup-button", obj: self),
				forState: .Normal)
	}

	override public func createProgressPresenter() -> ProgressPresenter {
		return DefaultProgressPresenter()
	}


	//MARK: SignUpViewModel

	public var emailAddress: String? {
		get {
			return nullIfEmpty(emailAddressField!.text)
		}
		set {
			emailAddressField!.text = newValue
		}
	}

	public var password: String? {
		get {
			return nullIfEmpty(passwordField?.text)
		}
		set {
			passwordField?.text = newValue
		}
	}

	public var firstName: String? {
		get {
			return nullIfEmpty(firstNameField?.text)
		}
		set {
			firstNameField?.text = newValue
		}
	}

	public var lastName: String? {
		get {
			return nullIfEmpty(lastNameField?.text)
		}
		set {
			lastNameField?.text = newValue
		}
	}

	public var editCurrentUser: Bool = false {
		didSet {
			let key: String
			let actionName: String

			if editCurrentUser {
				key = "save-button"
				actionName = "save-action"

				self.firstName = SessionContext.currentContext?.userAttribute("firstName") as? String
				self.middleName = SessionContext.currentContext?.userAttribute("middleName") as? String
				self.lastName = SessionContext.currentContext?.userAttribute("lastName") as? String
				self.emailAddress = SessionContext.currentContext?.userAttribute("emailAddress") as? String
				self.password = SessionContext.currentContext?.basicAuthPassword
				self.screenName = SessionContext.currentContext?.userAttribute("screenName") as? String
				self.jobTitle = SessionContext.currentContext?.userAttribute("jobTitle") as? String
			}
			else {
				key = "signup-button"
				actionName = "signup-action"
			}

			self.signUpButton?.replaceAttributedTitle(
					LocalizedString("default", key: key, obj: self),
					forState: .Normal)

			self.signUpButton?.restorationIdentifier = actionName
		}
	}


	// The following properties are not supported in this theme but
	// may be supported in a child theme

	public var screenName: String? {
		get { return nil }
		set {}
	}

	public var middleName: String? {
		get { return nil }
		set {}
	}

	public var jobTitle: String? {
		get { return nil }
		set {}
	}

}

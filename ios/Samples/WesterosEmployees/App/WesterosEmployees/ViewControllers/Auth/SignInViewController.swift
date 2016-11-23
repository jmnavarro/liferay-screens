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
import LiferayScreens


class SignInViewController: CardViewController, LoginScreenletDelegate, KeyboardListener {

	
	//MARK: Outlets
	@IBOutlet weak var loginScreenlet: LoginScreenlet?


	//MARK: Init methods

	convenience init() {
		self.init(nibName: "SignInViewController", bundle: nil)
	}


	//MARK: View actions

	@IBAction func forgotPasswordAction() {
		cardView?.moveRight()
	}


	//MARK: UIViewController

	override func viewDidLoad() {
		self.loginScreenlet?.delegate = self
	}


	//MARK: LoginScreenletDelegate

	func screenlet(screenlet: BaseScreenlet,
			onLoginResponseUserAttributes attributes: [String:AnyObject]) {
		SessionContext.currentContext?.storeCredentials()
		onDone?()
	}


	//MARK: CardViewController

	override func pageWillAppear() {
		registerKeyboardListener(self)
	}

	override func pageWillDisappear() {
		self.view.endEditing(true)
		unregisterKeyboardListener(self)
	}


	//MARK: KeyboardListener

	func showKeyboard(notif: NSNotification) {
		if cardView?.currentState == .Normal {
			cardView?.changeToState(.Maximized)
		}
	}

	func hideKeyboard(notif: NSNotification) {
		if cardView?.currentState == .Maximized {
			cardView?.changeToState(.Normal)
		}
	}

}

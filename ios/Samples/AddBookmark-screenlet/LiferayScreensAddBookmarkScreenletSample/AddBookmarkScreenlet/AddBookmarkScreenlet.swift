//
//  AddBookmarkScreenlet.swift
//  AddBookmarkScreenletSample
//
//  Created by jmWork on 18/05/15.
//  Copyright (c) 2015 Liferay. All rights reserved.
//

import UIKit
import LiferayScreens


public class AddBookmarkScreenlet: BaseScreenlet {

	@IBInspectable var allowsBrokenURL: Bool = false


	override public func createInteractor(name name: String?, sender: AnyObject?) -> Interactor? {
		switch name! {
		case "get-title":
			return createGetTitleInteractor()

		case "add-bookmark":
			return createAddBookmarkInteractor()

		default:
			return nil
		}
	}

	private func createGetTitleInteractor() -> GetSiteTitleInteractor {
		let interactor = GetSiteTitleInteractor(screenlet: self)

		// this shows the standard activity indicator in the screen...
		self.showHUDWithMessage("Getting site title...",
			closeMode: .Autoclose,
			spinnerMode: .IndeterminateSpinner)

		interactor.onSuccess = {
			self.hideHUD()

			// when the interactor is finished, set the resulting title in the title text field
			(self.screenletView as? AddBookmarkViewModel)?.title = interactor.resultTitle
		}

		interactor.onFailure = { err in
			self.showHUDWithMessage("An error occurred retrieving the title",
				closeMode: .ManualClose_TouchClosable,
				spinnerMode: .NoSpinner)
		}

		return interactor
	}

	private func createAddBookmarkInteractor() -> LiferayAddBookmarkInteractor {
		let interactor = LiferayAddBookmarkInteractor(screenlet: self)

		self.showHUDWithMessage("Saving bookmark...",
			closeMode: .Autoclose,
			spinnerMode: .IndeterminateSpinner)

		interactor.onSuccess = {
			self.showHUDWithMessage("Bookmark saved!",
				closeMode: .Autoclose_TouchClosable,
				spinnerMode: .NoSpinner)
		}

		interactor.onFailure = { e in
			self.showHUDWithMessage("An error occurred saving the bookmark",
				closeMode: .ManualClose_TouchClosable,
				spinnerMode: .NoSpinner)
		}

		return interactor
	}

}

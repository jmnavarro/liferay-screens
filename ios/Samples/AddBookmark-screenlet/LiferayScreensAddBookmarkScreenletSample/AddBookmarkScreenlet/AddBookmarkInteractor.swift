//
//  GetSiteTitleInteractor.swift
//  LiferayScreensAddBookmarkScreenletSample
//
//  Created by jmWork on 18/05/15.
//  Copyright (c) 2015 Liferay. All rights reserved.
//

import UIKit
import LiferayScreens

public class AddBookmarkInteractor: Interactor {

	public var resultBookmarkInfo: [String:AnyObject]?

	override public func start() -> Bool {
		let viewModel = self.screenlet.screenletView as! AddBookmarkViewModel

		if let URL = viewModel.URL {
			// 1. use MobileSDK's services to send the bookmark to the portal
			// 3. Save the response in the property 'resultBookmarkInfo'
			// 4. invoke callOnSuccess() or callOnFailure(error) when everything is done

			// return true to notify the operation is in progress
			return true
		}

		// return false if you cannot start the operation
		return false
	}
   
}

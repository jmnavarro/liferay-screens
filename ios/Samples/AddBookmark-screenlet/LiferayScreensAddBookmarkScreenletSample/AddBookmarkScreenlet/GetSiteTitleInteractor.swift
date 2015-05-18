//
//  GetSiteTitleInteractor.swift
//  LiferayScreensAddBookmarkScreenletSample
//
//  Created by jmWork on 18/05/15.
//  Copyright (c) 2015 Liferay. All rights reserved.
//

import UIKit
import LiferayScreens

public class GetSiteTitleInteractor: Interactor {

	public var resultTitle: String?

	private var session: NSURLSession?

	override public func start() -> Bool {
		let viewModel = self.screenlet.screenletView as! AddBookmarkViewModel

		if let URL = NSURL(string: viewModel.URL!) {

			let config = NSURLSessionConfiguration.defaultSessionConfiguration()
			session = NSURLSession(configuration: config)

			session?.dataTaskWithURL(URL) { data, response, error in
				if let errorValue = error {
					self.callOnFailure(errorValue)
				}
				else {
					let html = NSString(data: data, encoding: NSUTF8StringEncoding)
					self.resultTitle = html?.substringToIndex(10)
					self.callOnSuccess()
				}
			}

			// return true to notify the operation is in progress
			return true
		}

		// return false if you cannot start the operation
		return false
	}
   
}

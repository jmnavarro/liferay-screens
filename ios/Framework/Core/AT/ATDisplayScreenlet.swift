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


@objc public protocol ATDisplayScreenletDelegate {

	optional func screenlet(screenlet: ATDisplayScreenlet,
			onAudienceTargetingResponse value: AnyObject,
			mimeType: String?)

	optional func screenletOnAudienceTargetingEmptyResponse(
			screenlet: ATDisplayScreenlet)

	optional func screenlet(screenlet: ATDisplayScreenlet,
			onAudienceTargetingError error: NSError)

}


@IBDesignable public class ATDisplayScreenlet: BaseScreenlet {

	@IBInspectable public var appId: String = "" // should be Int64?
	@IBInspectable public var groupId: Int64 = 0
	@IBInspectable public var placeholderId: String = ""
	@IBInspectable public var autoLoad: Bool = true

	@IBOutlet public weak var delegate: ATDisplayScreenletDelegate?

	var context: [String:String]?


	//MARK: Public methods

	override public func onShow() {
		if autoLoad && appId != "" && placeholderId != "" {
			loadContent()
		}
	}

	override public func createInteractor(#name: String?, sender: AnyObject?) -> Interactor? {
		// what if we pass data to be used in rules evaluation in this request?
		let interactor = ATLoadPlaceholderInteractor(
				screenlet: self,
				groupId: self.groupId,
				appId: self.appId,
				placeholderId: self.placeholderId,
				context: context ?? [:])

		// force start here to avoid start-stop-start effects
		screenletView?.onStartOperation()

		interactor.onSuccess = {
			let viewModel = (self.screenletView as! ATDisplayViewModel)

			if interactor.resultCustomContent != nil || interactor.resultContent != nil {
				let content: AnyObject = interactor.resultCustomContent ?? interactor.resultContent!

				self.delegate?.screenlet?(self,
						onAudienceTargetingResponse: content,
						mimeType: interactor.resultMimeType)

				viewModel.setContent(content, mimeType: interactor.resultMimeType)
			}
			else {
				self.delegate?.screenletOnAudienceTargetingEmptyResponse?(self)

				viewModel.setEmptyContent()
			}

			self.screenletView?.onFinishOperation()
		}

		interactor.onFailure = {
			self.delegate?.screenlet?(self, onAudienceTargetingError: $0)
			self.screenletView?.onFinishOperation()
			return
		}

		return interactor
	}

	public func loadContent() -> Bool {
		return self.performDefaultAction()
	}

	public func loadContent(#context: [String:String]) -> Bool {
		self.context = context
		return self.performDefaultAction()
	}

}

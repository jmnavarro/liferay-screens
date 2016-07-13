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
import Foundation


@objc public protocol ImageDisplayScreenletDelegate : BaseScreenletDelegate {

	optional func screenlet(screenlet: ImageDisplayScreenlet, onImageAssetResponse image: UIImage) -> UIImage?

	optional func screenlet(screenlet: ImageDisplayScreenlet, onImageAssetError error: NSError)
}

public class ImageDisplayScreenlet: BaseScreenlet {

	@IBInspectable public var entryId: Int64 = 0

	@IBInspectable public var autoLoad: Bool = true

	public var imageDisplayDelegate: ImageDisplayScreenletDelegate? {
		return delegate as? ImageDisplayScreenletDelegate
	}

	//MARK: Public methods

	override public func onShow() {
		if autoLoad && entryId != 0 {
			loadImageAsset()
		}
	}

	public func loadImageAsset() -> Bool {
		return self.performDefaultAction()
	}
}
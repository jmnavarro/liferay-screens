//
//  BaseWidgetView.swift
//  liferay-mobile-widgets-swift
//
//  Created by jmWork on 01/07/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

import UIKit

class BaseWidgetView: UIView {

	typealias CustomActionType = (String, UIControl) -> (Void)

	var customAction: CustomActionType?

	override func awakeFromNib() {
		self.addCustomActionsForViews(self)
		self.onCreate();
	}

	func addCustomActionsForViews(parentView:UIView!) {
		for subview:AnyObject in parentView.subviews {
			if subview is UIControl {
				self.addCustomActionForControl(subview as UIControl)
			}
		}
	}

	func addCustomActionForControl(control:UIControl) {
		let currentActions = control.actionsForTarget(self, forControlEvent: UIControlEvents.TouchUpInside)

		if !currentActions || currentActions?.count == 0 {
			control.addTarget(self, action: "customActionHandler:", forControlEvents: UIControlEvents.TouchUpInside)
		}
	}

	func customActionHandler(sender:UIControl!) {
		self.endEditing(true)

		// WTF!
		// En teoría, un implicit optional se comporta igual que un puntero en Obj-C.
		// Mentira cochina. Si se accede a su valor cuando es nulo, casca.
		customAction?(sender.restorationIdentifier, sender)
	}

	func onCreate() {

	}


}

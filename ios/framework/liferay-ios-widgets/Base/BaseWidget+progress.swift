//
//  MBProgressHUD+widget.swift
//  liferay-swift-widgets
//
//  Created by jmWork on 01/07/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

import Foundation

// WTF!
// Este hack porque "Class variables not yet supported"
// o:=
struct Lock {
	static var token = "token"
}

struct MBProgressHUDInstance {
	static var instance:MBProgressHUD? = nil
}

extension BaseWidget {

	func synchronized(lock:AnyObject, closure: () -> ()) {
		objc_sync_enter(lock)
		closure()
		objc_sync_exit(lock)
	}

	func rootView(currentView:UIView) -> UIView {
		if !currentView.superview {
			return currentView;
		}

		return rootView(currentView.superview!)
	}

	func showHUDWithMessage(message:String?, details:String?) {
		synchronized(Lock.token) {
			if !MBProgressHUDInstance.instance {
				MBProgressHUDInstance.instance = MBProgressHUD.showHUDAddedTo(self.rootView(self), animated:true)
			}

			if message {
				MBProgressHUDInstance.instance!.labelText = message
			}

			MBProgressHUDInstance.instance!.detailsLabelText = details?
		}
	}

	func hideHUDWithMessage(message:String, details:String?) {
		synchronized(Lock.token) {
			if let instance = MBProgressHUDInstance.instance {
				instance.mode = MBProgressHUDModeText
				instance.labelText = message
				instance.detailsLabelText = details ? details : ""

				let len: Int = countElements(instance.labelText as String) + countElements(instance.detailsLabelText as String)
				let delay = 1.5 + (Double(len) * 0.01)

				instance.hide(true, afterDelay: delay)
			}
		}
	}

/*
	- (void)showHUD;
	- (void)hideHUD;
*/
}
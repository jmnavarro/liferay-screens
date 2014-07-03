//
//  BaseWidget.swift
//  liferay-mobile-widgets-swift
//
//  Created by jmWork on 01/07/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

import UIKit

//@objc(BaseWidget)
class BaseWidget: UIView, LRCallback {

	let widgetView: BaseWidgetView?

	init(frame: CGRect) {
		super.init(frame: frame)
		widgetView = loadWidgetView();
	}

	init(coder aDecoder: NSCoder!) {
		super.init(coder: aDecoder)
		widgetView = loadWidgetView();
	}

	override func awakeFromNib() {
		self.clipsToBounds = true;
		onCreate()
	}

	override func didMoveToWindow() {
		if (self.window) {
			self.onShow();
		}
		else {
			self.onHide();
		}
	}

	func onCreate() {
		
	}

	func onShow() {

	}

	func onHide() {

	}

	func onServerError(error: NSError) {

	}

	func onServerResult(result: AnyObject!) {
	}

	func onFailure(error: NSError!) {
		onServerError(error ? error : NSError(domain: "LiferayWidget", code: 0, userInfo: nil))
	}

	func onSuccess(result: AnyObject!) {
		onServerResult(result)
	}

	func onCustomAction(actionName:String, sender:UIControl) {

	}
	

	func loadWidgetView() -> BaseWidgetView {
		let view = self.createWidgetViewFromNib();

		view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
		view.customAction = self.onCustomAction;
		self.addSubview(view)


		return view;
	}

	func createWidgetViewFromNib() -> BaseWidgetView! {
		//		let className = NSStringFromClass(self.dynamicType)
		// Se podría usar NSStringFromClass y anotamos todas las clases *Widget con @objc(*Widget). De esa forma, controlamos el nombre de la underlaying

		let className = nameOfClass(self.dynamicType)

		println(className)
		let widgetName = className.componentsSeparatedByString("Widget")[0]
		let viewName = widgetName + "View"

		var nibName: String? = NSBundle.mainBundle().pathForResource(viewName + "-ext", ofType:"xib");
		if !nibName {
			nibName = viewName

//			assert(NSBundle.mainBundle().pathForResource(nibName, ofType:"xib"), "Fatal error: can't find view xib file for widget. Make sure all your widget have a xib file")
		}

		let views = NSBundle.mainBundle().loadNibNamed(nibName!, owner:self, options:nil)
		assert(views.count > 0, "Xib seems to be malformed. There're no views inside it");

		return views[0] as BaseWidgetView
	}


	/*
	1 Check that myDelegate is not nil.
	2 Check that myDelegate implements the method window:willUseFullScreenContentSize:.
	3 If 1 and 2 hold true, invoke the method and assign the result of the method to the value named fullScreenSize.
	4 Print the return value of the method.

if let fullScreenSize = myDelegate?.window?(myWindow, willUseFullScreenContentSize: mySize) {
println(NSStringFromSize(fullScreenSize))
}

*/


}

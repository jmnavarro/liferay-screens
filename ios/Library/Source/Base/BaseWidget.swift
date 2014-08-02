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

/*!
 * BaseWidget is the base class from which all Widget classes must inherit.
 * A widget is the container for a widget view.
 */
@IBDesignable class BaseWidget: UIView, LRCallback {

	@IBInspectable var Theme:UIImage? {
		didSet {
			setNeedsLayout()
		}
	}

	internal var widgetView: BaseWidgetView?


	//MARK: DISPLAY TEMPLATE METHODS

	/*
	 * onCreate is invoked after the widget is created. Override this method to set custom values for the widget
	 * properties.
	 */
	public func onCreate() {
	}

	/*
	 * onHide is invoked when the widget is hidden from the app window.
	 */
	public func onHide() {
	}

	/*
	 * onShow is invoked when the widget is displayed on the app window. Override this method for example to reset
	 * values when the widget is shown.
	 */
	public func onShow() {
	}

	//MARK: SERVER RESPONSE TEMPLATE METHODS

	/*
	 * onServerError is invoked when there is an error communicating with the Liferay server.
	 */
	public func onServerError(error: NSError) {
	}

	/*
	 * onServerResult is invoked when there is an result from a communication with the Liferay server. The type of the
	 * result will depend on the invocation done from specific subclasses.
	 */
	public func onServerResult(dict:[String:AnyObject]) {
	}

	//MARK: USER ACTIONS TEMPLATE METHOD

	/*
	 * onCustomAction is invoked when a TouchUpInside even is fired from the UI.
	 */
	public func onCustomAction(actionName:String?, sender:UIControl) {
	}

	//MARK: UIView METHODS

	override func awakeFromNib() {
		self.clipsToBounds = true;

		widgetView = loadWidgetView();

		onCreate()
	}

	override func becomeFirstResponder() -> Bool {
		return widgetView!.becomeFirstResponder()
	}

	override func didMoveToWindow() {
		if (self.window) {
			self.onShow();
		}
		else {
			self.onHide();
		}
	}


	//MARK: LRCallback PRIVATE METHODS


	func onFailure(error: NSError!) {
		onServerError(error ? error : NSError(domain: "LiferayWidget", code: 0, userInfo: nil))
	}

	func onSuccess(result: AnyObject!) {
		if let objcDict = result as? NSDictionary {
			onServerResult(result as [String:AnyObject])
		}
		else {
			onServerResult(["result": result])
		}
	}

	//MARK: PRIVATE METHODS

	func loadWidgetView() -> BaseWidgetView {
		let view = self.createWidgetViewFromNib();

		view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
		view.customAction = self.onCustomAction;

		self.addSubview(view)

		return view;
	}

	private func createWidgetViewFromNib() -> BaseWidgetView! {
		//		let className = NSStringFromClass(self.dynamicType)
		// You may use NSStringFromClass if you annotate all *Widget classes with @objc(*Widget). 
		// That way, we have control over underlaying ObjC autogenerated class

		let viewName = widgetName() + "View"


		var nibName = NSBundle.mainBundle().pathForResource(viewName + "-ext", ofType:"xib");

		if !nibName {
			nibName = viewName

			//TODO: this is not working!
			//assert(
			//    NSBundle.mainBundle().pathForResource(nibName, ofType:"xib"),
			//    "Fatal error: can't find view xib file for widget. Make sure all your widget have a xib file")
		}

		let views = NSBundle.mainBundle().loadNibNamed(nibName!, owner:self, options:nil)
		assert(views.count > 0, "Xib seems to be malformed. There're no views inside it");

		return views[0] as BaseWidgetView
	}

	private func currentThemeName() -> String? {
		var result: String? = nil

		if (Theme) {
			let selectedSignatureData = UIImagePNGRepresentation(Theme!)!

			if (_runningOnInterfaceBuilder) {
				ThemeManager.instance().loadThemes()
			}

			for themeName in ThemeManager.instance().installedThemes() {
				let installedSignatureImage = signatureImageForTheme(themeName)
				let installedSignatureData = UIImagePNGRepresentation(installedSignatureImage)!

				if installedSignatureData.isEqualToData(selectedSignatureData) {
					result = themeName
					break;
				}
			}
		}

		return result
	}

	private func widgetName() -> String {
		// You may use NSStringFromClass if you annotate all *Widget classes with @objc(*Widget).
		// That way, we have control over underlaying ObjC autogenerated class
		//		let className = NSStringFromClass(self.dynamicType)
		let className = nameOfClass(self.dynamicType)

		return className.componentsSeparatedByString("Widget")[0]
	}

	private func mockupImageForTheme(themeName:String) -> UIImage {
		return loadImageFromIB(mockupImageNameForTheme(themeName))
	}

	private func mockupImageNameForTheme(themeName:String) -> String {
		return "\(themeName)-mockup-\(widgetName().lowercaseString)"
	}

	private func signatureImageForTheme(themeName:String) -> UIImage {
		return loadImageFromIB(signatureImageNameForTheme(themeName))
	}

	private func signatureImageNameForTheme(themeName:String) -> String {
		return "theme-\(themeName)"
	}

	internal func loadImageFromIB(imageName:String) -> UIImage {
		let bundle = NSBundle(forClass:self.dynamicType)

		let fileName = bundle.pathForResource(imageName, ofType: "png")

		return UIImage(contentsOfFile: fileName)
	}

	private var _runningOnInterfaceBuilder:Bool {
		get {
			return widgetView == nil
		}
	}

}
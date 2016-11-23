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

public class DefaultTextField: UITextField {


	//MARK: Public variables

	public var buttonMargin: CGFloat = 10

	public var onRightButtonClick: (() -> ())?
	
	
	//MARK: IBInspectable
	
	@IBInspectable public var defaultColor: UIColor = .lightGrayColor()
	
	@IBInspectable public var highlightColor: UIColor = DefaultThemeBasicBlue

	@IBInspectable public var errorColor: UIColor = .redColor()

	@IBInspectable public var paddingLeft: CGFloat = 15

	@IBInspectable public var paddingRight: CGFloat = 15
	
	@IBInspectable public var leftImage: UIImage? {
		didSet {
			if let image = leftImage {
				
				let icon = UIImageView(image: image)

				icon.contentMode = .Center
				
				self.leftViewMode = .Always
				self.leftView = icon
			}
		}
	}

	@IBInspectable public var rightButtonImage: UIImage? {
		didSet {
			if let image = rightButtonImage {

				self.rightViewMode = .Always
				self.rightView = createButton(withImage: image)
			}
		}
	}

	@IBInspectable public var rightButtonTitle: String? {
		didSet {
			if let title = rightButtonTitle {

				self.rightViewMode = .Always
				self.rightView = createButton(withTitle: title)
			}
		}
	}

	
	//MARK: Initializers
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setup()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		setup()
	}
	
	public override func prepareForInterfaceBuilder() {
		setup()
	}


	//MARK: Public methods

	public func setDefaultState() {
		self.layer.borderColor = defaultColor.CGColor
	}

	public func setErrorState() {
		self.layer.borderColor = errorColor.CGColor
	}
	
	//MARK: Internal methods
	
	internal func setup() {
		self.layer.cornerRadius = 4.0
		self.layer.borderWidth = 1.0
		self.layer.borderColor = defaultColor.CGColor
	}

	internal func rightButtonClick() {
		onRightButtonClick?()
	}

	internal func createButton(withImage image: UIImage? = nil,
								withTitle title: String? = nil) -> UIButton {

		let button = UIButton()

		button.setImage(image, forState: .Normal)
		button.backgroundColor = highlightColor
		button.tintColor = .whiteColor()
		button.setTitle(title, forState: .Normal)
		button.adjustsImageWhenHighlighted = false
		button.addTarget(self,
		                 action: #selector(rightButtonClick),
		                 forControlEvents: .TouchUpInside)

		setButtonDefaultStyle(button)

		return button
	}
	
	//MARK: UITextField
	
	public override func resignFirstResponder() -> Bool {
		self.layer.borderColor = defaultColor.CGColor
		
		return super.resignFirstResponder()
	}
	
	public override func becomeFirstResponder() -> Bool {
		self.layer.borderColor = highlightColor.CGColor
		
		return super.becomeFirstResponder()
	}

	public override func textRectForBounds(bounds: CGRect) -> CGRect {
		if let _ = leftView {
			return super.textRectForBounds(bounds)
		}

		return CGRect(x: paddingLeft, y: 0, width: bounds.width - paddingRight, height: bounds.height)
	}

	public override func editingRectForBounds(bounds: CGRect) -> CGRect {
		if let _ = leftView {
			return super.editingRectForBounds(bounds)
		}

		return textRectForBounds(bounds)
	}

	public override func leftViewRectForBounds(bounds: CGRect) -> CGRect {
		return CGRect(origin: CGPointZero, size: CGSize(width: bounds.height, height: bounds.height))
	}

	public override func rightViewRectForBounds(bounds: CGRect) -> CGRect {
		let boundsCalculated = super.rightViewRectForBounds(bounds)

		let origin = CGPoint(x: boundsCalculated.origin.x - buttonMargin/2,
		                     y: boundsCalculated.minY)

		let size = CGSize(width: bounds.height - buttonMargin,
		                  height: bounds.height - buttonMargin)
		
		return CGRect(origin: origin, size: size)
	}
}

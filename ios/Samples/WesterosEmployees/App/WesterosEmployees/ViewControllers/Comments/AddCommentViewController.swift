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
import LiferayScreens

class AddCommentViewController: CardViewController, CommentAddScreenletDelegate {

	var onCommentAdded: (Comment -> ())?
	var onCommentUpdated: (Comment -> ())?

	
	//MARK: Outlets

	@IBOutlet weak var commentAddScreenlet: CommentAddScreenlet? {
		didSet {
			self.commentAddScreenlet?.delegate = self
		}
	}


	//MARK: Init methods

	convenience init() {
		self.init(nibName: "AddCommentViewController", bundle: nil)
	}


	//MARK: Public methods

	func editComment(comment: Comment) {
		self.commentAddScreenlet?.comment = comment
		self.cardView?.changeToState(.Normal)
		self.cardView?.changeButtonText("Edit Comment")
	}

	func load(className className: String, classPK: Int64) {
		self.commentAddScreenlet?.className = className
		self.commentAddScreenlet?.classPK = classPK

		//Change color depending on asset
		if className == AssetClasses.getClassName(AssetClassNameKey_BlogsEntry)! {
			cardView?.backgroundColor = DefaultResources.OddColorBackground
			cardView?.button.setTitleColor(DefaultResources.EvenColorBackground, forState: .Normal)
			cardView?.arrow.image = UIImage(named: "icon_DOWN_W")
			commentAddScreenlet?.themeName = "westeros-white"
		}
		else {
			cardView?.backgroundColor = DefaultResources.EvenColorBackground
			cardView?.button.setTitleColor(DefaultResources.OddColorBackground, forState: .Normal)
			cardView?.arrow.image = UIImage(named: "icon_DOWN")
			commentAddScreenlet?.themeName = "westeros"
		}
	}

	
	//MARK: CardViewController

	override func pageWillDisappear() {
		self.cardView?.changeButtonText("Add Comment")
		self.commentAddScreenlet?.comment = nil
		(self.commentAddScreenlet?.viewModel as? CommentAddView_westeros)?.body = ""
		self.view.endEditing(true)
	}


	//MARK: CommentAddScreenletDelegate

	func screenlet(screenlet: CommentAddScreenlet, onCommentAdded comment: Comment) {
		onCommentAdded?(comment)
	}

	func screenlet(screenlet: CommentAddScreenlet, onCommentUpdated comment: Comment) {
		self.commentAddScreenlet?.comment = nil
		onCommentUpdated?(comment)
	}
}

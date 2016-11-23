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

class ListViewController: UIViewController, BookmarkListScreenletDelegate {

    let listThemes = ["default", "default-custom", "default-collection"]

    
	//MARK: Outlets

    @IBOutlet weak var listBookmarkScreenlet: BookmarkListScreenlet! {
        didSet {
            listBookmarkScreenlet.delegate = self
        }
    }
    

	//MARK: UIViewController

	override func viewDidLoad() {
		super.viewDidLoad()

		let folderId = (LiferayServerContext.propertyForKey("folderId") as! NSNumber).longLongValue
		listBookmarkScreenlet.folderId = folderId
	}


	@IBAction func controlValueChanged(sender: UISegmentedControl) {
		listBookmarkScreenlet.themeName = listThemes[sender.selectedSegmentIndex]
		listBookmarkScreenlet.loadList()
        self.view.setNeedsDisplay()
	}
    
    
    //MARK: BookmarkListScreenletDelegate
    
    func screenlet(screenlet: BookmarkListScreenlet, onBookmarkSelected bookmark: Bookmark) {
        UIApplication.sharedApplication().openURL(NSURL(string: bookmark.url)!)
    }

}


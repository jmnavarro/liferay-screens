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


public class BookmarkListPageLoadInteractor : BaseListPageLoadInteractor {

	public let groupId: Int64
	public let folderId: Int64
    
    
    //MARK: Initializer

	init(screenlet: BaseListScreenlet,
			page: Int,
			computeRowCount: Bool,
			groupId: Int64,
			folderId: Int64) {

		self.groupId = (groupId != 0) ? groupId : LiferayServerContext.groupId
		self.folderId = folderId

		super.init(screenlet: screenlet, page: page, computeRowCount: computeRowCount)
	}
    
    
    //MARK: BaseListPageLoadInteractor
    
    public override func createListPageConnector() -> PaginationLiferayConnector {
        let screenlet = self.screenlet as! BaseListScreenlet
        
        return BookmarkListPageLiferayConnector(
            startRow: screenlet.firstRowForPage(self.page),
            endRow: screenlet.firstRowForPage(self.page + 1),
            computeRowCount: self.computeRowCount,
            groupId: groupId,
            folderId: folderId)
    }

	override public func convertResult(serverResult: [String:AnyObject]) -> AnyObject {
		return Bookmark(attributes: serverResult)
	}

	override public func cacheKey(op: PaginationLiferayConnector) -> String {
		return "\(groupId)-\(folderId)"
	}
    
    public override func sectionForRowObject(object: AnyObject) -> String? {
        guard let bookmark = object as? Bookmark else {
            return nil
        }
        
        let host = NSURL(string: bookmark.url)?.host?.lowercaseString
        
        return host?.stringByReplacingOccurrencesOfString("www.", withString: "")
    }
	
}

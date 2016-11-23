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


public class CommentListView_default: BaseListTableView, CommentListViewModel {

	let CommentCellId = "commentCell"

	var commentListScreenlet: CommentListScreenlet {
		return screenlet as! CommentListScreenlet
	}


	//MARK: BaseScreenletView

	override public func onShow() {
		super.onShow()
		self.tableView?.tableFooterView = UIView()
	}

	override public func createProgressPresenter() -> ProgressPresenter {
		return DefaultProgressPresenter()
	}


	//MARK: CommentListViewModel

	public func addComment(comment: Comment) {
		addRow(BaseListView.DefaultSection, element: comment)
		let indexPath = NSIndexPath(forRow: (rows[BaseListView.DefaultSection]?.count)! - 1,
			inSection: 0)
		tableView?.beginUpdates()
		tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
		tableView?.endUpdates()
		tableView?.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
	}

	public func deleteComment(comment: Comment) {
		let row = rows[BaseListView.DefaultSection]?.indexOf({
			(($0 as? Comment)?.commentId ?? 0) == comment.commentId})
		if let row = row {
			deleteRow(BaseListView.DefaultSection, row: row)
			let indexPath = NSIndexPath(forRow: row, inSection: 0)
			tableView?.beginUpdates()
			tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
			tableView?.endUpdates()
		}
	}

	public func updateComment(comment: Comment) {
		let row = rows[BaseListView.DefaultSection]?.indexOf({
			(($0 as? Comment)?.commentId ?? 0) == comment.commentId})
		if let row = row {
			updateRow(BaseListView.DefaultSection, row: row, element: comment)
			let indexPath = NSIndexPath(forRow: row, inSection: 0)
			tableView?.scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
			tableView?.beginUpdates()
			tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
			tableView?.endUpdates()
		}
	}


	//MARK: BaseListTableView

	override public func doRegisterCellNibs() {
		let nib = NSBundle.nibInBundles(
			name: "CommentTableViewCell_default", currentClass: self.dynamicType)

		if let commentNib = nib {
			tableView?.registerNib(commentNib, forCellReuseIdentifier: CommentCellId)
		}
	}

	override public func doDequeueReusableCell(row row: Int, object: AnyObject?)
			-> UITableViewCell {
		let cell = super.doDequeueReusableCell(row: row, object: object)
		if let commentCell = cell as? CommentTableViewCell_default {
			commentCell.commentDisplayScreenlet?.presentingViewController =
				self.presentingViewController
			commentCell.commentDisplayScreenlet?.delegate = screenlet
				as? CommentDisplayScreenletDelegate
		}
		return cell
	}

	override public func doGetCellId(row row: Int, object: AnyObject?) -> String {
		return CommentCellId
	}

	override public func doFillLoadedCell(row row: Int, cell: UITableViewCell, object:AnyObject) {
		if let comment = object as? Comment, commentCell = cell as? CommentTableViewCell_default {
			commentCell.commentDisplayScreenlet?.comment = comment
			cell.accessoryType = .None
			cell.accessoryView = nil
		}
	}

	override public func doFillInProgressCell(row row: Int, cell: UITableViewCell) {
		cell.textLabel?.text = "..."
		cell.accessoryType = .None

		if let image = NSBundle.imageInBundles(
				name: "default-hourglass",
				currentClass: self.dynamicType) {
			cell.accessoryView = UIImageView(image: image)
			cell.accessoryView!.frame = CGRectMake(0, 0, image.size.width, image.size.height)
		}
	}


	//MARK: BaseListView

	public override func onClearRows(oldRows: [String : [AnyObject?]]) {
		super.onClearRows(oldRows)
		self.tableView?.tableFooterView = UIView()
	}


	//UITableViewDelegate

	public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath)
			-> CGFloat {
		let comment = rows[BaseListView.DefaultSection]?[indexPath.row] as? Comment
		return CommentDisplayView_default.heightForText(comment?.htmlBody,
			width: tableView.frame.width)
	}

	public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath)
			-> Bool {
		if let comment = rows[BaseListView.DefaultSection]?[indexPath.row] as? Comment {
			return comment.canEdit || comment.canDelete
		}

		return false
	}

	public func tableView(tableView: UITableView,
			editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
		let editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default,
				title: "Edit", handler:{action, indexPath in
			let cell = tableView.cellForRowAtIndexPath(indexPath) as? CommentTableViewCell_default
			cell?.commentDisplayScreenlet?.editComment()
			tableView.setEditing(false, animated: true)
		})
		editRowAction.backgroundColor = UIColor(red: 0, green: 0.7216, blue: 0.8784, alpha: 1.0)

		let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default,
				title: "Delete", handler:{action, indexPath in
			let cell = tableView.cellForRowAtIndexPath(indexPath) as? CommentTableViewCell_default
			cell?.commentDisplayScreenlet?.deleteComment()
			tableView.setEditing(false, animated: true)
		})
		deleteRowAction.backgroundColor = UIColor(red: 0.7686, green: 0.2431, blue: 0, alpha: 1.0)

		return [deleteRowAction, editRowAction];
	}
}

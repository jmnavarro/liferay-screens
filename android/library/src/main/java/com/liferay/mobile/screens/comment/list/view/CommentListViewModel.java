package com.liferay.mobile.screens.comment.list.view;

import com.liferay.mobile.screens.base.list.view.BaseListViewModel;
import com.liferay.mobile.screens.models.CommentEntry;

/**
 * @author Alejandro Hernández
 */
public interface CommentListViewModel extends BaseListViewModel<CommentEntry> {
	void refreshView();
	void setEditable(boolean editable);
	void addNewCommentEntry(CommentEntry commentEntry);
	void removeCommentEntry(CommentEntry commentEntry);
}

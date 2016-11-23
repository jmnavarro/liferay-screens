package com.liferay.mobile.screens.listbookmark;

import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.view.View;
import com.liferay.mobile.screens.base.list.BaseListScreenlet;
import com.liferay.mobile.screens.context.LiferayServerContext;

/**
 * @author Javier Gamarra
 */
public class BookmarkListScreenlet extends BaseListScreenlet<Bookmark, BookmarkListInteractor> {

	private long folderId;
	private String comparator;

	public BookmarkListScreenlet(Context context) {
		super(context);
	}

	public BookmarkListScreenlet(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	public BookmarkListScreenlet(Context context, AttributeSet attrs, int defStyleAttr) {
		super(context, attrs, defStyleAttr);
	}

	public BookmarkListScreenlet(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
		super(context, attrs, defStyleAttr, defStyleRes);
	}

	@Override
	public void error(Exception e, String userAction) {
		if (getListener() != null) {
			getListener().error(e, userAction);
		}
	}

	@Override
	protected View createScreenletView(Context context, AttributeSet attributes) {
		TypedArray typedArray =
			context.getTheme().obtainStyledAttributes(attributes, R.styleable.BookmarkListScreenlet, 0, 0);
		groupId = typedArray.getInt(R.styleable.BookmarkListScreenlet_groupId, (int) LiferayServerContext.getGroupId());
		folderId = typedArray.getInt(R.styleable.BookmarkListScreenlet_folderId, 0);
		comparator = typedArray.getString(R.styleable.BookmarkListScreenlet_comparator);
		typedArray.recycle();

		return super.createScreenletView(context, attributes);
	}

	@Override
	protected void loadRows(BookmarkListInteractor interactor) {

		((BookmarkListListener) getListener()).interactorCalled();

		interactor.start(folderId, comparator);
	}

	@Override
	protected BookmarkListInteractor createInteractor(String actionName) {
		return new BookmarkListInteractor();
	}
}

package com.liferay.mobile.screens.asset.display;

import android.view.View;
import com.liferay.mobile.screens.base.view.BaseViewModel;

/**
 * @author Sarai Díaz García
 */
public interface AssetDisplayViewModel extends BaseViewModel {
	void showFinishOperation(View view);

	void removeInnerScreenlet();
}

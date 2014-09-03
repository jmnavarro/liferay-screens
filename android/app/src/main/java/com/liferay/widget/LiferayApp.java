package com.liferay.widget;

import android.app.Application;
import android.content.Context;

public class LiferayApp extends Application {

	private static LiferayApp instance;

	public LiferayApp() {
		instance = this;
	}

	public static Context getContext() {
		return instance;
	}

}
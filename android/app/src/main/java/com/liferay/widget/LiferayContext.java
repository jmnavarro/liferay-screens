package com.liferay.widget;

import android.content.SharedPreferences;
import android.preference.PreferenceManager;

public class LiferayContext {

	public static int getCompanyId() {
		return getPreferences().getInt("companyId", 10154);
	}

	public static int getGroupId() {
		return getPreferences().getInt("groupId", 10181);
	}

	public static String getServer() {
		return getPreferences().getString("server", "http://10.0.2.2:8080");
	}

	private static SharedPreferences getPreferences() {
		if (_preferences == null) {
			_preferences = PreferenceManager.getDefaultSharedPreferences(LiferayApp.getContext());
		}
		return _preferences;
	}

	private static SharedPreferences _preferences;

}
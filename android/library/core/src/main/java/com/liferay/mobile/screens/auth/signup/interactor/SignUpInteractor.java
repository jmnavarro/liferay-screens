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

package com.liferay.mobile.screens.auth.signup.interactor;

import com.liferay.mobile.screens.auth.signup.SignUpListener;
import com.liferay.mobile.screens.base.interactor.Interactor;

import java.util.Locale;

/**
 * @author Silvio Santos
 */
public interface SignUpInteractor extends Interactor<SignUpListener> {

	void signUp(
		long companyId, String firstName, String middleName,
		String lastName, String emailAddress, String screenName,
		String password, String jobTitle, Locale locale,
		String anonymousApiUserName, String anonymousApiPassword)
		throws Exception;

}
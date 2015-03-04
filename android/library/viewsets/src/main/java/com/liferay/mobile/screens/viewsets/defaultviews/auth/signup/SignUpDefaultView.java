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

package com.liferay.mobile.screens.viewsets.defaultviews.auth.signup;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ProgressBar;

import com.liferay.mobile.screens.auth.signup.SignUpScreenlet;
import com.liferay.mobile.screens.auth.signup.view.SignUpViewModel;
import com.liferay.mobile.screens.base.ModalProgressBar;
import com.liferay.mobile.screens.context.User;
import com.liferay.mobile.screens.util.LiferayLogger;
import com.liferay.mobile.screens.viewsets.R;
import com.liferay.mobile.screens.viewsets.defaultviews.DefaultCrouton;

/**
 * @author Silvio Santos
 */
public class SignUpDefaultView extends LinearLayout
		implements SignUpViewModel, View.OnClickListener {

	public SignUpDefaultView(Context context) {
		super(context);
	}

	public SignUpDefaultView(Context context, AttributeSet attributes) {
		super(context, attributes);
	}

	public SignUpDefaultView(Context context, AttributeSet attributes, int defaultStyle) {
		super(context, attributes, defaultStyle);
	}

	@Override
	public String getEmailAddress() {
		return _emailAddress.getText().toString();
	}

	@Override
	public String getFirstName() {
		return _firstName.getText().toString();
	}

	@Override
	public String getJobTitle() {
		return null;
	}

	@Override
	public String getLastName() {
		return _lastName.getText().toString();
	}

	@Override
	public String getMiddleName() {
		return null;
	}

	@Override
	public String getPassword() {
		return _password.getText().toString();
	}

	@Override
	public String getScreenName() {
		return null;
	}

	@Override
	public void showStartOperation(String actionName) {
		_progressBar.startProgress();
	}

	@Override
	public void showFinishOperation(String actionName) {
		throw new AssertionError("Use showFinishOperation(user) instead");
	}

	@Override
	public void showFinishOperation(User user) {
		_progressBar.finishProgress();

		LiferayLogger.i("Sign-up successful: " + user.getId());
	}

	@Override
	public void showFailedOperation(String actionName, Exception e) {
		_progressBar.finishProgress();

		LiferayLogger.e("Could not sign up", e);
		DefaultCrouton.error(getContext(), getContext().getString(R.string.sign_up_error), e);
	}

	@Override
	public void onClick(View view) {
		SignUpScreenlet signUpScreenlet = (SignUpScreenlet) getParent();

		signUpScreenlet.performUserAction();
	}

	@Override
	protected void onFinishInflate() {
		super.onFinishInflate();

		_firstName = (EditText) findViewById(R.id.first_name);
		_lastName = (EditText) findViewById(R.id.last_name);
		_emailAddress = (EditText) findViewById(R.id.email_address);
		_password = (EditText) findViewById(R.id.password);
		_progressBar = (ModalProgressBar) findViewById(R.id.progress_bar);

		Button signUpButton = (Button) findViewById(R.id.sign_up);
		signUpButton.setOnClickListener(this);
	}

	private EditText _emailAddress;
	private EditText _firstName;
	private EditText _lastName;
	private EditText _password;
	private ModalProgressBar _progressBar;

}
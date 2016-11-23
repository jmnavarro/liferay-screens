package com.liferay.mobile.screens.base;

import android.app.AlertDialog;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import com.jakewharton.rxbinding.view.RxView;
import com.liferay.mobile.screens.R;
import com.tbruyelle.rxpermissions.RxPermissions;
import rx.functions.Action1;

import static android.Manifest.permission.CAMERA;
import static android.Manifest.permission.WRITE_EXTERNAL_STORAGE;

/**
 * @author Víctor Galán Grande
 */
public class MediaStoreSelectorDialog {

	public AlertDialog createOriginDialog(Context context, Action1<Boolean> openCamera, Action1<Boolean> openGallery,
		Action1<Boolean> openVideoCamera) {
		AlertDialog.Builder builder = new AlertDialog.Builder(context);

		LayoutInflater factory = LayoutInflater.from(context);
		final View customDialogView = factory.inflate(R.layout.chose_origin_dialog_default, null);
		builder.setView(customDialogView);

		RxPermissions rxPermissions = RxPermissions.getInstance(context);

		if (openCamera != null) {
			View takePhoto = customDialogView.findViewById(R.id.liferay_dialog_take_photo);
			takePhoto.setVisibility(View.VISIBLE);
			RxView.clicks(takePhoto)
				.compose(rxPermissions.ensure(CAMERA, WRITE_EXTERNAL_STORAGE))
				.subscribe(openCamera);
		}

		if (openGallery != null) {
			View selectFile = customDialogView.findViewById(R.id.liferay_dialog_select_file);
			selectFile.setVisibility(View.VISIBLE);
			RxView.clicks(selectFile).compose(rxPermissions.ensure(WRITE_EXTERNAL_STORAGE)).subscribe(openGallery);
		}

		if (openVideoCamera != null) {
			View recordVideo = customDialogView.findViewById(R.id.liferay_dialog_take_video);
			recordVideo.setVisibility(View.VISIBLE);
			RxView.clicks(recordVideo)
				.compose(rxPermissions.ensure(CAMERA, WRITE_EXTERNAL_STORAGE))
				.subscribe(openVideoCamera);
		}

		return builder.create();
	}
}

package com.liferay.mobile.screens.viewsets.defaultviews.imagegallery;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ImageView;
import android.widget.TextView;
import com.liferay.mobile.screens.R;
import com.liferay.mobile.screens.imagegallery.BaseDetailUploadView;
import com.squareup.picasso.Picasso;
import java.io.File;

/**
 * @author Víctor Galán Grande
 */
public class DefaultUploadDetailView extends BaseDetailUploadView {

	private TextView titleText;
	private TextView descriptionText;


	public DefaultUploadDetailView(Context context) {
		super(context);
	}

	public DefaultUploadDetailView(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	public DefaultUploadDetailView(Context context, AttributeSet attrs, int defStyleAttr) {
		super(context, attrs, defStyleAttr);
	}

	public DefaultUploadDetailView(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
		super(context, attrs, defStyleAttr, defStyleRes);
	}

	@Override
	protected void onFinishInflate() {
		super.onFinishInflate();

		titleText = (TextView) findViewById(R.id.liferay_gallery_upload_title);
		descriptionText = (TextView) findViewById(R.id.liferay_gallery_upload_description);
	}

	@Override
	public void initializeUploadView(String actionName, String picturePath, int screenletId) {
		super.initializeUploadView(actionName, picturePath, screenletId);

		ImageView imageView = (ImageView) findViewById(R.id.liferay_gallery_upload_image);
		Picasso.with(getContext().getApplicationContext()).load(new File(picturePath)).fit().into(imageView);
	}

	public String getTitle() {
		return titleText.getText().toString();
	}

	public String getDescription() {
		return descriptionText.getText().toString();
	}
}

package com.liferay.mobile.screens.ddl.form.interactor.upload;

import android.content.Context;
import android.content.Intent;
import com.liferay.mobile.screens.base.interactor.BaseCacheWriteInteractor;
import com.liferay.mobile.screens.context.LiferayScreensContext;
import com.liferay.mobile.screens.ddl.form.DDLFormListener;
import com.liferay.mobile.screens.ddl.form.service.UploadService;

/**
 * @author Javier Gamarra
 */
public class DDLFormDocumentUploadInteractor
	extends BaseCacheWriteInteractor<DDLFormListener, DDLFormDocumentUploadEvent> {

	@Override
	protected void online(DDLFormDocumentUploadEvent event) throws Exception {
		decorateEvent(event, false);
		execute(event);
	}

	@Override
	public DDLFormDocumentUploadEvent execute(DDLFormDocumentUploadEvent event) {

		Context context = LiferayScreensContext.getContext();
		Intent service = new Intent(context, UploadService.class);
		service.putExtra("file", event.getDocumentField());
		service.putExtra("userId", event.getUserId());
		service.putExtra("folderId", event.getFolderId());
		service.putExtra("repositoryId", event.getRepositoryId());
		service.putExtra("filePrefix", event.getFilePrefix());
		service.putExtra("targetScreenletId", getTargetScreenletId());
		service.putExtra("actionName", getActionName());

		context.startService(service);
		return null;
	}

	@Override
	public void onSuccess(DDLFormDocumentUploadEvent event) throws Exception {
		getListener().onDDLFormDocumentUploaded(event.getDocumentField(), event.getJSONObject());
	}

	@Override
	public void onFailure(DDLFormDocumentUploadEvent event) {
		getListener().onDDLFormDocumentUploadFailed(event.getDocumentField(), event.getException());
	}
}

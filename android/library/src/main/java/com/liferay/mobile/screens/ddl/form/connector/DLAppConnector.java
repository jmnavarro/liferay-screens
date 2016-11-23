package com.liferay.mobile.screens.ddl.form.connector;

import com.liferay.mobile.android.service.JSONObjectWrapper;
import org.json.JSONObject;

/**
 * @author Javier Gamarra
 */
public interface DLAppConnector {
	JSONObject addFileEntry(Long repositoryId, Long folderId, String name, String mimeType, String fileName, String s,
		String s1, byte[] bytes, JSONObjectWrapper serviceContextWrapper) throws Exception;
}

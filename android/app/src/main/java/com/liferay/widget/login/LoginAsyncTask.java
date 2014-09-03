package com.liferay.widget.login;

import org.json.JSONObject;

import com.liferay.mobile.android.service.Session;
import com.liferay.mobile.android.service.SessionImpl;
import com.liferay.mobile.android.v62.user.UserService;
import com.liferay.widget.LiferayContext;

import android.os.AsyncTask;

public class LoginAsyncTask extends AsyncTask<String, Void, JSONObject> {
	
	private LoginWidget.ListenerAdapter listener;
	
	public LoginAsyncTask(LoginWidget.ListenerAdapter listener) {
		super();
		
		this.listener = listener;
	}

	@Override
	protected JSONObject doInBackground(String... params) {
		String user = params[0];
		String pwd = params[1];
		
		Session session = new SessionImpl(LiferayContext.getServer(), user, pwd);
		
		UserService service = new UserService(session);
		JSONObject result = null;
		
		try {
			result = service.getUserByEmailAddress(LiferayContext.getCompanyId(), user);

			if (result != null && !result.getString("emailAddress").equals(user)) {
				result = null;
			}

		} catch (Exception e) {
			result = null;
		}
		
		return result;
	}
	
	@Override
    protected void onPostExecute(JSONObject result) {
        super.onPostExecute(result);
        
        // On UI thread!
        
		if (result != null) {
			listener.doLoginFinished(result);
		}
		else {
			listener.doLoginFailed(new Exception("Wrong result received"));
		}
        
    }

}

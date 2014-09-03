package com.liferay.widget.login;

import org.json.JSONObject;

import com.liferay.widget.R;

import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;

public class LoginWidget extends LinearLayout {
	
	public static interface Listener {	
		public void onLoginFinished(Context ctx, JSONObject attrs);
		public void onLoginFailed(Context ctx, Exception exception);
	}
	
	public abstract static class ListenerAdapter implements Listener {
		private Context context;
		
		public ListenerAdapter(Context context) {
			super();
			
			this.context = context;
		}
		
		protected void doLoginFinished(JSONObject attrs) {
			this.onLoginFinished(context, attrs);
		}
		
		protected void doLoginFailed(Exception exception) {
			this.onLoginFailed(context, exception);
		}

	}
	
	private EditText email;
	private EditText password;
	
	private ListenerAdapter finishListener;

    public LoginWidget(Context context, AttributeSet attrs) {
        super(context, attrs);
        
        TypedArray a = context.obtainStyledAttributes(attrs, R.styleable.LoginWidget, 0, 0);
        String layoutFullName = a.getString(R.styleable.LoginWidget_custom_layout);
        a.recycle();
        
        this.setCustomLayout(layoutFullName);
        
        if (!this.isInEditMode()) {
            Button btn = (Button)findViewById(R.id.loginButton);
            btn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    loginClick();
                }
            });
        }
        
        this.email = (EditText)findViewById(R.id.emailEditText); 
        this.password = (EditText)findViewById(R.id.passwordEditText); 
    }
    
    public void setCustomLayout(String layoutFullName) {
        int layoutId;
        
        if (layoutFullName == null || this.isInEditMode()) {
        	layoutId = R.layout.login_widget; 
        }
        else {
        	String layoutName = splitLayoutName(layoutFullName);
        	layoutId = getResources().getIdentifier(layoutName, "layout", getContext().getPackageName());
        }
        
        LayoutInflater inflater = (LayoutInflater) getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        inflater.inflate(layoutId, this);
    }
    
    public void setListener(ListenerAdapter listener) {
    	finishListener = listener;
    }
    
    private String splitLayoutName(String fullName) {
    	String[] parts = fullName.split("/");
    	parts = parts[2].split("\\.");
    	return parts[0];
    }
    
    private void loginClick() {
    	LoginAsyncTask task = new LoginAsyncTask(finishListener);
    	
    	task.execute(
    			email.getText().toString(), 
    			password.getText().toString());
    	
    }

}

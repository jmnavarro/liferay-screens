package com.liferay.widget.journal;

import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.webkit.WebView;
import android.widget.FrameLayout;

import com.liferay.widget.LiferayContext;
import com.liferay.widget.R;

public class JournalArticleWidget extends FrameLayout {
	
	public static interface Listener {	
		public void onJournalArticleReceived(Context ctx, String html);
		public void onJournalArticleFailed(Context ctx, Exception exception);
	}
	
	public abstract static class ListenerAdapter implements Listener {
		private Context context;
		
		public ListenerAdapter(Context context) {
			super();
			
			this.context = context;
		}
		
		protected void doJournalArticleReceived(String html) {
			this.onJournalArticleReceived(context, html);
		}
		
		protected void doJournalArticleFailed(Exception exception) {
			this.onJournalArticleFailed(context, exception);
		}

	}
	
	private WebView webView;
	private int groupId;
	private int articleId;
	
	private ListenerAdapter listener;

    public JournalArticleWidget(Context context, AttributeSet attrs) {
        super(context, attrs);
        
        TypedArray a = context.obtainStyledAttributes(attrs, R.styleable.JournalArticleWidget, 0, 0);
        String layoutFullName = a.getString(R.styleable.LoginWidget_custom_layout);
        if (!this.isInEditMode()) {
        	groupId = a.getInt(R.styleable.JournalArticleWidget_groupId, LiferayContext.getGroupId());
        	articleId = a.getInt(R.styleable.JournalArticleWidget_articleId, 0);
        }
        a.recycle();

        if (layoutFullName != null && !this.isInEditMode()) {
            this.setCustomLayout(layoutFullName);
        }
        else {

        }

        //this.webView = (WebView)findViewById(R.id.webView1);
    }
    
    @Override
	protected void onAttachedToWindow() {
    	
    	System.out.println("!!!!!!!!!!");
    }



	public void setListener(ListenerAdapter listener) {
    	this.listener = listener;
    }
    
    public void setGroupId(int groupId) {
    	this.groupId = groupId;
    }
    
    public void setArticleId(int articleId) {
    	this.articleId = articleId;
    }
    
    public void setCustomLayout(String layoutFullName) {
        int layoutId;
        
        if (layoutFullName == null || this.isInEditMode()) {
        	layoutId = R.layout.journal_article_widget; 
        }
        else {
        	String layoutName = splitLayoutName(layoutFullName);
        	layoutId = getResources().getIdentifier(layoutName, "layout", getContext().getPackageName());
        }
        
        LayoutInflater inflater = (LayoutInflater) getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        inflater.inflate(layoutId, this);
    }

    private String splitLayoutName(String fullName) {
    	String[] parts = fullName.split("/");
    	parts = parts[2].split("\\.");
    	return parts[0];
    }
    
}

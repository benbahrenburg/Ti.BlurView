package bencoding.blur;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.kroll.common.AsyncResult;
import org.appcelerator.kroll.common.TiMessenger;
import org.appcelerator.titanium.TiApplication;
import org.appcelerator.titanium.proxy.TiViewProxy;
import org.appcelerator.titanium.view.TiUIView;

import android.app.Activity;
import android.os.Handler;
import android.os.Message;

@Kroll.proxy(creatableInModule = BlurviewModule.class)
public class BasicBlurViewProxy extends TiViewProxy {

	public BasicBlurViewProxy() {
		super();
	}

	@Override
	public TiUIView createView(Activity activity) 
	{
		BasicBlurView view = new BasicBlurView(this);
		view.getLayoutParams().autoFillsHeight = true;
		view.getLayoutParams().autoFillsWidth = true;
		return view;
	}

	// Handle creation options
	@Override
	public void handleCreationDict(KrollDict options) 
	{
		super.handleCreationDict(options);
	}

	public void handleCreationArgs(KrollModule createdInModule, Object[] args) 
	{
		super.handleCreationArgs(createdInModule, args);
	}

	private static final int MSG_SET_IMAGE = 70000;
	private static final int MSG_SET_BLUR_RADIUS = 70001;
	
	@Kroll.setProperty(retain=false)
	public void setBlurRadius(final float input) 
	{
		if (view != null) {
			if (!TiApplication.isUIThread()) {
				TiMessenger.sendBlockingMainMessage(new Handler(TiMessenger.getMainMessenger().getLooper(), new Handler.Callback() {
					public boolean handleMessage(Message msg) {
						switch (msg.what) {
							case MSG_SET_BLUR_RADIUS: {
								AsyncResult result = (AsyncResult) msg.obj;
								BasicBlurView sendView = (BasicBlurView)view;
								sendView.setBlurRadius(input);
								result.setResult(null);
								return true;
							}
						}
						return false;
					}
				}).obtainMessage(MSG_SET_BLUR_RADIUS), input);
			} else {
				BasicBlurView sendView = (BasicBlurView)view;
				sendView.setBlurRadius(input);
			}
		}

		setPropertyAndFire("blurRadius", input);		
	}
	
	@Kroll.setProperty(retain=false)
	public void setImage(final Object input) 
	{
		if (view != null) {
			if (!TiApplication.isUIThread()) {
				TiMessenger.sendBlockingMainMessage(new Handler(TiMessenger.getMainMessenger().getLooper(), new Handler.Callback() {
					public boolean handleMessage(Message msg) {
						switch (msg.what) {
							case MSG_SET_IMAGE: {
								AsyncResult result = (AsyncResult) msg.obj;
								BasicBlurView sendView = (BasicBlurView)view;
								sendView.setImage(input);
								result.setResult(null);
								return true;
							}
						}
						return false;
					}
				}).obtainMessage(MSG_SET_IMAGE), input);
			} else {
				BasicBlurView sendView = (BasicBlurView)view;
				sendView.setImage(input);
			}
		}

		setPropertyAndFire("image", input);
	}

}

package bencoding.blur;

import java.io.IOException;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.common.Log;
import org.appcelerator.titanium.TiBlob;
import org.appcelerator.titanium.io.TiBaseFile;
import org.appcelerator.titanium.io.TiFile;
import org.appcelerator.titanium.proxy.TiViewProxy;
import org.appcelerator.titanium.view.TiCompositeLayout;
import org.appcelerator.titanium.view.TiDrawableReference;
import org.appcelerator.titanium.view.TiUIView;

import ti.modules.titanium.filesystem.FileProxy;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.view.View;

public class BasicBlurView extends TiUIView{
	// Standard Debugging variables
	private static final String LCAT = BlurviewModule.MODULE_FULL_NAME;
	private static final String PROPERTY_IMAGE = "image";
	private static final String PROPERTY_BLUR_RADIUS = "blurRadius";
	private float _blurRadius = 8f;
	
	public BasicBlurView(TiViewProxy proxy) 
	{
		super(proxy);
		TiCompositeLayout view = new TiCompositeLayout(proxy.getActivity());
		setNativeView(view);
	}

	@Override
	public void processProperties(KrollDict props) 
	{
		super.processProperties(props);
				
		if (props.containsKey(PROPERTY_BLUR_RADIUS)) {
			Log.d(LCAT,"Applying Blur Radius");
			_blurRadius = props.getInt(PROPERTY_BLUR_RADIUS);
		}
		
		if (props.containsKey(PROPERTY_IMAGE)) {
			View view = (View)getNativeView();	
			setImage(props.get(PROPERTY_IMAGE));
			view.forceLayout();
		}
	}

	@Override
	public void propertyChanged(String key, Object oldValue, Object newValue, KrollProxy proxy)
	{
		super.propertyChanged(key, oldValue, newValue, proxy);
	}

	private void applyImage(Bitmap image){
		View view = (View)getNativeView();		
		image = BoxBlur.blur((int) _blurRadius, image);
		Drawable drawable = new BitmapDrawable(proxy.getActivity().getResources(),image);
		view.setBackground(drawable);
		view.forceLayout();
	}

	public void setBlurRadius(float radius) 
	{
		_blurRadius = radius;
	}
	
	private Bitmap loadImage(Object inputImage){

		try{
			if(inputImage instanceof TiBlob){
				TiDrawableReference ref = TiDrawableReference.fromBlob(this.proxy.getActivity(), (TiBlob) inputImage);
				return ref.getBitmap();
			}
	    	if(inputImage instanceof TiFile){	
				TiDrawableReference ref = TiDrawableReference.fromBlob(this.proxy.getActivity(), ((TiFile) inputImage).read());
				return ref.getBitmap();
	    	}
		    	
    		if(inputImage instanceof FileProxy){
				TiDrawableReference ref = TiDrawableReference.fromBlob(this.proxy.getActivity(), ((FileProxy) inputImage).read());
				return ref.getBitmap();
    		}
		    		
    		if(inputImage instanceof TiBaseFile){
				TiDrawableReference ref = TiDrawableReference.fromBlob(this.proxy.getActivity(), ((TiBaseFile) inputImage).read());
				return ref.getBitmap();
    		}
    		
			TiDrawableReference ref = TiDrawableReference.fromUrl(proxy, (String) inputImage);
			return ref.getBitmap();

		} catch (IOException e) {
			Log.e(LCAT, e.getMessage());
			e.printStackTrace();
			return null;
		}
	}
	public void setImage(Object inputImage) 
	{

		Bitmap image = loadImage(inputImage);
			
		if(image == null){
			return;
		}			
		
		applyImage(image);
	}
}

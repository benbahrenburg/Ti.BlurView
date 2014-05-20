/**
 * Bencoding Blur View project
 * Copyright (c) 2010-2014 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */
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

public class BlurImageView extends TiUIView{
	// Standard Debugging variables
	private static final String LCAT = BlurviewModule.MODULE_FULL_NAME;
	private static final String PROPERTY_IMAGE = "image";
	private static final String PROPERTY_BLUR_RADIUS = "blurRadius";
	private float _blurRadius = 8f;
	
	public BlurImageView(TiViewProxy proxy) 
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
	
	public void setImage(Object inputImage) 
	{
		Bitmap image = null;
		try{
			if(inputImage instanceof TiBlob){
				TiDrawableReference ref = TiDrawableReference.fromBlob(this.proxy.getActivity(), (TiBlob) inputImage);
				image = ref.getBitmap();
			}else{
		    	if(inputImage instanceof TiFile){	
					TiDrawableReference ref = TiDrawableReference.fromBlob(this.proxy.getActivity(), ((TiFile) inputImage).read());
					image = ref.getBitmap();
		    	}else{
		    		if(inputImage instanceof FileProxy){
						TiDrawableReference ref = TiDrawableReference.fromBlob(this.proxy.getActivity(), ((FileProxy) inputImage).read());
						image = ref.getBitmap();
		    		}else{
			    		if(inputImage instanceof TiBaseFile){
							TiDrawableReference ref = TiDrawableReference.fromBlob(this.proxy.getActivity(), ((TiBaseFile) inputImage).read());
							image = ref.getBitmap();
			    		}else{
							TiDrawableReference ref = TiDrawableReference.fromUrl(proxy, (String) inputImage);
							image = ref.getBitmap();
			    		}	    			
		    		}
		    	}			
			}	
			
			if(image != null){
				applyImage(image);
			}
			
		} catch (IOException e) {
			Log.e(LCAT, e.getMessage());
			e.printStackTrace();
		}
	}
}

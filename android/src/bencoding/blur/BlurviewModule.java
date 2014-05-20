/**
 * Bencoding Blur View project
 * Copyright (c) 2010-2014 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */
package bencoding.blur;

import java.io.IOException;
import java.util.HashMap;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.kroll.common.Log;
import org.appcelerator.titanium.TiApplication;
import org.appcelerator.titanium.TiBlob;
import org.appcelerator.titanium.io.TiBaseFile;
import org.appcelerator.titanium.io.TiFile;
import org.appcelerator.titanium.view.TiDrawableReference;

import ti.modules.titanium.filesystem.FileProxy;
import android.graphics.Bitmap;

@Kroll.module(name="Blurview", id="bencoding.blur")
public class BlurviewModule extends KrollModule
{

	// Standard Debugging variables
	public static final String MODULE_FULL_NAME = "bencoding.blur";
	private static final String PROPERTY_IMAGE = "image";
	private static final String PROPERTY_BLUR_RADIUS = "blurRadius";
	
	// You can define constants with @Kroll.constant, for example:
	// @Kroll.constant public static final String EXTERNAL_NAME = value;
	
	public BlurviewModule()
	{
		super();
	}

	@Kroll.onAppCreate
	public static void onAppCreate(TiApplication app)
	{
		//Log.d(MODULE_FULL_NAME, "inside onAppCreate");
		// put module init code that needs to run when the application is created
	}
	
	private Bitmap loadImage(Object inputImage){
		Bitmap image = null;
		try{
			
			if(inputImage instanceof TiBlob){
				TiDrawableReference ref = TiDrawableReference.fromBlob(getActivity(), (TiBlob) inputImage);
				image = ref.getBitmap();
			}else{
		    	if(inputImage instanceof TiFile){	
					TiDrawableReference ref = TiDrawableReference.fromBlob(getActivity(), ((TiFile) inputImage).read());
					image = ref.getBitmap();
		    	}else{
		    		if(inputImage instanceof FileProxy){
						TiDrawableReference ref = TiDrawableReference.fromBlob(getActivity(), ((FileProxy) inputImage).read());
						image = ref.getBitmap();
		    		}else{
			    		if(inputImage instanceof TiBaseFile){
							TiDrawableReference ref = TiDrawableReference.fromBlob(getActivity(), ((TiBaseFile) inputImage).read());
							image = ref.getBitmap();
			    		}else{
							TiDrawableReference ref = TiDrawableReference.fromUrl(getActivity(), (String) inputImage);
							image = ref.getBitmap();
			    		}	    			
		    		}
		    	}			
			}	
			return image;
			
		} catch (IOException e) {
			Log.e(MODULE_FULL_NAME, e.getMessage());
			e.printStackTrace();
			return null;
		}		
	}
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Kroll.method
	public TiBlob applyBlurTo(HashMap hm){
		KrollDict args = new KrollDict(hm);
		float blurRadius = 8f;
		
		//Make sure we have an image
		if(!args.containsKeyAndNotNull(PROPERTY_IMAGE)){
			throw new IllegalArgumentException("missing image property");
		}
		
		//Get our image object
		Object workingImg = args.get(PROPERTY_IMAGE);
		
		//Find our blur radius
		if(args.containsKeyAndNotNull(PROPERTY_BLUR_RADIUS)){
			double tempR = args.getDouble(PROPERTY_BLUR_RADIUS);
			blurRadius = (float)(tempR);
		}
		
		//Load bitmap image
		Bitmap image = loadImage(workingImg);

		if(image == null){
			Log.e(MODULE_FULL_NAME, "Unable to load image, returning null");
			return null;
		}

		//Apply Box blur
		image = BoxBlur.blur((int) blurRadius, image);
		
		if(image == null){
			Log.e(MODULE_FULL_NAME, "Unable to blur image, returning null");
			return null;
		}
		
		return TiBlob.blobFromImage(image);
	}
}


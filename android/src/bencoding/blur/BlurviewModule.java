/**
 * Bencoding Blur View project
 * Copyright (c) 2010-2014 by Benjamin Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */
package bencoding.blur;

import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.annotations.Kroll;

import org.appcelerator.titanium.TiApplication;

@Kroll.module(name="Blurview", id="bencoding.blur")
public class BlurviewModule extends KrollModule
{

	// Standard Debugging variables
	public static final String MODULE_FULL_NAME = "bencoding.blur";

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
}


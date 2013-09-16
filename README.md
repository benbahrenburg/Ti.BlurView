<h1>Ti.BlurView</h1>

The Ti.BlurView project allows you to create a blur view using either the contents of a view or a provided image.

![Default](https://raw.github.com/benbahrenburg/Ti.BlurView/master/iOS/blurview_background_demo.png)
![Default](https://raw.github.com/benbahrenburg/Ti.BlurView/master/iOS/blurview_cropped_demo.png)
![Default](https://raw.github.com/benbahrenburg/Ti.BlurView/master/iOS/blurview_tinted_cropped_demo.png)

<h2>Before you start</h2>
* This is an iOS native module designed to work with Titanium SDK 3.1.2.GA
* This will only work with iOS <b>6</b> or greater
* Before using this module you first need to install the package. If you need instructions on how to install a 3rd party module please read this installation guide.

<h2>Download the compiled release</h2>

Download the module from the [dist folder](https://github.com/benbahrenburg/Ti.BlurView/tree/master/iOS/dist)

<h2>Building from source?</h2>

If you are building from source you will need to do the following:

Import the project into Xcode:

* Modify the titanium.xcconfig file with the path to your Titanium installation

<h2>Setup</h2>

* Download the latest release from the releases folder ( or you can build it yourself )
* Install the ti.sq module. If you need help here is a "How To" [guide](https://wiki.appcelerator.org/display/guides/Configuring+Apps+to+Use+Modules). 
* You can now use the module via the commonJS require method, example shown below.

<h2>Importing the module using require</h2>
<pre><code>
var mod = require('bencoding.blur');
</code></pre>

<h2>Creating a blur view</h2>
The Ti.BlurView supports a majority of the standard [Ti.UI.View](http://docs.appcelerator.com/titanium/latest/#!/api/Titanium.UI.View) properties.  The below listed properties are specific to the Ti.BlurView.

<b>Parameters</b>

<b>blurLevel</b> (optional): float

The blurLevel property sets how blurry the view is.  By default this value is 5.

<b>blurCroppedToRect</b> : Boolean

The blurCroppedToRect property is a boolean value that determines if the Ti.BlurView should crop the image or view contents to the overlap area of the Ti.BlurView.  The blurCroppedToRect property is true by default.  If you want to do a blurred background view such as the Yahoo weather app you must set the blurCroppedToRect property to false.  See the below examples for details.

<b>This property will not take effect if updated after the viewToBlur or imageToBlur has rendered.</b>

<b>blurTintColor</b> : String / Color

The blurTintColor property is the color tint that should be apply as part of the blur process.  By default this is set to transparent.

<b>This property will not take effect if updated after the viewToBlur or imageToBlur has rendered.</b>

<b>viewToBlur</b> : TiUIView

The viewToBlur property contains a reference to the view who's contents you wish to display in the Ti.BlurView.

<b>IMPORTANT:</b>
* The viewToBlur should not be called until the referencing view has been rendered. It is recommended this value is set on a window "open" event or other method that ensures the view to be used will be attahed and rendered to the screen first.
* If you wish to change the blurCroppedToRect, blurTintColor, or blurFilter you must do so before setting this property.

<b>imageToBlur</b> :  Url to image

The imageToBlur property is the url to an image that will be used as to be blurred for display in the Ti.BlurView.  Unlike the viewToBlur property the imageToBlur property can be set before the window has fully rendered.

<b>IMPORTANT:</b>
* Remember by default the image provided will be cropped as an overlay using the Ti.BlurView's frame. If this is not the desired effect set blurCroppedToRect to false.
* If you wish to change the blurCroppedToRect, blurTintColor, or blurFilter you must do so before setting this property.

<b>blurFilter</b> :  String

The blurFilter property sets which filter is used during the bend process.  By default this is set to CIGaussianBlur. 

Other valid values would be CIBoxBlur:
 - CIDiscBlur
 - CIGaussianBlur
 - CIMotionBlur
 - CIZoomBlur

<h3>Examples</h3>
Please check the module's example folder or on [github](https://github.com/benbahrenburg/Ti.BlurView/tree/master/iOS/example) for examples on how to use this module.

<b>Example - Blurred Background</b>
<pre><code>
var mod = require('bencoding.blur');

var win = Ti.UI.createWindow({
	backgroundColor:'blue'
});

var bgView = Ti.UI.createView({
	height:Ti.UI.FILL, width:Ti.UI.FILL,
	backgroundImage:"42553_m.jpg"
});
win.add(bgView);

var blurView = mod.createView({
	height:Ti.UI.FILL, width:Ti.UI.FILL, 
	blurLevel:5, blurCroppedToRect:false
});
bgView.add(blurView);	

win.addEventListener('open',function(d){
	blurView.viewToBlur = bgView;
	
	var container = Ti.UI.createView({
		backgroundColor:"#fff", borderRadius:20,
		top:100, height:150, left:40, right:40
	});
	blurView.add(container);
	var label = Ti.UI.createLabel({
		text:"Show how to blur like the yahoo weather app.", 
		color:"#000", width:Ti.UI.FILL, height:50, textAlign:"center"
	});	
	container.add(label);	
});

win.open();
</code></pre>

<b>Example - Blurred and Tinted Background</b>
<pre><code>
var mod = require('bencoding.blur');

var win = Ti.UI.createWindow({
	backgroundColor:'blue'
});

var bgView = Ti.UI.createView({
	height:Ti.UI.FILL, width:Ti.UI.FILL,
	backgroundImage:"42553_m.jpg"
});
win.add(bgView);

var blurView = mod.createView({
	top:100, left:40, right:40, bottom:100, 
	blurLevel:5, blurTintColor:"#9EDEB8", blurCroppedToRect:false
});
bgView.add(blurView);	

win.addEventListener('open',function(d){
	
	blurView.viewToBlur = bgView;
	
	var container = Ti.UI.createView({
		backgroundColor:"#fff", borderRadius:20,
		top:100, height:150, left:40, right:40
	});
	blurView.add(container);
	var label = Ti.UI.createLabel({
		text:"BlurView Tinted background", 
		color:"#000", width:Ti.UI.FILL, height:50, textAlign:"center"
	});	
	container.add(label);	
});

win.open();

</code></pre>
<b>Example - Blurred Overlay</b>
<pre><code>
var mod = require('bencoding.blur');
var win = Ti.UI.createWindow({
	backgroundColor:'blue'
});

var bgView = Ti.UI.createView({
	height:Ti.UI.FILL, width:Ti.UI.FILL,
	backgroundImage:"42553_m.jpg"
});
win.add(bgView);

var blurView = mod.createView({
	top:100, left:40, right:40, bottom:100, 
	blurLevel:5, blurCroppedToRect:true
});
bgView.add(blurView);	

win.addEventListener('open',function(d){
	
	blurView.viewToBlur = bgView;
	
	var container = Ti.UI.createView({
		backgroundColor:"#fff", borderRadius:20,
		top:100, height:150, left:10, right:10
	});
	blurView.add(container);

	var label = Ti.UI.createLabel({
		text:"BlurView Cropped to view size", 
		color:"#000", width:Ti.UI.FILL, height:50, textAlign:"center"
	});	
	container.add(label);	
});

win.open();
</code></pre>

<b>Example - Blurred and Tinted Overlay</b>
<pre><code>
	var mod = require('bencoding.blur');

var win = Ti.UI.createWindow({
	backgroundColor:'blue'
});

var bgView = Ti.UI.createView({
	height:Ti.UI.FILL, width:Ti.UI.FILL,
	backgroundImage:"42553_m.jpg"
});
win.add(bgView);

var blurView = mod.createView({
	top:100, left:40, right:40, bottom:100, 
	blurLevel:5, blurTintColor:"#9EDEB8", blurCroppedToRect:true
});
bgView.add(blurView);	

win.addEventListener('open',function(d){
	
	blurView.viewToBlur = bgView;
	
	var container = Ti.UI.createView({
		backgroundColor:"#fff", borderRadius:20,
		top:100, height:150, left:10, right:10
	});
	blurView.add(container);
	var label = Ti.UI.createLabel({
		text:"BlurView Tinted\nand Cropped", 
		color:"#000", width:Ti.UI.FILL, height:50, textAlign:"center"
	});	
	container.add(label);	
});

win.open();
</code></pre>

<h2>Doing a blur without the view</h2>
If you need a greater level of control you can use the applyBlurTo method to perform the image operations yourself.

<h3>applyBlurTo</h3>

The applyBlurTo method takes a dictionary with the following fields.

<b>Fields</b>

<b>blurLevel</b> (optional): float

The blurLevel property sets how blurry the view is.  By default this value is 5.

<b>cropToRect</b> : Dictionary

The cropToRect parameter is a dictionary containing the x,y,width, and height values the provided object should be cropped to.

<b>This property will not take effect if updated after the viewToBlur or imageToBlur has rendered.</b>

<b>blurTintColor</b> : String / Color

The blurTintColor parameter is the color tint that should be apply as part of the blur process.  By default this is set to transparent.

<b>This parameter will not take effect if updated after the viewToBlur or imageToBlur has rendered.</b>

<b>viewToBlur</b> : TiUIView

The viewToBlur parameter contains a reference to the view who's contents you wish to have an image generated from.

<b>imageToBlur</b> :  Url to image

The imageToBlur parameter is the url to an image that will be used in the blur process.

<b>blobToBlur</b> : TiBlob

The blobToBlur parameter is the blob image you wish to have used in the blur process.  This is commonly created by calling the toImage() method on the view you wish to blur.

<b>blurFilter</b> :  String

The blurFilter property sets which filter is used during the bend process.  By default this is set to CIGaussianBlur. 

Other valid values would be CIBoxBlur:
 - CIDiscBlur
 - CIGaussianBlur
 - CIMotionBlur
 - CIZoomBlur

<b>Example - Blurred Background</b>
<pre><code>
var mod = require('bencoding.blur');

var win = Ti.UI.createWindow({
	backgroundColor:'blue'
});

var bgView = Ti.UI.createView({
	height:Ti.UI.FILL, width:Ti.UI.FILL,
	backgroundImage:"42553_m.jpg"
});
win.add(bgView);

var imgView = Ti.UI.createImageView({
	height:Ti.UI.FILL, width:Ti.UI.FILL, 
});
bgView.add(imgView);	

win.addEventListener('open',function(d){

	var img = mod.applyBlurToImage({
		blobToBlur: bgView.toImage(),
		blurLevel:5, blurTintColor:"#9EDEB8"
	});

	blurView.image = img;

	var container = Ti.UI.createView({
		backgroundColor:"#fff", borderRadius:20,
		top:100, height:150, left:40, right:40
	});
	blurView.add(container);
	var label = Ti.UI.createLabel({
		text:"Show how to blur like the yahoo weather app.", 
		color:"#000", width:Ti.UI.FILL, height:50, textAlign:"center"
	});	
	container.add(label);	
});

win.open();

</code></pre>

<b>Example - Blurred Cropped Overlay</b>
<pre><code>
var mod = require('bencoding.blur');

var win = Ti.UI.createWindow({
	backgroundColor:'blue'
});

var bgView = Ti.UI.createView({
	height:Ti.UI.FILL, width:Ti.UI.FILL,
	backgroundImage:"42553_m.jpg"
});
win.add(bgView);

var imgView = Ti.UI.createImageView({
	top:100, left:40, right:40, bottom:100
});
bgView.add(imgView);	

win.addEventListener('open',function(d){

	var img = mod.applyBlurToImage({
		blobToBlur: bgView.toImage(),
		blurLevel:5, blurTintColor:"#9EDEB8",
		cropToRect:{
			x:bgView.rect.x,
			y:bgView.rect.y,
			width:bgView.rect.width,
			height:bgView.rect.height
		}
	});
	
	blurView.image = img;

	var container = Ti.UI.createView({
		backgroundColor:"#fff", borderRadius:20,
		top:100, height:150, left:40, right:40
	});
	blurView.add(container);
	var label = Ti.UI.createLabel({
		text:"Show how to blur like the yahoo weather app.", 
		color:"#000", width:Ti.UI.FILL, height:50, textAlign:"center"
	});	
	container.add(label);	
});

win.open();
</code></pre>

<h3>Twitter</h3>

If you like the Titanium module,please consider following the [@benCoding Twitter](http://www.twitter.com/benCoding) for updates.

<h3>Blog</h3>

For module updates, Titanium tutorials and more please check out my blog at [benCoding.Com](http://benCoding.com).

<h3>Attribution</h3>

The Blur method uses CoreImage in the fashion detailed by Evan Davis [here](http://evandavis.me/blog/2013/2/13/getting-creative-with-calayer-masks).

The image used in all of the examples is by [thenails](http://www.flickr.com/people/thenails1/) and is licenced under Creative Commons. This image is and associated licensing is available [here](http://ny-pictures.com/nyc/photo/picture/42553/nostalgic_view_famous_hall).

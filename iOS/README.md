<h1>Ti.BlurView</h1>

The Ti.BlurView project allows you to create a blur view using either the contents of a view or a provided image.

Below is a gif showing the example app in action. For a more complete walk through see the [video](http://www.youtube.com/watch?v=mXU5dUkibls).

![Animation](https://raw.github.com/benbahrenburg/Ti.BlurView/master/Screenshots/ios_demo.gif)

<h2>Before you start</h2>
* This is an iOS native module designed to work with Titanium SDK 3.2.0.GA
* This will only work with iOS <b>6</b> or greater
* Before using this module you first need to install the package. If you need instructions on how to install a 3rd party module please read this installation guide.

<h2>Download the compiled release</h2>

Download the module from the [dist folder](https://github.com/benbahrenburg/Ti.BlurView/tree/master/iOS/dist)

<h2>Building from source?</h2>

If you are building from source you will need to do the following:

Import the project into Xcode:

* Modify the titanium.xcconfig file with the path to your Titanium installation
* When running this project from Xcode you might run into a compile issue. If this is the case you will need to update the titanium.xcconfig to include your username. See the below for an example:

~~~
TITANIUM_SDK = /Users/benjamin/Library/Application Support/Titanium/mobilesdk/osx/$(TITANIUM_SDK_VERSION)
~~~

<h2>Setup</h2>

* Download the latest release from the releases folder ( or you can build it yourself )
* Install the ti.sq module. If you need help here is a "How To" [guide](https://wiki.appcelerator.org/display/guides/Configuring+Apps+to+Use+Modules). 
* You can now use the module via the commonJS require method, example shown below.

<h2>Importing the module using require</h2>
<pre><code>
var mod = require('bencoding.blur');
</code></pre>

<h2>Blur View</h2>


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

<b>view</b> : TiUIView

The view parameter contains a reference to the view who's contents you wish to have an image generated from.

<b>image</b> :  Url to image

The image parameter is the url to an image that will be used in the blur process.

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

	var img = mod.applyBlurTo({
		image: bgView.toImage(),
		blurLevel:5, blurTintColor:"#9EDEB8"
	});

	imgView.image = img;

	var container = Ti.UI.createView({
		backgroundColor:"#fff", borderRadius:20,
		top:100, height:150, left:40, right:40
	});
	imgView.add(container);
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

	var img = mod.applyBlurTo({
		view: bgView,
		blurLevel:5, blurTintColor:"#9EDEB8",
		cropToRect:{
			x:imgView.rect.x,
			y:imgView.rect.y,
			width:imgView.rect.width,
			height:imgView.rect.height
		}
	});
	
	imgView.image = img;

	var container = Ti.UI.createView({
		backgroundColor:"#fff", borderRadius:20,
		top:100, height:150, left:40, right:40
	});
	imgView.add(container);
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

The Blur method was inspired by the CoreImage tutorial by Evan Davis [here](http://evandavis.me/blog/2013/2/13/getting-creative-with-calayer-masks).

The image used in all of the examples is by [thenails](http://www.flickr.com/people/thenails1/) and is licenced under Creative Commons. This image is and associated licensing is available [here](http://ny-pictures.com/nyc/photo/picture/42553/nostalgic_view_famous_hall).

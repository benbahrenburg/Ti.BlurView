<h1>Image Blur - iOS</h1>
How to use the Blur effects without using a view object.

<h2>Doing a blur without the view</h2>
If you need a greater level of control you can use the applyBlurTo method to perform the image operations yourself.

<h3>applyBlurTo</h3>

The applyBlurTo method takes a dictionary with the following fields.

<b>Fields</b>

<b>blurLevel</b> (optional): float

The blurLevel property sets how blurry the image is.  By default this value is 5.

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

***This URL must be local to your app, remove images are not supported***

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


<h3>applyGPUBlurTo</h3>

The applyGPUBlurTo method takes a dictionary with the following fields.

<b>Fields</b>

<b>type</b> : The type of GPU Blur effect to be used.

The type of GPU Blur effect to be used. Supported; IOS_BLUR, BOX_BLUR, GAUSSIAN_BLUR

<b>image</b> :  Url to image

The image parameter is the url to an image that will be used in the blur process.

***This URL must be local to your app, remove images are not supported***


<b>Example - GPU Blurred Background</b>
<pre><code>
var mod = require('bencoding.blur');

var win = Ti.UI.createWindow({
	backgroundColor:'blue'
});

var imgView = Ti.UI.createImageView({
	height:Ti.UI.FILL, width:Ti.UI.FILL, 
});
bgView.add(imgView);	

win.addEventListener('open',function(d){

	var img = mod.applyGPUBlurTo({
		image: "42553_m.jpg", type:mod.IOS_BLUR
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


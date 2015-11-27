<h1>Image Blur - Android</h1>
How to use the Blur effects without using a view object.

<h2>Doing a blur without the view</h2>
If you need a greater level of control you can use the applyBlurTo method to perform the image operations yourself.

<h3>applyBlurTo</h3>

The applyBlurTo method takes a dictionary with the following fields.

<b>Fields</b>

<b>blurRadius</b> (optional): float

The blurRadius property sets how blurry the image is.  By default this value is 8.

<b>image</b> :  Url to image

The image parameter is the url to an image that will be used in the blur process.
***This URL must be local to your app, remote images are not supported***

<b>Example - Blurred Background</b>
<pre><code>
var mod = require('bencoding.blur');

var win = Ti.UI.createWindow({
	backgroundColor:'white', title:"Image Blur Demo"
});

var imgblurredImage = mod.applyBlurTo({
	image:'42553_m.jpg',
	blurRadius:10
});

var vwTest = Ti.UI.createImageView({
	width:Ti.UI.FILL, height:Ti.UI.FILL,
	image:imgblurredImage
});

win.add(vwTest);

win.open();

</code></pre>

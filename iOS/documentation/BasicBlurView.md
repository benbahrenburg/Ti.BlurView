<h1>BasicBlurView - iOS</h1>
Details on how to use the BasicBlurView.  This is a convenance wrapper around the Box Blur functionality of GPUBlurImageView


<h2>Creating a BasicBlurView</h2>
The BasicBlurView supports a majority of the standard [Ti.UI.ImageView](http://docs.appcelerator.com/titanium/latest/#!/api/Titanium.UI.ImageView) properties and provides one new blur related property, blurRadius.

<h3>Properties</h3>

<b>image</b> : String/Titanium.Blob/Titanium.Filesystem.File

Image to blur then display, defined using a local filesystem path, a File object, a remote URL, or a Blob object containing image data. Blob and File objects are not supported on Mobile Web.


<b>blurRadius</b> : Number

The amount of blur radius that should be applied to the image


<b>Example</b>
~~~
	var vwTest = mod.createBasicBlurView({
		width:Ti.UI.FILL, height:Ti.UI.FILL, blurRadius:5,
		image: 'your-image-here.png'
	});
~~~
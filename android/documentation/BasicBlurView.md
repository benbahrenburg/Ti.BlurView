<h1>BasicBlurView - Android</h1>
Details on how to use the BasicBlurView.  


<h2>Creating a BasicBlurView</h2>
The BasicBlurView extends a traditional [Ti.UI.View](http://docs.appcelerator.com/titanium/latest/#!/api/Titanium.UI.View) by providing two new properties, image and blurRadius.  Once these properties are set, the blur effect will be generated. 

The below listed properties are specific to the BasicBlurView.

<h3>Properties</h3>

<b>image</b> : String/Titanium.Blob/Titanium.Filesystem.File

Image to blur then display, defined using a local filesystem path, a File object, a remote URL, or a Blob object containing image data. Blob and File objects are not supported on Mobile Web.


<b>blurRadius</b> : Number

The amount of blur radius that should be applied to the image


<b>Example</b>
~~~
	var vwTest = mod.createBasicBlurView({
		width:Ti.UI.FILL, height:Ti.UI.FILL, blurRadius:10,
		image: 'your-image-here.png'
	});
~~~


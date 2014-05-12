<h1>GPU Blur ImageView</h1>
Details on how to use the GPU Blur ImageView.  The Blur ImageView uses the [GPUImage](https://github.com/BradLarson/GPUImage) project by [Brad Larson](https://github.com/BradLarson).

<h2>Creating a GPU ImageView</h2>
The Ti.GPUBlurImageView supports a majority of the standard [Ti.UI.ImageView](http://docs.appcelerator.com/titanium/latest/#!/api/Titanium.UI.ImageView) properties.  The below listed properties are specific to the GPUBlurImageView.

<h3>Properties</h3>

<b>blur</b> : Dictionary
A dictionry containing the blur options
*type : the type of GPU Blur effect to be used. Supported; IOS_BLUR, BOX_BLUR, GAUSSIAN_BLUR
* radiusInPixels : amount of blur that should be applied

Optional options for IOS_BLUR:

* saturation : Saturation ranges from 0.0 (fully desaturated) to 2.0 (max saturation), with 0.8 as the normal level
* downsampling : The degree to which to downsample, then upsample the incoming image to minimize computations within the Gaussian blur, with a default of 4.0.


Optional options for BOX_BLUR and GAUSSIAN_BLUR

* radiusAsFractionOfImageWidth :  Setting these properties will allow the blur radius to scale with the size of the image
* radiusAsFractionOfImageHeight :  Setting these properties will allow the blur radius to scale with the size of the image
* passes : The number of times to sequentially blur the incoming image. The more passes, the slower the filter.

<b>iOS Blur Example</b>
~~~
var imgView = mod.createGPUBlurImageView({
	height:Ti.UI.FILL, width:Ti.UI.FILL,
	image:"42553_m.jpg",
	blur:{
		type:mod.IOS_BLUR, radiusInPixels:1
	}		
});
~~~

<b>Box Blur Example</b>
~~~
var imgView = mod.createGPUBlurImageView({
	height:Ti.UI.FILL, width:Ti.UI.FILL,
	image:"42553_m.jpg",
	blur:{
		type:mod.BOX_BLUR, radiusInPixels:5
	}		
});
~~~

<b>Gaussian Blur Example</b>
~~~
var imgView = mod.createGPUBlurImageView({
	height:Ti.UI.FILL, width:Ti.UI.FILL,
	image:"42553_m.jpg",
	blur:{
		type:mod.GAUSSIAN_BLUR, radiusInPixels:2.5
	}		
});
~~~
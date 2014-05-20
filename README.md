<h1>Ti.Blur</h1>

The Ti.Blur project allows you to create a blur view using either the contents of a view or a provided image.

Below is a gif showing the example app in action on both iOS and Android.  For a more complete walk through see the [video](http://www.youtube.com/watch?v=mXU5dUkibls).

![Animation](https://raw.githubusercontent.com/benbahrenburg/Ti.BlurView/master/Screenshots/ios_demo.gif)


<h2>Before you start</h2>
* This is an iOS and Android native module designed to work with Titanium SDK 3.2.0.GA
* This will only work with iOS <b>6</b> or greater and Android <b>4.2</b> or greater
* Before using this module you first need to install the package. If you need instructions on how to install a 3rd party module please read this installation guide.

<h2>Download the compiled release</h2>

* [iOS Dist](https://github.com/benbahrenburg/Ti.BlurView/tree/master/iOS/dist)
* [Android Dist](https://github.com/benbahrenburg/Ti.BlurView/tree/master/android/dist)
* Install from gitTio    [![gitTio](http://gitt.io/badge.png)](http://gitt.io/component/bencoding.blur)

<h2>Building from source?</h2>

If you are building from source you will need to do the following:

Import the project into Xcode:

* Modify the titanium.xcconfig file with the path to your Titanium installation
* When running this project from Xcode you might run into a compile issue. If this is the case you will need to update the titanium.xcconfig to include your username. See the below for an example:

~~~
TITANIUM_SDK = /Users/benjamin/Library/Application Support/Titanium/mobilesdk/osx/$(TITANIUM_SDK_VERSION)
~~~

Import the project into Eclipse:

* Update the .classpath
* Update the build properties

<h2>Setup</h2>

* Download the latest release from the releases folder ( or you can build it yourself )
* Install the ti.sq module. If you need help here is a "How To" [guide](https://wiki.appcelerator.org/display/guides/Configuring+Apps+to+Use+Modules). 
* You can now use the module via the commonJS require method, example shown below.

<h2>Importing the module using require</h2>
<pre><code>
var mod = require('bencoding.blur');
</code></pre>

<h2>Module Features</h2>

<h3>BasicBlurView</h3>

Platform Supported: <b>iOS</b> and <b>Android</b>

BasicBlurView provides a view implemented box blur. This results in an effect similar to what you see in iOS 7. The BasicBlurView object provides this blur functionality in a cross-platform way.

To learn more about BasicBlurView please read the documentation:

* [Android](https://github.com/benbahrenburg/Ti.BlurView/blob/master/android/documentation/BasicBlurView.md)
* [iOS](https://github.com/benbahrenburg/Ti.BlurView/blob/master/iOS/documentation/BasicBlurView.md)

<h3>Blur View</h3>

Platform Supported: <b>iOS</b>

The BlurView provides a series of methods you can use to implement a blur effect similar to that used in iOS 7.  The BlurView is an extended Ti.UI.View that implements a Blur effect and allows you to implement background clipping.

To learn more about the BlurView please read the documentation [here](https://github.com/benbahrenburg/Ti.BlurView/blob/master/iOS/documentation/BlurView.md).

<h3>Blur GPUImageView</h3>

Platform Supported: <b>iOS</b>

The GPUBlurImageView allows you to implement a blur effect similar to that used in iOS 7.  The GPUBlurImageView ImageView uses the [Brad Larson](https://github.com/BradLarson) [GPUImage](https://github.com/BradLarson/GPUImage) project render the blur effect quickly using little device resources.

To learn more about the GPUBlurImageView please read the documentation [here](https://github.com/benbahrenburg/Ti.BlurView/blob/master/iOS/documentation/GPUBlurImageView.md).

<h2>Doing a blur without the view</h2>

Want to blur your images directly without using a View or ImageView?  The applyGPUBlurTo and applyBlurTo methods allow you to do this quickly and easily.

<b>Android</b>

<b>iOS</b>

To learn more about how to apply the blur effect without using a view please read the documentation [here](https://github.com/benbahrenburg/Ti.BlurView/blob/master/iOS/documentation/BlurImage.md).


<h2>Module Properties</h2>

Platform Supported: <b>iOS</b>

<b>IOS_BLUR</b> : Used in the blur type property of the GPUBlurImageView object.  Using a type of IOS_BLUR replicates the background blur used on iOS 7 in places like the control center.

<b>BOX_BLUR</b> : Used in the blur type property of the GPUBlurImageView object.  Using a type of BOX_BLUR implements a hardware-optimized, variable-radius box blur.

<b>GAUSSIAN_BLUR</b> : Used in the blur type property of the GPUBlurImageView object.  Using a type of GAUSSIAN_BLUR implements A hardware-optimized, variable-radius Gaussian blur.

<h3>Twitter</h3>

If you like the Titanium module,please consider following the [@bencoding Twitter](http://www.twitter.com/bencoding) for updates.

<h3>Blog</h3>

For module updates, Titanium tutorials and more please check out my blog at [benCoding.Com](http://benCoding.com).

<h3>Attribution</h3>

The Blur method used in the Blur.View was inspired by the CoreImage tutorial by Evan Davis [here](http://evandavis.me/blog/2013/2/13/getting-creative-with-calayer-masks).

The image used in all of the examples is by [thenails](http://www.flickr.com/people/thenails1/) and is licenced under Creative Commons. This image is and associated licensing is available [here](http://ny-pictures.com/nyc/photo/picture/42553/nostalgic_view_famous_hall).

The GPUImageView uses the [Brad Larson](https://github.com/BradLarson) [GPUImage](https://github.com/BradLarson/GPUImage) project render the blur.  I can't recommend this library enough.

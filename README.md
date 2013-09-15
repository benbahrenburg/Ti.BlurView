<h1>Ti.BlurView</h1>

The Ti.BlurView project allows you to create a blur view using either the contents of a view or a provided image.

![Default](https://raw.github.com/benbahrenburg/Ti.BlurView/master/blur_background_demo.png)

<h2>Before you start</h2>
* This is an iOS native module designed to work with Titanium SDK 3.1.2.GA
* This will only work with iOS <b>6.1</b> or greater
* Before using this module you first need to install the package. If you need instructions on how to install a 3rd party module please read this installation guide.

<h2>Download the compiled release</h2>

Download the module from the [dist folder](https://github.com/benbahrenburg/Ti.BlurView/tree/master/dist)


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

<b>blurLevel</b> : float

WIP

<b>viewToBlur</b> : TiUIView

WIP

<b>imageToBlur</b> :  Url to image

WIP

<b>blurFilter</b> :  String

WIP

<b>blurCroppedToRect</b> : Boolean

WIP

<b>blurTintColor</b> : String / Color

WIP

<h3>Examples</h3>
Please check the module's example folder or on [github](https://github.com/benbahrenburg/Ti.BlurView/tree/master/example) for examples on how to use this module.

<b>Example - Blurred Background</b>
<pre><code>
</code></pre>

<b>Example - Blurred Overlay</b>
<pre><code>
</code></pre>

<b>Example - Blurred and Tinted Background</b>
<pre><code>
</code></pre>

<b>Example - Blurred and Tinted Overlay</b>
<pre><code>
</code></pre>


<h3>Twitter</h3>

If you like the Titanium module,please consider following the [@benCoding Twitter](http://www.twitter.com/benCoding) for updates.

<h3>Blog</h3>

For module updates, Titanium tutorials and more please check out my blog at [benCoding.Com](http://benCoding.com).

<h3>Attribution</h3>

The Blur method uses CoreImage in the fashion detailed by Evan Davis [here](http://evandavis.me/blog/2013/2/13/getting-creative-with-calayer-masks).

The image used in all of the examples is by [thenails](http://www.flickr.com/people/thenails1/) and is licenced under Creative Commons. This image is and associated licensing is available [here](http://ny-pictures.com/nyc/photo/picture/42553/nostalgic_view_famous_hall).

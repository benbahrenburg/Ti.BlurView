<h1>Blur View</h1>
Details on how to use the Blur View

<h2>Creating a blur view</h2>
The Ti.BlurView supports a majority of the standard [Ti.UI.View](http://docs.appcelerator.com/titanium/latest/#!/api/Titanium.UI.View) properties.  The below listed properties are specific to the Ti.BlurView.

<h3>Properties</h3>

<b>blurLevel</b> (optional): float

The blurLevel property sets how blurry the view is.  By default this value is 5.

<b>blurCroppedToRect</b> : Boolean

The blurCroppedToRect property is a boolean value that determines if the Ti.BlurView should crop the image or view contents to the overlap area of the Ti.BlurView.  The blurCroppedToRect property is true by default.  If you want to do a blurred background view such as the Yahoo weather app you must set the blurCroppedToRect property to false.  See the below examples for details.

<b>This property will not take effect if updated after the viewToBlur or imageToBlur has rendered.</b>

<b>blurTintColor</b> : String / Color

The blurTintColor property is the color tint that should be apply as part of the blur process.  By default this is set to transparent.

<b>This property will not take effect if updated after the viewToBlur or imageToBlur has rendered.</b>

<b>backgroundView</b> : TiUIView

The backgroundView property contains a reference to the view who's contents you wish to display in the Ti.BlurView.

<b>IMPORTANT:</b>
* If blurCroppedToRect is true (default setting) you will need to make sure the view referenced in backgroundView has rendered before setting this property.  This can be in the open event of the window.  You can also use the onPresent event of Ti.BlurView to perform this action.
* If you wish to change the blurCroppedToRect, blurTintColor, or blurFilter you must do so before setting this property.

<b>image</b> :  Url to image

The image property is the url to an image that will be used as to be blurred for display in the Ti.BlurView.  

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


<h3>Methods</h3>

<b>clearContents</b>

The clearContents method, removes the contents of the BlurView

~~~

blurView.clearContents();

~~~

<h3>Events</h3>

<b>onPresent</b> 

The onPresent event is fired when the view is rendered or refreshed.  This is a good place to se the backgroundView you are using the blurCroppedToRect:true and the referencing view has not yet rendered to screen.

~~~
blurView.addEventListener('onPresent',function(d){
	Ti.API.info('onPresent fired');
	blurView.backgroundView = bgView;
});
~~~

<b>onSizeChanged</b> 

The onSizeChanged event is fired when the view is resized.  If you need to adjust the image or backgroundView you can use this event to resample.

~~~
blurView.addEventListener('onSizeChanged',function(d){
	Ti.API.info('onPresent fired');
	blurView.backgroundView = bgView;
});
~~~

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
	blurLevel:5, blurCroppedToRect:false,
	backgroundView:bgView
});
bgView.add(blurView);	

win.addEventListener('open',function(d){
	
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
	blurLevel:5, blurTintColor:"#9EDEB8", 
	blurCroppedToRect:false, backgroundView:bgView
});
bgView.add(blurView);	

win.addEventListener('open',function(d){
	
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

blurView.addEventListener('onPresent',function(d){
	Ti.API.info('onPresent fired');
	blurView.backgroundView = bgView;
});

win.addEventListener('open',function(d){
	
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
	blurLevel:5, blurTintColor:"#9EDEB8", 
	blurCroppedToRect:true
});
bgView.add(blurView);	

blurView.addEventListener('onPresent',function(d){
	Ti.API.info('onPresent fired');
	blurView.backgroundImage = bgView;
});

win.addEventListener('open',function(d){
	
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
var mod = require('bencoding.blur');
Ti.API.info("module is => " + mod);
Ti.UI.backgroundColor = "purple";

// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'blue'
});

var context = Ti.UI.createView({
	height:Ti.UI.FILL,
	width:Ti.UI.FILL
});
win.add(context);

var label = Ti.UI.createLabel({
	text:"Hello this is a blur test", 
	color:"#fff", width:Ti.UI.FILL,
	height:50
});
context.add(label);

var blurView = mod.createView({
	height:200, width:200,
	blurLevel:25, imageToBlur:"logo.png"
});
context.add(blurView);	

win.addEventListener('open',function(d){
	//blurView.top = 40;
	//blurView.viewToBlur = context;
});

win.open();


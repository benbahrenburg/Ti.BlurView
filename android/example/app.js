// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.


var mod = require('bencoding.blur');
Ti.API.info("module is => " + mod);

// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});

var vwTest = mod.createBlurImageView({
	width:Ti.UI.FILL, height:Ti.UI.FILL, blurRadius:10,
	image: '42553_m.jpg', backgroundColor:'red'
});
win.add(vwTest);

win.open();


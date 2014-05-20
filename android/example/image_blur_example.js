//image sample provided by http://ny-pictures.com/nyc/photo/picture/42553/nostalgic_view_famous_hall

var mod = require('bencoding.blur');
Ti.API.info("module is => " + mod);

exports.createWindow = function(){

	// open a single window
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
	
	return win;	
};


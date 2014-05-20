//image sample provided by http://ny-pictures.com/nyc/photo/picture/42553/nostalgic_view_famous_hall

var _imgBlur = require('image_blur_example'),
	_basicBlur = require('basic_blur_view_example');

// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white', title:"Android Blur Demos"
});

var btnBasic = Ti.UI.createButton({
	title:"Basic Blur Demo", 
	left:10, right:10, height:65, top:45
});
win.add(btnBasic);
btnBasic.addEventListener('click',function(e){
	_basicBlur.createWindow().open();
});

var btnImgBlur = Ti.UI.createButton({
	title:"Image Blur Demo", 
	left:10, right:10, height:65, top:150
});
win.add(btnImgBlur);
btnImgBlur.addEventListener('click',function(e){
	_imgBlur.createWindow().open();	
});

win.open();


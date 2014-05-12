//image sample provided by http://ny-pictures.com/nyc/photo/picture/42553/nostalgic_view_famous_hall

var mod = require('bencoding.blur');
	
exports.createWindow = function(){	

	var win = Ti.UI.createWindow({
		backgroundColor:'blue',barColor:"#999",
		title:"GPU Box Blur"
	});
	
	
	var imgView = mod.createGPUBlurImageView({
		height:Ti.UI.FILL, width:Ti.UI.FILL,
		image:"42553_m.jpg",
		blur:{
			type:mod.BOX_BLUR, radiusInPixels:5
		}		
	});
	win.add(imgView);	
	
	var container = Ti.UI.createView({
		backgroundColor:"#fff", borderRadius:20,
		top:100, height:150, left:40, right:40
	});
	imgView.add(container);
	var label = Ti.UI.createLabel({
		text:"GPU Rendered Box Blur", 
		color:"#000", width:Ti.UI.FILL, height:50, textAlign:"center"
	});	
	container.add(label);	
			
	return win;
};
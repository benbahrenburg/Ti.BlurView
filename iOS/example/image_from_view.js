//image sample provided by http://ny-pictures.com/nyc/photo/picture/42553/nostalgic_view_famous_hall

var mod = require('bencoding.blur');
	
exports.createWindow = function(){	

	var win = Ti.UI.createWindow({
		backgroundColor:'blue',barColor:"#999",
		title:"Create Image From View"
	});
	
	var bgView = Ti.UI.createView({
		height:Ti.UI.FILL, width:Ti.UI.FILL,
		backgroundImage:"42553_m.jpg"
	});
	win.add(bgView);
	
	var imgView = Ti.UI.createImageView({
		height:Ti.UI.FILL, width:Ti.UI.FILL
	});
	bgView.add(imgView);	
	
	win.addEventListener('open',function(d){
	
		var img = mod.applyBlurTo({
			view: bgView, blurLevel:5, blurTintColor:"#9EDEB8"
		});
		
		imgView.image = img;
	
		var container = Ti.UI.createView({
			backgroundColor:"#fff", borderRadius:20,
			top:100, height:150, left:40, right:40
		});
		imgView.add(container);
		var label = Ti.UI.createLabel({
			text:"Show how to blur like the yahoo weather app.", 
			color:"#000", width:Ti.UI.FILL, height:50, textAlign:"center"
		});	
		container.add(label);	
	});
	
	return win;
};
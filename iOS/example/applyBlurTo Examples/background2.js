var mod = require('bencoding.blur');

var win = Ti.UI.createWindow({
	backgroundColor:'blue'
});

var bgView = Ti.UI.createView({
	height:Ti.UI.FILL, width:Ti.UI.FILL,
	backgroundImage:"42553_m.jpg"
});
win.add(bgView);

var imgView = Ti.UI.createImageView({
	top:100, left:40, right:40, bottom:100
});
bgView.add(imgView);	

win.addEventListener('open',function(d){

	var img = mod.applyBlurTo({
		image: bgView.toImage(),
		blurLevel:5, blurTintColor:"#9EDEB8"
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

win.open();
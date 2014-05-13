var mod = require('bencoding.blur');
	
exports.createWindow = function(){	

	var win = Ti.UI.createWindow({
		backgroundColor:'blue',barColor:"#999", title:"Timed Blur"
	});

	var webView = Ti.UI.createWebView({
		url:'http://www.appcelerator.com',
		width:Ti.UI.FILL, height:Ti.UI.FILL
	});
	win.add(webView);
	
	var imgView = mod.createGPUBlurImageView({
		height:Ti.UI.FILL, width:Ti.UI.FILL, 
		zIndex:500,top:0,
		blur:{
			type:mod.IOS_BLUR, radiusInPixels:1
		}		
	});
	win.add(imgView);	
	
	var blur ={
		timerId : null,
		apply : function(){
			Ti.API.debug("applyBlur : Taking screenshot");
			var screenshot = webView.toImage();
			Ti.API.debug("applyBlur : Cropping screenshot");
			screenshot.imageAsCropped({x:0,y:0, height:150,width:Ti.Platform.displayCaps.platformWidth});
			Ti.API.debug("applyBlur : set screenshot as image to ImageView");
			imgView.image = screenshot;
			Ti.API.debug("applyBlur : set blur so we will update");
			imgView.blur={
				type:mod.BOX_BLUR, radiusInPixels:5
			};	
			Ti.API.debug("applyBlur : Done with Blur");				
		}
	};

	win.addEventListener('close',function(f){
		if(blur.timerId!=null){
			clearInterval(blur.timerId);
		}	
	});
	
	webView.addEventListener('load',function(f){
		blur.timerId = setInterval(function(){
			blur.apply();
		},1000);
	});
	 	 					
	win.addEventListener('open',function(f){		
		blur.apply();	
	});
	
	return win;
};
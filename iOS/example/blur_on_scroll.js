var mod = require('bencoding.blur');
	
exports.createWindow = function(){	

	var win = Ti.UI.createWindow({
		backgroundColor:'blue',barColor:"#999", title:"Blur on Scroll"
	});

	function createRows() {
	
	    function buildRow(el) {
	        var row = Ti.UI.createTableViewRow({
	            width:150, height:120
	        });
	
	        var headerImage = Ti.UI.createImageView({
	            image: el.image, width:Ti.UI.FILL, height:Ti.UI.FILL
	        });
	
	        var titleLabel = Ti.UI.createLabel({
	            text: el.title,
	            width: Ti.UI.FILL, height: '30dp', color:'green',
	            horizontalWrap: false, bottom: '5dp', left: '5dp', right: '5dp',
	            font: {
	                fontSize: '20dp', fontWeight:'bold'
	            }
	        });
	
	        row.add(headerImage);
	        row.add(titleLabel);
	        return row;
	    };
	
	    var rows=[];
	    for (var iLoop=0;iLoop<100;iLoop++){
	        rows.push(buildRow({ title: 'Test Row '+iLoop, image: 'cat.jpg'}));
	    }
	    return rows;
	};

	var list = Ti.UI.createTableView({
	    width:Ti.UI.FILL,  height:Ti.UI.FILL, data:createRows()
	});
	win.add(list);

	var imgView = mod.createGPUBlurImageView({
		height:250, width:Ti.UI.FILL, zIndex:500,top:0,
		blur:{
			type:mod.IOS_BLUR, radiusInPixels:1
		}		
	});
	win.add(imgView);	

	var blur = {
		timerId: null,
		apply : function(){
			Ti.API.debug("applyBlur : Taking screenshot");
			var screenshot = list.toImage();
			Ti.API.debug("applyBlur : Cropping screenshot");
			screenshot.imageAsCropped({x:0,y:0, height:250,width:Ti.Platform.displayCaps.platformWidth});
			Ti.API.debug("applyBlur : set screenshot as image to ImageView");
			imgView.image = screenshot;
			Ti.API.debug("applyBlur : set blur so we will update");
			imgView.blur={
				type:mod.BOX_BLUR, radiusInPixels:5
			};	
			Ti.API.debug("applyBlur : Done with Blur");				
		}		
	};
		
	list.addEventListener('scroll',function(f){
		Ti.API.debug("action fired : scroll");
		
		if(blur.timerId!=null){
			Ti.API.debug("Timer already set, returning");
			return;
		}
		
		blur.timerId = setTimeout(function(){
			blur.apply();
			blur.timerId = null;	
		},50);	
			
	});

	list.addEventListener('scrollend',function(f){
		Ti.API.debug("action fired : scrollend");
		
		if(blur.timerId!=null){
			Ti.API.debug("Clearing Interval");
			clearInterval(blur.timerId);
			blur.timerId = null;
		}
		blur.apply();	
	});
 	 		
	win.addEventListener('open',function(f){
		blur.apply();
	});

	win.addEventListener('close',function(f){
		if(blur.timerId!=null){
			clearInterval(blur.timerId);
		}	
	});
		
	return win;
};
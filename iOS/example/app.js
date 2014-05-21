
// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'#fff',tabBarHidden:true, barColor:"#999", title:"Blur Demos"
});

var data =[
	{title:"Basic Blur", hasChild:true, header:"Basic Blur Demos", itemId:-2},
	{title:"Blur Background", hasChild:true, header:"View Demos", itemId:0},
	{title:"Blur Overlay", hasChild:true, itemId:1},
	{title:"Blur & Tinted Overlay", hasChild:true, itemId:2},
	{title:"applyBlurTo From View", hasChild:true, header:"Image Demos", itemId:3},
	{title:"applyBlurTo From Blob", hasChild:true, itemId:4},
	{title:"Overlay applyBlurTo - View", hasChild:true, itemId:5},
	{title:"Overlay applyBlurTo - Image", hasChild:true, itemId:6},
	{title:"iOS Blur", hasChild:true, header:"GPU ImageView Demos", itemId:7},
	{title:"Box Blur", hasChild:true, itemId:8},
	{title:"Gaussian Blur", hasChild:true, itemId:9},
	{title:"Kind of Live Blur on scroll", hasChild:true, header:"Live Blur Demos",itemId:10},
	{title:"Kind of Live Blur", hasChild:true,itemId:11}	
];

var tableView = Ti.UI.createTableView({
	width:Ti.UI.FILL, height:Ti.UI.FILL, data:data	
});
win.add(tableView);

tableView.addEventListener('click',function(e){
	if(e.rowData.itemId===-2){
		tabGroup.activeTab.open(require('basic_blur_view_example').createWindow());
	}
	if(e.rowData.itemId===0){
		tabGroup.activeTab.open(require('overlay_bg_demo').createWindow());
	}
	if(e.rowData.itemId===1){
		tabGroup.activeTab.open(require('overlay_cropped').createWindow());
	}
	if(e.rowData.itemId===2){
		tabGroup.activeTab.open(require('overlay_cropped_tinted').createWindow());
	}
	if(e.rowData.itemId===3){
		tabGroup.activeTab.open(require('image_from_view').createWindow());
	}	
	if(e.rowData.itemId===4){
		tabGroup.activeTab.open(require('image_from_blob').createWindow());
	}
	if(e.rowData.itemId===5){
		tabGroup.activeTab.open(require('image_overlay_view').createWindow());
	}
	if(e.rowData.itemId===6){
		tabGroup.activeTab.open(require('image_overlay_image').createWindow());
	}	
	if(e.rowData.itemId===7){
		tabGroup.activeTab.open(require('GPU_IOS_Blur').createWindow());
	}	
	if(e.rowData.itemId===8){
		tabGroup.activeTab.open(require('GPU_Box_Blur').createWindow());
	}	
	if(e.rowData.itemId===9){
		tabGroup.activeTab.open(require('GPU_Gaussian_Blur').createWindow());
	}		
	if(e.rowData.itemId===10){
		tabGroup.activeTab.open(require('blur_on_scroll').createWindow());
	}	
	if(e.rowData.itemId===11){
		tabGroup.activeTab.open(require('timed_live_blur').createWindow());
	}					
});

var tabGroup = Titanium.UI.createTabGroup();
tabGroup.addTab(Ti.UI.createTab({
	window:win
}));
tabGroup.open();


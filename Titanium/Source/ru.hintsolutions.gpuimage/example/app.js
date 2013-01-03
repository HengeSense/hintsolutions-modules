var gpuimage = require('ti.gpuimage');

//---------------------------------------------//

var win = Ti.UI.createWindow(
	{
		title: 'GPU Image',
		url : ''
	}
);

var cameraView = gpuimage.createCameraView(
	{
		position : 'back'
	}
);
win.add(cameraView);

//---------------------------------------------//

win.open();

//---------------------------------------------//

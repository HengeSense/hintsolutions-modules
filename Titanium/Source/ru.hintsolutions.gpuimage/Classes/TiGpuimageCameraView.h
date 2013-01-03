/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

/*--------------------------------------------------*/

#import "TiUIView.h"

/*--------------------------------------------------*/

#import "TiGpuimageFilterProxy.h"

/*--------------------------------------------------*/

@interface TiGpuimageCameraView : TiUIView
{
@protected
    NSNumber *cameraFrameOrientation;
    NSString *cameraFramePreset;
    NSNumber *cameraPosition;
    GPUImageVideoCamera *cameraDevice;
@protected
    GPUImageCropFilter *cameraCrop;
	GPUImageView *cameraView;
    NSNumber *cameraViewFillMode;
@protected
    TiGpuimageFilterProxy *cameraFilter;
@protected
    NSURL *cameraMovieURL;
    GPUImageMovieWriter *cameraMovie;
}
/*
- (BOOL) isRecording;
- (void) startRecord;
- (void) stopRecord;
*/
- (UIImage*) screenshot;

@end

/*--------------------------------------------------*/

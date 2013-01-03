/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

/*--------------------------------------------------*/

#import "TiGpuimageCameraViewProxy.h"

/*--------------------------------------------------*/

#import "TiGpuimageCameraView.h"
#import "TiUtils.h"

/*--------------------------------------------------*/

@implementation TiGpuimageCameraViewProxy
/*
- (id) isRecording:(id)arg
{
    TiGpuimageCameraView *gpuimage = (TiGpuimageCameraView*)[self view];
    return NUMBOOL([gpuimage isRecording]);
}

- (void) startRecord:(id)arg
{
    TiGpuimageCameraView *gpuimage = (TiGpuimageCameraView*)[self view];
    [gpuimage startRecord];
}

- (void) stopRecord:(id)arg
{
    TiGpuimageCameraView *gpuimage = (TiGpuimageCameraView*)[self view];
    [gpuimage stopRecord];
}
*/
- (id) screenshot:(id)arg
{
    TiGpuimageCameraView *gpuimage = (TiGpuimageCameraView*)[self view];
    return [[[TiBlob alloc] initWithImage:[gpuimage screenshot]] autorelease];
}

@end

/*--------------------------------------------------*/

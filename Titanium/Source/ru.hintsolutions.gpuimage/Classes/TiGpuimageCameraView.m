/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

/*--------------------------------------------------*/

#import "TiGpuimageCameraView.h"

/*--------------------------------------------------*/

#import "TiUtils.h"

/*--------------------------------------------------*/

@implementation TiGpuimageCameraView

- (void) initializeState
{
    cameraFrameOrientation = [[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] retain];
    cameraFramePreset = [[NSString stringWithString:AVCaptureSessionPreset640x480] retain];
    cameraPosition = [[NSNumber numberWithInteger:AVCaptureDevicePositionBack] retain];
    cameraViewFillMode = [[NSNumber numberWithInteger:kGPUImageFillModePreserveAspectRatioAndFill] retain];
    cameraMovieURL = [[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TiGPUImage.m4v"]] retain];

    cameraDevice = [[[[GPUImageVideoCamera alloc] initWithSessionPreset:cameraFramePreset cameraPosition:[cameraPosition integerValue]] autorelease] retain];
    if(cameraDevice != nil)
    {
        [cameraDevice setOutputImageOrientation:[cameraFrameOrientation integerValue]];
        
        cameraCrop = [[[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0, 0, 1, 1)] autorelease];
        if(cameraCrop != nil)
        {
            [cameraDevice addTarget:cameraCrop];
            
            cameraView = [[[[GPUImageView alloc] initWithFrame:[self frame]] autorelease] retain];
            if(cameraView != nil)
            {
                [cameraView setFillMode:[cameraViewFillMode integerValue]];
                [cameraCrop addTarget:cameraView];
                [self addSubview:cameraView];
            }
            else
            {
                [self throwException:@"GPUImageException"
                           subreason:@"CameraView not created"
                            location:CODELOCATION];
            }
        }
        else
        {
            [self throwException:@"GPUImageException"
                       subreason:@"CameraCrop not created"
                        location:CODELOCATION];
        }
        [cameraDevice startCameraCapture];
    }
    else
    {
        [self throwException:@"GPUImageException"
                   subreason:@"CameraDevice not created"
                    location:CODELOCATION];
    }
    [super initializeState];
}

- (void) configurationSet
{
	[super configurationSet];
}

- (void) dealloc
{
	RELEASE_TO_NIL(cameraViewFillMode);
	RELEASE_TO_NIL(cameraPosition);
	RELEASE_TO_NIL(cameraFramePreset);
	RELEASE_TO_NIL(cameraFilter);
	RELEASE_TO_NIL(cameraCrop);
	RELEASE_TO_NIL(cameraView);
	RELEASE_TO_NIL(cameraDevice);
	[super dealloc];
}

- (void) frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    if(cameraView != nil)
    {
        [cameraView setFrame:bounds];
    }
}

- (void) setFrameOrientation_:(id)arg
{
    if([arg isKindOfClass:[NSNumber class]] == YES)
    {
        if([cameraFrameOrientation isEqual:arg] == NO)
        {
            [cameraFrameOrientation release];
            cameraFrameOrientation = [arg retain];
            
            if(cameraFrameOrientation != nil)
            {
                [cameraDevice setOutputImageOrientation:[cameraFrameOrientation integerValue]];
            }
            
            if([[self proxy] _hasListeners:@"changeFrameOrientation"] == YES)
            {
                NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:arg, @"frameOrientation", nil];
                [[self proxy] fireEvent:@"changeFrameOrientation" withObject:event];
            }
        }
    }
    else if([arg isKindOfClass:[NSString class]] == YES)
    {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [self setFrameOrientation_:[formatter numberFromString:arg]];
        [formatter release];
    }
}

- (id) frameOrientation_
{
    return cameraFrameOrientation;
}

- (void) setFramePreset_:(id)arg
{
    if([arg isKindOfClass:[NSString class]] == YES)
    {
        if([cameraFramePreset isEqual:arg] == NO)
        {
            [cameraFramePreset release];
            cameraFramePreset = [arg retain];
            
            if(cameraFramePreset != nil)
            {
                [cameraDevice setCaptureSessionPreset:cameraFramePreset];
            }
            
            if([[self proxy] _hasListeners:@"changeFramePreset"] == YES)
            {
                NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:arg, @"framePreset", nil];
                [[self proxy] fireEvent:@"changeFramePreset" withObject:event];
            }
        }
    }
    else if([arg isKindOfClass:[NSNumber class]] == YES)
    {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [self setFramePreset_:[formatter stringFromNumber:arg]];
        [formatter release];
    }
}

- (id) framePreset_
{
    return cameraFramePreset;
}

- (void) setPosition_:(id)arg
{
    if([arg isKindOfClass:[NSNumber class]] == YES)
    {
        if([cameraPosition isEqual:arg] == NO)
        {
            [cameraPosition release];
            cameraPosition = [arg retain];
            
            if(cameraPosition != nil)
            {
                [cameraDevice rotateCamera];
            }
            
            if([[self proxy] _hasListeners:@"changePosition"] == YES)
            {
                NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:arg, @"position", nil];
                [[self proxy] fireEvent:@"changePosition" withObject:event];
            }
        }
    }
    else if([arg isKindOfClass:[NSNumber class]] == YES)
    {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [self setPosition_:[formatter stringFromNumber:arg]];
        [formatter release];
    }
}

- (id) position_
{
    return cameraPosition;
}

- (void) setFillMode_:(id)arg
{
    if([arg isKindOfClass:[NSNumber class]] == YES)
    {
        if([cameraViewFillMode isEqual:arg] == NO)
        {
            [cameraViewFillMode release];
            cameraViewFillMode = [arg retain];
            
            if(cameraViewFillMode != nil)
            {
                [cameraView setFillMode:[cameraViewFillMode integerValue]];
            }
            
            if([[self proxy] _hasListeners:@"changeFillMode"] == YES)
            {
                NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:arg, @"fillMode", nil];
                [[self proxy] fireEvent:@"changeFillMode" withObject:event];
            }
        }
    }
    else if([arg isKindOfClass:[NSNumber class]] == YES)
    {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [self setFillMode_:[formatter stringFromNumber:arg]];
        [formatter release];
    }
}

- (id) fillMode_
{
    return cameraViewFillMode;
}

- (void) setFilter_:(id)arg
{
    if(cameraMovie == nil)
    {
        if([arg isKindOfClass:[NSNull class]] == YES)
        {
            if(cameraFilter != nil)
            {
                [[cameraFilter output] removeTarget:cameraView];
                [cameraCrop removeTarget:[cameraFilter output]];
                [cameraFilter release];
                cameraFilter = nil;
                
                [cameraCrop addTarget:cameraView];
                
                if([[self proxy] _hasListeners:@"changeFilter"] == YES)
                {
                    NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:arg, @"filter", nil];
                    [[self proxy] fireEvent:@"changeFilter" withObject:event];
                }
            }
        }
        else if([arg isKindOfClass:[TiGpuimageFilterProxy class]] == YES)
        {
            if(cameraFilter != nil)
            {
                [[cameraFilter output] removeTarget:cameraView];
                [cameraCrop removeTarget:[cameraFilter output]];
                [cameraFilter release];
            }
            else
            {
                [cameraCrop removeTarget:cameraView];
            }
            
            cameraFilter = [arg retain];
            
            if(cameraFilter != nil)
            {
                [[cameraFilter output] addTarget:cameraView];
                [cameraCrop addTarget:[cameraFilter output]];
            }
            else
            {
                [cameraCrop addTarget:cameraView];
            }
            
            if([[self proxy] _hasListeners:@"changeFilter"] == YES)
            {
                NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:arg, @"filter", nil];
                [[self proxy] fireEvent:@"changeFilter" withObject:event];
            }
        }
        else
        {
            [self throwException:@"GPUImageException"
                       subreason:[NSString stringWithFormat:@"Unknown class %@", NSStringFromClass([arg class]), nil]
                        location:CODELOCATION];
        }
    }
    else
    {
        [self throwException:@"GPUImageException"
                   subreason:@"Filter setting available when recording"
                    location:CODELOCATION];
    }
}

- (id) filter_
{
    return cameraFilter;
}
/*
- (BOOL) isRecording
{
    return (cameraMovie != nil);
}

- (void) startRecord;
{
    if(cameraMovie == nil)
    {
        if(cameraMovieURL != nil)
        {
            if([[NSFileManager defaultManager] fileExistsAtPath:[cameraMovieURL path]] == YES)
            {
                [[NSFileManager defaultManager] removeItemAtPath:[cameraMovieURL path] error:nil];
            }
        }
        cameraMovie = [[[[GPUImageMovieWriter alloc] initWithMovieURL:cameraMovieURL size:CGSizeMake(480, 640)] autorelease] retain];
        if(cameraMovie != nil)
        {
            if(cameraFilter != nil)
            {
                [[cameraFilter output] addTarget:cameraMovie];
            }
            else
            {
                [cameraCrop addTarget:cameraMovie];
            }
            [cameraDevice setAudioEncodingTarget:cameraMovie];
            [cameraMovie startRecording];
            
            if([[self proxy] _hasListeners:@"startRecord"] == YES)
            {
                [[self proxy] fireEvent:@"startRecord"];
            }
        }
        else
        {
            [self throwException:@"GPUImageException"
                       subreason:@"Bad create MovieWriter"
                        location:CODELOCATION];
        }
    }
    else
    {
        [self throwException:@"GPUImageException"
                   subreason:@"Recording has already begun"
                    location:CODELOCATION];
    }
}
- (void) stopRecord
{
    if(cameraMovie != nil)
    {
        if(cameraFilter != nil)
        {
            [[cameraFilter output] removeTarget:cameraMovie];
        }
        else
        {
            [cameraCrop removeTarget:cameraMovie];
        }
        [cameraDevice setAudioEncodingTarget:nil];
        [cameraMovie finishRecording];
        [cameraMovie release];
        cameraMovie = nil;
        
        if([[self proxy] _hasListeners:@"stopRecord"] == YES)
        {
            [[self proxy] fireEvent:@"stopRecord"];
        }
    }
}
*/
- (UIImage*) screenshot
{
    UIImage *image = nil;
    if(cameraFilter != nil)
    {
        image = [[cameraFilter output] imageFromCurrentlyProcessedOutput];
    }
    else
    {
        image = [cameraCrop imageFromCurrentlyProcessedOutput];
    }
    return image;
}

@end

/*--------------------------------------------------*/

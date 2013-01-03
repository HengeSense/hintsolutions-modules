/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

/*--------------------------------------------------*/

#import "TiGpuimageModule.h"

/*--------------------------------------------------*/

#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiBlob.h"

/*--------------------------------------------------*/

#import "TiGpuimageFilterProxy.h"

/*--------------------------------------------------*/

@implementation TiGpuimageModule

- (id) moduleGUID
{
	return @"6fe96416-b375-4358-ab0e-65510cc1acbe";
}

- (NSString*) moduleId
{
	return @"ti.gpuimage";
}

MAKE_SYSTEM_PROP(FRAME_ORIENTATION_PORTRAIT, UIInterfaceOrientationPortrait);
MAKE_SYSTEM_PROP(FRAME_ORIENTATION_PORTRAIT_UPSIDE_DOWN, UIInterfaceOrientationPortraitUpsideDown);
MAKE_SYSTEM_PROP(FRAME_ORIENTATION_LANDSCAPE_RIGHT, UIInterfaceOrientationLandscapeLeft);
MAKE_SYSTEM_PROP(FRAME_ORIENTATION_LANDSCAPE_LEFT, UIInterfaceOrientationLandscapeRight);

MAKE_SYSTEM_STR(FRAME_PRESET_352_288, AVCaptureSessionPreset352x288);
MAKE_SYSTEM_STR(FRAME_PRESET_640_480, AVCaptureSessionPreset640x480);
MAKE_SYSTEM_STR(FRAME_PRESET_1280_720, AVCaptureSessionPreset1280x720);
MAKE_SYSTEM_STR(FRAME_PRESET_1920_1080, AVCaptureSessionPreset1920x1080);

MAKE_SYSTEM_PROP(POSITION_BACK, AVCaptureDevicePositionBack);
MAKE_SYSTEM_PROP(POSITION_FRONT, AVCaptureDevicePositionFront);

MAKE_SYSTEM_PROP(FILL_MODE_STRETCH, kGPUImageFillModeStretch);
MAKE_SYSTEM_PROP(FILL_MODE_ASPECT_RATIO, kGPUImageFillModePreserveAspectRatio);
MAKE_SYSTEM_PROP(FILL_MODE_ASPECT_RATIO_AND_FILL, kGPUImageFillModePreserveAspectRatioAndFill);

- (id) init
{
    self = [super init];
    if(self != nil)
    {
    }
	return self;
}

- (id) _initWithPageContext:(id<TiEvaluator>)context
{
	return [super _initWithPageContext:context];
}

- (id) _initWithPageContext:(id<TiEvaluator>)context_ args:(NSArray*)args
{
	return [super _initWithPageContext:context_ args:args];
}

- (void) _initWithProperties:(NSDictionary*)properties
{
	[super _initWithProperties:properties];
}

- (void) _destroy
{
	[super _destroy];
}

- (void) dealloc
{
	[super dealloc];
}

- (void) suspend:(id)sender
{
	[super suspend:sender];
}

- (void) resume:(id)sender
{
	[super resume:sender];
}

- (void) resumed:(id)sender
{
	[super resumed:sender];
}

- (void) _configure
{
	[super _configure];
}

- (void) startup
{
	[super startup];
}

- (void) shutdown:(id)sender
{
	[super shutdown:sender];
}

- (void) didReceiveMemoryWarning:(NSNotification*)notification
{
	[super didReceiveMemoryWarning:notification];
}

- (NSString*) getPathToModuleAsset:(NSString*) fileName
{
	NSString *pathComponent = [NSString stringWithFormat:@"modules/%@/%@", [self moduleId], fileName];
	NSString *result = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:pathComponent];
	return result;
}

- (NSString*) getPathToApplicationAsset:(NSString*) fileName
{
	NSString *result = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
	return result;
}

- (TiBlob*) loadImageFromModule:(id)args
{
	ENSURE_SINGLE_ARG(args,NSString);
	NSString *imagePath = [self getPathToModuleAsset:args];
	UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
	if(image == nil)
    {
		return nil;
	}
	TiBlob *result = [[[TiBlob alloc] initWithImage:image] autorelease];
	return result;	
}

- (TiBlob*) loadImageFromApplication:(id)args
{
	ENSURE_SINGLE_ARG(args,NSString);
	NSString *imagePath = [self getPathToApplicationAsset:args];
	UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
	if(image == nil)
    {
		return nil;
	}
	TiBlob *result = [[[TiBlob alloc] initWithImage:image] autorelease];
	return result;	
}

- (id) createColorInverseFilter:(id)args
{
    return [[[TiGpuimageColorInverseFilterProxy alloc] _initWithPageContext:[self executionContext] args:args] autorelease];
}

- (id) createAstigmatismFilter:(id)args
{
    return [[[TiGpuimageAstigmatismFilterProxy alloc] _initWithPageContext:[self executionContext] args:args] autorelease];
}

- (id) createCataractsOneFilter:(id)args
{
    return [[[TiGpuimageCataractsOneFilterProxy alloc] _initWithPageContext:[self executionContext] args:args] autorelease];
}


@end

/*--------------------------------------------------*/

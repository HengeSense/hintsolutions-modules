/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

/*--------------------------------------------------*/

#import "TiModule.h"

/*--------------------------------------------------*/

@interface TiGpuimageModule : TiModule 
{
}

@property(nonatomic, readonly) NSNumber *FRAME_ORIENTATION_PORTRAIT;
@property(nonatomic, readonly) NSNumber *FRAME_ORIENTATION_PORTRAIT_UPSIDE_DOWN;
@property(nonatomic, readonly) NSNumber *FRAME_ORIENTATION_LANDSCAPE_RIGHT;
@property(nonatomic, readonly) NSNumber *FRAME_ORIENTATION_LANDSCAPE_LEFT;

@property(nonatomic, readonly) NSString *FRAME_PRESET_352_288;
@property(nonatomic, readonly) NSString *FRAME_PRESET_640_480;
@property(nonatomic, readonly) NSString *FRAME_PRESET_1280_720;
@property(nonatomic, readonly) NSString *FRAME_PRESET_1920_1080;

@property(nonatomic, readonly) NSNumber *POSITION_BACK;
@property(nonatomic, readonly) NSNumber *POSITION_FRONT;

@property(nonatomic, readonly) NSNumber *FILL_MODE_STRETCH;
@property(nonatomic, readonly) NSNumber *FILL_MODE_ASPECT_RATIO;
@property(nonatomic, readonly) NSNumber *FILL_MODE_ASPECT_RATIO_AND_FILL;

- (id) createColorInverseFilter:(id)args;
- (id) createAstigmatismFilter:(id)args;
- (id) createCataractsOneFilter:(id)args;

@end

/*--------------------------------------------------*/

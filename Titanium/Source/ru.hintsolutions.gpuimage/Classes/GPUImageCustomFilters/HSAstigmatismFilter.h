//
//  HSAstigmatismFilter.h
//  HSAstigmatismFilter
//
//  Created by Rodion Mamin on 15.09.12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import "GPUImageFilterGroup.h"
#import "GPUImageGaussianBlurFilter.h"
#import "HSDistortionFilter.h"

@interface HSAstigmatismFilter : GPUImageFilterGroup
{
    GPUImageGaussianBlurFilter *gaussian;
    HSDistortionFilter *distortion;
}

-(void) setDistortion:(float)value;

@end

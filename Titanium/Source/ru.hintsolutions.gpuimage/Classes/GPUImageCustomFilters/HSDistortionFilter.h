//
//  HSDistortionFilter.h
//  HSDistortionFilter
//
//  Created by Rodion Mamin on 07.09.12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import "GPUImageFilter.h"

@interface HSDistortionFilter : GPUImageFilter
{
    GLint distortion;
}

- (void) setDistortion:(float)value;

@end

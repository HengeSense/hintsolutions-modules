//
//  HSAstigmatismFilter.m
//  HSAstigmatismFilter
//
//  Created by Rodion Mamin on 15.09.12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import "HSAstigmatismFilter.h"

@implementation HSAstigmatismFilter

- (id) init
{
    self = [super init];
    if(self != nil)
    {
        gaussian = [[GPUImageGaussianBlurFilter alloc] init];
        distortion = [[HSDistortionFilter alloc] init];
        
        [self addFilter:gaussian];
        [self addFilter:distortion];
        
        [gaussian addTarget:distortion];
        
        [self setInitialFilters:[NSArray arrayWithObject: gaussian]];
        [self setTerminalFilter:distortion];
        
        [self setDistortion:0.0];
    }
    return self;
}

- (void) dealloc
{
    [gaussian release];
    [distortion release];
    [super dealloc];
}

- (void) setDistortion:(float)value
{
    [gaussian setBlurSize: 0.01+1.5*value];
    [distortion setDistortion: 0.22 * value];
}

@end

//
//  HSDistortionFilter.m
//  HSDistortionFilter
//
//  Created by Rodion Mamin on 07.09.12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import "HSDistortionFilter.h"

NSString *const kHSDistortionFilterShaderString = SHADER_STRING(
    precision mediump float;

    varying vec2 textureCoordinate;

    uniform sampler2D inputImageTexture;
    uniform float distortion;
 
    void main()
    {
        vec2 pos = 2.0 * textureCoordinate - 1.0;
        float r = dot(pos, pos);
        r = 0.5-0.5*distortion*r;
        pos = pos*r+0.5;
        gl_FragColor =  texture2D(inputImageTexture, pos);
    }
);

@implementation HSDistortionFilter

- (id) init
{
    self = [super initWithFragmentShaderFromString:kHSDistortionFilterShaderString];
    if(self != nil)
    {
        distortion = [filterProgram uniformIndex:@"distortion"];
    }
    return self;
}

- (void) setDistortion:(float)value
{
    [self setFloat:value forUniform:distortion program:filterProgram];
}

@end

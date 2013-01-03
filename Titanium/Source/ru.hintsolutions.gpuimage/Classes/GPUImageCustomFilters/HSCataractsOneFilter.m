//
//  HSCataractsOneFilter.m
//  HSCataractsOneFilter
//
//  Created by Rodion Mamin on 07.09.12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import "HSCataractsOneFilter.h"

NSString *const kHSCataractsOneFilterShaderString = SHADER_STRING(
    precision mediump float;

    varying vec2 textureCoordinate;
    uniform sampler2D inputImageTexture;

    uniform float state;

    vec4 proceed();

    float validate(float value)
    {
        if( value > 1.0 )
            return 1.0;
        if( value < 0.0 )
            return 0.0;
        return value;
    }

    vec4 validateVec(vec4 color)
    {
        color.x = validate(color.x);
        color.y = validate(color.y);
        color.z = validate(color.z);
        color.w = 1.0;
        return color;
    }

    void main()
    {
        vec4 color;
        vec4 color1;
        
        float value1 = state;
        float value2 = state;
        
        color = texture2D (inputImageTexture, textureCoordinate);
        color1 = texture2D (inputImageTexture, textureCoordinate+vec2(1.0, 1.0)*0.1*value2);
        
        gl_FragColor    = validateVec(color+value1*color1);
    }
);

@implementation HSCataractsOneFilter

-(id) init
{
    self = [super initWithFragmentShaderFromString:kHSCataractsOneFilterShaderString];
    if(self != nil)
    {
        state = [filterProgram uniformIndex:@"state"];       
    }
    return self;
}

- (void) setState:(float)value
{
    [self setFloat:value forUniform:state program:filterProgram];
}

@end

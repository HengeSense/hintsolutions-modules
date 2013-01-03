/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

/*--------------------------------------------------*/

#import "TiGpuimageFilterProxy.h"

/*--------------------------------------------------*/

#import "TiUtils.h"

/*--------------------------------------------------*/

@implementation TiGpuimageFilterProxy

- (void) _destroy
{
	RELEASE_TO_NIL(output);
    [super _destroy];
}

- (GPUImageOutput<GPUImageInput>*) output
{
    return output;
}

@end

/*--------------------------------------------------*/

@implementation TiGpuimageColorInverseFilterProxy

- (void) _configure
{
	[super _configure];
    
    output = [[[GPUImageColorInvertFilter alloc] init] autorelease];
}

@end

/*--------------------------------------------------*/

@implementation TiGpuimageAstigmatismFilterProxy

- (void) _configure
{
	[super _configure];
    
    age = 0.0f;
    output = [[[HSAstigmatismFilter alloc] init] autorelease];
}

- (void) setAge:(id)arg
{
    age = [TiUtils floatValue:arg];
    [(HSAstigmatismFilter*)output setDistortion:age];
}

- (id) age
{
    return NUMFLOAT(age);
}

@end

/*--------------------------------------------------*/

@implementation TiGpuimageCataractsOneFilterProxy

- (void) _configure
{
	[super _configure];
    
    age = 0.0f;
    output = [[[HSCataractsOneFilter alloc] init] autorelease];
}

- (void) setAge:(id)arg
{
    age = [TiUtils floatValue:arg];
    [(HSCataractsOneFilter*)output setState:age];
}

- (id) age
{
    return NUMFLOAT(age);
}

@end

/*--------------------------------------------------*/

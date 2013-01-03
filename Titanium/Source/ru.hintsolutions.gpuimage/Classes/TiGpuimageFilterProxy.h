/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

/*--------------------------------------------------*/

#import "TiProxy.h"

/*--------------------------------------------------*/

#import "GPUImage.h"
#import "HSAstigmatismFilter.h"
#import "HSCataractsOneFilter.h"

/*--------------------------------------------------*/

@interface TiGpuimageFilterProxy : TiProxy
{
    GPUImageOutput<GPUImageInput> *output;
}

- (GPUImageOutput<GPUImageInput>*) output;

@end

/*--------------------------------------------------*/

@interface TiGpuimageColorInverseFilterProxy : TiGpuimageFilterProxy
@end

/*--------------------------------------------------*/

@interface TiGpuimageAstigmatismFilterProxy : TiGpuimageFilterProxy
{
    float age;
}

- (void) setAge:(id)arg;
- (id) age;

@end

/*--------------------------------------------------*/

@interface TiGpuimageCataractsOneFilterProxy : TiGpuimageFilterProxy
{
    float age;
}

- (void) setAge:(id)arg;
- (id) age;

@end

/*--------------------------------------------------*/

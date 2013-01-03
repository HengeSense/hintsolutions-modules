//
//  HSCataractsOneFilter.m
//  HSCataractsOneFilter
//
//  Created by Rodion Mamin on 07.09.12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImageFilter.h"

@interface HSCataractsOneFilter : GPUImageFilter
{
    GLint state;   
}

- (void) setState:(float)value;

@end

/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */

#import <CoreData/CoreData.h>

#import "TiModule.h"
#import "StackMob.h"

@interface RuHintsolutionsStackmobModule : TiModule 
{
    SMClient* mClient;
}

- (id) connect:(id)args;
- (void) disconnect:(id)args;
- (void) reguestQuery:(id)args;
- (void) reguestCustomCode:(id)args;

@end

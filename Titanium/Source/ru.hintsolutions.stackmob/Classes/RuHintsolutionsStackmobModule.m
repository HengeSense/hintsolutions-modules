/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "RuHintsolutionsStackmobModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation RuHintsolutionsStackmobModule

- (id) moduleGUID
{
	return @"e5e006bd-fe48-42c4-9f3d-3b6f5a367e9b";
}

- (NSString*) moduleId
{
	return @"ru.hintsolutions.stackmob";
}

- (void) startup
{
	[super startup];
}

- (void) shutdown:(id)sender
{
    [self disconnect:nil];
	[super shutdown:sender];
}

- (id) connect:(id)args
{
    if(mClient == nil)
    {
        if([args isKindOfClass:[NSArray class]] == YES)
        {
            id arg_0 = [args objectAtIndex:0];
            if([arg_0 isKindOfClass:[NSDictionary class]] == YES)
            {
                NSDictionary* dict = (NSDictionary*)arg_0;
                mClient = [[SMClient alloc] initWithAPIVersion:[TiUtils stringValue:@"version"
                                                                         properties:dict
                                                                                def:@"0"]
                                                     publicKey:[TiUtils stringValue:@"publicKey"
                                                                         properties:dict
                                                                                def:nil]];
                if(mClient == nil)
                {
                    TiLogMessage(@"ru.hintsolution.stckmob:connect failure create client");
                }
            }
            else
            {
                TiLogMessage(@"ru.hintsolution.stckmob:connect invalid input args");
            }
        }
        else
        {
            TiLogMessage(@"ru.hintsolution.stckmob:connect invalid input args");
        }
    }
	return [NSNumber numberWithBool:(mClient != nil)];
}

- (void) disconnect:(id)args
{
    if(mClient == nil)
    {
        [mClient release];
        mClient = nil;
    }
}


- (void) reguestQuery:(id)args
{
    if([args isKindOfClass:[NSArray class]] == NO)
    {
        TiLogMessage(@"ru.hintsolution.stckmob:reguestQuery invalid input args");
        return;
    }
    id arg_0 = [args objectAtIndex:0];
    if([arg_0 isKindOfClass:[NSDictionary class]] == NO)
    {
        TiLogMessage(@"ru.hintsolution.stckmob:reguestQuery invalid input args");
        return;
    }
    NSDictionary* dict = (NSDictionary*)arg_0;
    NSString* schema = [TiUtils stringValue:@"schema" properties:dict def:nil];
    if(schema != nil)
    {
        SMQuery *query = [[SMQuery alloc] initWithSchema:schema];
        if(query != nil)
        {
            id headers = [dict objectForKey:@"headers"];
            if([headers isKindOfClass:[NSDictionary class]] == YES)
            {
                NSMutableDictionary* dictHeaders = [NSMutableDictionary dictionary];
                [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
                 {
                     [dictHeaders setObject:[TiUtils stringValue:key]
                                     forKey:[TiUtils stringValue:obj]];
                     *stop = NO;
                 }];
                [query setRequestHeaders:dictHeaders];
            }
            id params = [dict objectForKey:@"params"];
            if([params isKindOfClass:[NSDictionary class]] == YES)
            {
                NSMutableDictionary* dictParams = [NSMutableDictionary dictionary];
                [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
                 {
                     [dictParams setObject:[TiUtils stringValue:key]
                                     forKey:[TiUtils stringValue:obj]];
                     *stop = NO;
                 }];
                [query setRequestParameters:dictParams];
            }
            id sorting = [dict objectForKey:@"sorting"];
            if([sorting isKindOfClass:[NSDictionary class]] == YES)
            {
                [query orderByField:[TiUtils stringValue:@"field"
                                              properties:sorting
                                                     def:[NSString stringWithFormat:@"%@_id", schema]]
                          ascending:[TiUtils boolValue:@"asc"
                                            properties:sorting
                                                   def:YES]];
            }
            id padding = [dict objectForKey:@"padding"];
            if([padding isKindOfClass:[NSDictionary class]] == YES)
            {
                [query fromIndex:[TiUtils intValue:@"from"
                                        properties:padding
                                               def:0]
                         toIndex:[TiUtils intValue:@"to"
                                        properties:padding
                                               def:100]];
            }
            id limit = [dict objectForKey:@"limit"];
            if([limit isKindOfClass:[NSDictionary class]] == YES)
            {
                [query limit:[TiUtils intValue:@"count"
                                    properties:limit
                                           def:0]];
            }
            SMDataStore* dataStore = [[SMClient defaultClient] dataStore];
            if(dataStore != nil)
            {
                [dataStore performQuery:query
                              onSuccess:^(NSArray *results) {
                                  id success = [dict objectForKey:@"success"];
                                  if([success isKindOfClass:[KrollCallback class]] == YES)
                                  {
                                      [success call:[NSArray arrayWithObject:results]
                                         thisObject:self];
                                  }
                              }
                              onFailure:^(NSError *error) {
                                  id failure = [dict objectForKey:@"failure"];
                                  if([failure isKindOfClass:[KrollCallback class]] == YES)
                                  {
                                      NSDictionary* errorObject = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [error domain], @"domain",
                                                                   [NSNumber numberWithInteger:[error code]], @"code",
                                                                   [error localizedDescription], @"description", nil];
                                      [failure call:[NSArray arrayWithObject:errorObject]
                                         thisObject:self];
                                  }
                              }];
            }
            else
            {
                TiLogMessage(@"ru.hintsolution.stckmob:reguestQuery failure data store");
            }
        }
        else
        {
            TiLogMessage(@"ru.hintsolution.stckmob:reguestQuery failure create query");
        }
    }
    else
    {
        TiLogMessage(@"ru.hintsolution.stckmob:reguestQuery unknown shema");
    }
}

- (void) reguestCustomCode:(id)args
{
    if([args isKindOfClass:[NSArray class]] == NO)
    {
        TiLogMessage(@"ru.hintsolution.stckmob:reguestCustomCode invalid input args");
        return;
    }
    id arg_0 = [args objectAtIndex:0];
    if([arg_0 isKindOfClass:[NSDictionary class]] == NO)
    {
        TiLogMessage(@"ru.hintsolution.stckmob:reguestCustomCode invalid input args");
        return;
    }
    NSDictionary* dict = (NSDictionary*)arg_0;
    NSString* method = [TiUtils stringValue:@"method"
                                 properties:dict
                                        def:nil];
    NSString* verb = [TiUtils stringValue:@"verb"
                               properties:dict
                                      def:@"GET"];
    if(method != nil)
    {
        SMCustomCodeRequest *query = nil;
        if([verb isEqualToString:@"POST"] == YES)
        {
            query = [[SMCustomCodeRequest alloc] initPostRequestWithMethod:method
                                                                      body:[dict objectForKey:@"body"]];
        }
        else if([verb isEqualToString:@"PUT"] == YES)
        {
            query = [[SMCustomCodeRequest alloc] initPutRequestWithMethod:method
                                                                     body:[dict objectForKey:@"body"]];
        }
        else if([verb isEqualToString:@"GET"] == YES)
        {
            query = [[SMCustomCodeRequest alloc] initGetRequestWithMethod:method];
        }
        else if([verb isEqualToString:@"DELETE"] == YES)
        {
            query = [[SMCustomCodeRequest alloc] initDeleteRequestWithMethod:method];
        }
        if(query != nil)
        {
            id params = [dict objectForKey:@"params"];
            if([params isKindOfClass:[NSDictionary class]] == YES)
            {
                [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
                 {
                     [query addQueryStringParameterWhere:[TiUtils stringValue:key]
                                                  equals:[TiUtils stringValue:obj]];
                     *stop = NO;
                 }];
            }
            SMDataStore* dataStore = [[SMClient defaultClient] dataStore];
            if(dataStore != nil)
            {
                [dataStore performCustomCodeRequest:query
                                          onSuccess:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                              id success = [dict objectForKey:@"success"];
                                              if([success isKindOfClass:[KrollCallback class]] == YES)
                                              {
                                                  [success call:[NSArray arrayWithObject:JSON]
                                                     thisObject:self];
                                              }
                                          }
                                          onFailure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                              id failure = [dict objectForKey:@"failure"];
                                              if([failure isKindOfClass:[KrollCallback class]] == YES)
                                              {
                                                  NSDictionary* errorObject = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                               [error domain], @"domain",
                                                                               [NSNumber numberWithInteger:[error code]], @"code",
                                                                               [error localizedDescription], @"description", nil];
                                                  [failure call:[NSArray arrayWithObject:errorObject]
                                                     thisObject:self];
                                              }
                                          }];
            }
            else
            {
                TiLogMessage(@"ru.hintsolution.stckmob:reguestCustomCode failure data store");
            }
        }
        else
        {
            TiLogMessage(@"ru.hintsolution.stckmob:reguestCustomCode failure create query");
        }
    }
    else
    {
        TiLogMessage(@"ru.hintsolution.stckmob:reguestCustomCode unknown shema");
    }
}

@end

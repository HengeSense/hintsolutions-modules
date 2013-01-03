/*--------------------------------------------------*/

#import "ItsBeta.h"
#import "RestAPI.h"

/*--------------------------------------------------*/

NSString* const ItsBetaErrorDomain = @"ItsBetaErrorDomain";

/*--------------------------------------------------*/

@interface ItsBeta (Private)

- (NSError*) errorByStatus:(NSString*)byStatus
             byDescription:(NSString*)byDescription
          byAdditionalInfo:(NSString*)byAdditionalInfo;

- (NSError*) errorByDescription:(NSString*)byDescription;

@end

/*--------------------------------------------------*/

@implementation ItsBeta (Private)

- (NSError*) errorByStatus:(NSString*)byStatus
             byDescription:(NSString*)byDescription
          byAdditionalInfo:(NSString*)byAdditionalInfo
{
    return [NSError errorWithDomain:ItsBetaErrorDomain
                               code:ItsBetaErrorResponse
                           userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ - %@ '%@'", byStatus, byDescription, byAdditionalInfo] forKey:NSLocalizedDescriptionKey]];
}

- (NSError*) errorByDescription:(NSString*)byDescription
{
    return [NSError errorWithDomain:ItsBetaErrorDomain
                               code:ItsBetaErrorInternal
                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                     byDescription, NSLocalizedDescriptionKey,
                                     nil]];
}

@end

/*--------------------------------------------------*/

@implementation ItsBeta

@synthesize serviceURL = mServiceURL;
@synthesize accessToken = mAccessToken;

+ (ItsBeta*) sharedItsBeta
{
    if(sharedItsBeta == nil)
    {
        @synchronized(self)
        {
            if(sharedItsBeta == nil)
            {
                sharedItsBeta = [[self alloc] init];
            }
        }
    }
    return sharedItsBeta;
}

- (id) init
{
    self = [super init];
    if(self != nil)
    {
    }
    return self;
}

- (void) dealloc
{
    [mAccessToken release];
    [mServiceURL release];
    [super dealloc];
}

- (void) requestAllCategories:(ItsBetaCallbackCategories)callback
{
    [RestAPIConnection connectionWithMethod:@"GET"
                                        url:[NSString stringWithFormat:@"%@/info/categories.json", mServiceURL]
                                      query:[NSDictionary dictionaryWithObjectsAndKeys:
                                             mAccessToken, @"access_token",
                                             nil]
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        id responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil)
                                        {
                                            if([responseJSON isKindOfClass:[NSArray class]] == YES)
                                            {
                                                ItsBetaCategories* result = [ItsBetaCategories categories];
                                                if(result != nil)
                                                {
                                                    NSArray* categories = (NSArray*)responseJSON;
                                                    for(NSDictionary* itemCategory in categories)
                                                    {
                                                        ItsBetaCategory* resultCategory = [ItsBetaCategory categoryWithID:[itemCategory objectForKey:@"id"]
                                                                                                                     name:[itemCategory objectForKey:@"name"]
                                                                                                                    title:[itemCategory objectForKey:@"title"]];
                                                        if(resultCategory != nil)
                                                        {
                                                            [result addCategory:resultCategory];
                                                        }
                                                    }
                                                    callback(result, nil);
                                                }
                                                else
                                                {
                                                    responseError = [self errorByDescription:@"Out of memory"];
                                                }
                                            }
                                            else if([responseJSON isKindOfClass:[NSDictionary class]] == YES)
                                            {
                                                responseError = [self errorByStatus:[responseJSON objectForKey:@"error"]
                                                                      byDescription:[responseJSON objectForKey:@"description"]
                                                                   byAdditionalInfo:[responseJSON objectForKey:@"additional_info"]];
                                            }
                                        }
                                        if(responseError != nil)
                                        {
                                            callback(nil, responseError);
                                        }
                                    }
                                    failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(nil, error);
                                    }];
}

- (void) requestProjectsByCategory:(ItsBetaCategory*)byCategory
                          callback:(ItsBetaCallbackProjects)callback
{
    [RestAPIConnection connectionWithMethod:@"GET"
                                        url:[NSString stringWithFormat:@"%@/info/projects.json", mServiceURL]
                                      query:[NSDictionary dictionaryWithObjectsAndKeys:
                                             mAccessToken, @"access_token",
                                             [byCategory ID], @"category_id",
                                             nil]
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        id responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil)
                                        {
                                            if([responseJSON isKindOfClass:[NSArray class]] == YES)
                                            {
                                                ItsBetaProjects* result = [ItsBetaProjects projects];
                                                if(result != nil)
                                                {
                                                    NSArray* projects = (NSArray*)responseJSON;
                                                    for(NSDictionary* itemProject in projects)
                                                    {
                                                        ItsBetaProject* resultProject = [ItsBetaProject projectWithID:[itemProject objectForKey:@"id"]
                                                                                                           name:[itemProject objectForKey:@"name"]
                                                                                                          title:[itemProject objectForKey:@"title"]
                                                                                                       category:byCategory];
                                                        if(resultProject != nil)
                                                        {
                                                            [result addProject:resultProject];
                                                        }
                                                    }
                                                    callback(result, nil);
                                                }
                                                else
                                                {
                                                    responseError = [self errorByDescription:@"Out of memory"];
                                                }
                                            }
                                            else if([responseJSON isKindOfClass:[NSDictionary class]] == YES)
                                            {
                                                responseError = [self errorByStatus:[responseJSON objectForKey:@"error"]
                                                                      byDescription:[responseJSON objectForKey:@"description"]
                                                                   byAdditionalInfo:[responseJSON objectForKey:@"additional_info"]];
                                            }
                                        }
                                        if(responseError != nil)
                                        {
                                            callback(nil, responseError);
                                        }
                                    }
                                    failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(nil, error);
                                    }];
}

- (void) requestParamsByProject:(ItsBetaProject*)byProject
                       callback:(ItsBetaCallbackParams)callback
{
    [RestAPIConnection connectionWithMethod:@"GET"
                                        url:[NSString stringWithFormat:@"%@/info/apidef.json", mServiceURL]
                                      query:[NSDictionary dictionaryWithObjectsAndKeys:
                                             mAccessToken, @"access_token",
                                             [byProject ID], @"project_id",
                                             nil]
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        id responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil)
                                        {
                                            NSString* error = [responseJSON objectForKey:@"error"];
                                            if(error == nil)
                                            {
                                                ItsBetaParams* result = [ItsBetaParams paramsWithID:[responseJSON objectForKey:@"id"]
                                                                                               keys:[responseJSON objectForKey:@"params"]];
                                                if(result != nil)
                                                {
                                                    callback(result, nil);
                                                }
                                                else
                                                {
                                                    responseError = [self errorByDescription:@"Out of memory"];
                                                }
                                            }
                                            else
                                            {
                                                responseError = [self errorByStatus:error
                                                                      byDescription:[responseJSON objectForKey:@"description"]
                                                                   byAdditionalInfo:[responseJSON objectForKey:@"additional_info"]];
                                            }
                                        }
                                        if(responseError != nil)
                                        {
                                            callback(nil, responseError);
                                        }
                                    }
                                    failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(nil, error);
                                    }];
}

- (void) requestBadgesByProject:(ItsBetaProject*)byProject
                       callback:(ItsBetaCallbackBadges)callback
{
    [RestAPIConnection connectionWithMethod:@"GET"
                                        url:[NSString stringWithFormat:@"%@/info/badges.json", mServiceURL]
                                      query:[NSDictionary dictionaryWithObjectsAndKeys:
                                             mAccessToken, @"access_token",
                                             [byProject ID], @"project_id",
                                             nil]
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        id responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil)
                                        {
                                            if([responseJSON isKindOfClass:[NSArray class]] == YES)
                                            {
                                                ItsBetaBadges* result = [ItsBetaBadges badges];
                                                if(result != nil)
                                                {
                                                    NSArray* badges = (NSArray*)responseJSON;
                                                    for(NSDictionary* itemBadge in badges)
                                                    {
                                                        ItsBetaBadge* resultBadge = [ItsBetaBadge badgeWithID:[itemBadge objectForKey:@"id"]
                                                                                                         name:[itemBadge objectForKey:@"name"]
                                                                                                        title:[itemBadge objectForKey:@"title"]
                                                                                                  description:[itemBadge objectForKey:@"description"]
                                                                                                     imageURL:[itemBadge objectForKey:@"image"]
                                                                                                      project:byProject];
                                                        if(resultBadge != nil)
                                                        {
                                                            [result addBadge:resultBadge];
                                                        }
                                                    }
                                                    callback(result, nil);
                                                }
                                                else
                                                {
                                                    responseError = [self errorByDescription:@"Out of memory"];
                                                }
                                            }
                                            else if([responseJSON isKindOfClass:[NSDictionary class]] == YES)
                                            {
                                                responseError = [self errorByStatus:[responseJSON objectForKey:@"error"]
                                                                      byDescription:[responseJSON objectForKey:@"description"]
                                                                   byAdditionalInfo:[responseJSON objectForKey:@"additional_info"]];
                                            }
                                        }
                                        if(responseError != nil)
                                        {
                                            callback(nil, responseError);
                                        }
                                    }
                                    failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(nil, error);
                                    }];
}

- (void) requestAchievementsByUser:(ItsBetaUser*)byUser
                        byCategory:(ItsBetaCategory*)byCategory
                         byProject:(ItsBetaProject*)byProject
                          byBadges:(ItsBetaBadges*)byBadges
                          callback:(ItsBetaCallbackAchievements)callback
{
    [self requestAchievementsByUser:byUser
                       byCategories:[ItsBetaCategories categoriesWithCategory:byCategory]
                         byProjects:[ItsBetaProjects projectsWithProject:byProject]
                           byBadges:byBadges
                           callback:callback];
}

- (void) requestAchievementsByUser:(ItsBetaUser*)byUser
                        byCategory:(ItsBetaCategory*)byCategory
                        byProjects:(ItsBetaProjects*)byProjects
                          byBadges:(ItsBetaBadges*)byBadges
                          callback:(ItsBetaCallbackAchievements)callback
{
    [self requestAchievementsByUser:byUser
                       byCategories:[ItsBetaCategories categoriesWithCategory:byCategory]
                         byProjects:byProjects
                           byBadges:byBadges
                           callback:callback];
}

- (void) requestAchievementsByUser:(ItsBetaUser*)byUser
                      byCategories:(ItsBetaCategories*)byCategories
                        byProjects:(ItsBetaProjects*)byProjects
                          byBadges:(ItsBetaBadges*)byBadges
                          callback:(ItsBetaCallbackAchievements)callback
{
    NSMutableDictionary* query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  mAccessToken, @"access_token",
                                  [byUser typeAsString], @"user_type",
                                  [byUser ID], @"user_id",
                                  nil];
    NSMutableArray* categoriesID = [NSMutableArray arrayWithCapacity:32];
    if(categoriesID != nil)
    {
        for(ItsBetaCategory* category in [byCategories list])
        {
            [categoriesID addObject:[category ID]];
        }
        NSString* categories = [categoriesID componentsJoinedByString:@","];
        if(categories != nil)
        {
            [query setObject:categories
                      forKey:@"categories"];
        }
    }
    NSMutableArray* projectsID = [NSMutableArray arrayWithCapacity:32];
    if(projectsID != nil)
    {
        for(ItsBetaProject* project in [byProjects list])
        {
            [projectsID addObject:[project ID]];
        }
        NSString* projects = [projectsID componentsJoinedByString:@","];
        if(projects != nil)
        {
            [query setObject:projects
                      forKey:@"projects"];
        }
    }
    [RestAPIConnection connectionWithMethod:@"GET"
                                        url:[NSString stringWithFormat:@"%@/players/retrieve.json", mServiceURL]
                                      query:query
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        NSDictionary* responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil)
                                        {
                                            if([responseJSON isKindOfClass:[NSArray class]] == YES)
                                            {
                                                ItsBetaAchievements* result = [ItsBetaAchievements achievements];
                                                if(result != nil)
                                                {
                                                    NSArray* categories = (NSArray*)responseJSON;
                                                    for(NSDictionary* itemCategory in categories)
                                                    {
                                                        NSArray* projects = [itemCategory objectForKey:@"projects"];
                                                        for(NSDictionary* itemProject in projects)
                                                        {
                                                            NSArray* achievements = [itemProject objectForKey:@"achievements"];
                                                            for(NSDictionary* itemAchievement in achievements)
                                                            {
                                                                NSString* badgeID = [itemAchievement objectForKey:@"badge_id"];
                                                                ItsBetaBadge* resultBadge = [byBadges badgeAtID:badgeID];
                                                                ItsBetaAchievement* resultAchievement = [ItsBetaAchievement achievementWithID:[itemAchievement objectForKey:@"id"]
                                                                                                                                      badgeID:badgeID
                                                                                                                                      details:[itemAchievement objectForKey:@"details"]
                                                                                                                                    activated:[[itemAchievement objectForKey:@"activated"] boolValue]
                                                                                                                                         user:byUser
                                                                                                                                        badge:resultBadge];
                                                                if(resultAchievement != nil)
                                                                {
                                                                    [result addAchievement:resultAchievement];
                                                                }
                                                            }
                                                        }
                                                    }
                                                    callback(result, nil);
                                                }
                                                else
                                                {
                                                    responseError = [self errorByDescription:@"Out of memory"];
                                                }
                                            }
                                            else if([responseJSON isKindOfClass:[NSDictionary class]] == YES)
                                            {
                                                responseError = [self errorByStatus:[responseJSON objectForKey:@"error"]
                                                                      byDescription:[responseJSON objectForKey:@"description"]
                                                                   byAdditionalInfo:[responseJSON objectForKey:@"additional_info"]];
                                            }
                                        }
                                        if(responseError != nil)
                                        {
                                            callback(nil, responseError);
                                        }
                                    }
                                    failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(nil, error);
                                    }];
}

- (void) requestCreateAchievementByBadge:(ItsBetaBadge*)byBadge
                                byParams:(NSDictionary*)byParams
                          byExternalCode:(NSString*)byExternalCode
                                callback:(ItsBetaCallbackCreateAchievement)callback
{
    NSMutableDictionary* query = [NSMutableDictionary dictionaryWithObject:mAccessToken forKey:@"access_token"];
    if(byExternalCode != nil)
    {
        [query setObject:byExternalCode
                  forKey:@"external_code"];
    }
    [byParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         [query setObject:obj
                   forKey:key];
         *stop = NO;
     }];
    [RestAPIConnection connectionWithMethod:@"POST"
                                        url:[NSString stringWithFormat:@"%@/achievements/post/%@/%@.json", mServiceURL, [[byBadge project] name], [byBadge name]]
                                      query:query
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        NSDictionary* responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil)
                                        {
                                            NSString* error = [responseJSON objectForKey:@"error"];
                                            if(error == nil)
                                            {
                                                callback([responseJSON objectForKey:@"activation_code"], nil);
                                            }
                                            else
                                            {
                                                responseError = [self errorByStatus:error
                                                                      byDescription:[responseJSON objectForKey:@"description"]
                                                                   byAdditionalInfo:[responseJSON objectForKey:@"additional_info"]];
                                            }
                                        }
                                        if(responseError != nil)
                                        {
                                            callback(nil, responseError);
                                        }
                                    }
                                    failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(nil, error);
                                    }];
}

- (void) requestActivateAchievementByUser:(ItsBetaUser*)byUser
                                  byBadge:(ItsBetaBadge*)byBadge
                           byActivateCode:(NSString*)byActivateCode
                           byExternalCode:(NSString*)byExternalCode
                                 callback:(ItsBetaCallbackActivateAchievement)callback
{
    NSString* url = nil;
    NSMutableDictionary* query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  mAccessToken, @"access_token",
                                  [byUser typeAsString], @"user_type",
                                  [byUser ID], @"user_id",
                                  nil];
    if(byExternalCode == nil)
    {
        url = [NSString stringWithFormat:@"%@/achievements/activatebycode.json", mServiceURL];
        [query setObject:byActivateCode
                  forKey:@"activation_code"];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@/achievements/activateext/%@/%@.json", mServiceURL, [[byBadge project] name], [byBadge name]];
        [query setObject:byExternalCode
                  forKey:@"external_code"];
    }
    [RestAPIConnection connectionWithMethod:@"POST"
                                        url:url
                                      query:query
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        NSDictionary* responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil)
                                        {
                                            NSString* error = [responseJSON objectForKey:@"error"];
                                            if(error == nil)
                                            {
                                                ItsBetaAchievement* result = [ItsBetaAchievement achievementWithID:[responseJSON objectForKey:@"id"]
                                                                                                           badgeID:[responseJSON objectForKey:@"badge_id"]
                                                                                                           details:[responseJSON objectForKey:@"details"]
                                                                                                         activated:YES
                                                                                                              user:byUser
                                                                                                             badge:byBadge];
                                                if(result != nil)
                                                {
                                                    callback(result, nil);
                                                }
                                                else
                                                {
                                                    responseError = [self errorByDescription:@"Out of memory"];
                                                }
                                            }
                                            else
                                            {
                                                responseError = [self errorByStatus:error
                                                                      byDescription:[responseJSON objectForKey:@"description"]
                                                                   byAdditionalInfo:[responseJSON objectForKey:@"additional_info"]];
                                            }
                                        }
                                        if(responseError != nil)
                                        {
                                            callback(nil, responseError);
                                        }
                                    }
                                    failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(nil, error);
                                    }];
}

@end

/*--------------------------------------------------*/

ItsBeta * sharedItsBeta = nil;

/*--------------------------------------------------*/
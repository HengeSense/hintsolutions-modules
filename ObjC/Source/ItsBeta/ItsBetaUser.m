/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaUser

@synthesize type = mType;
@synthesize ID = mID;

- (NSString*) typeAsString
{
    switch(mType)
    {
        case ItsBetaUserTypeFacebook: return @"fb";
    }
    return @"";
}

+ (ItsBetaUser*) userWithType:(ItsBetaUserType)type
{
    return [[[self alloc] initWithType:type] autorelease];
}

- (id) initWithType:(ItsBetaUserType)type
{
    self = [super init];
    if(self != nil)
    {
        mType = type;
    }
    return self;
}

- (void) dealloc
{
    [mID release];
    [super dealloc];
}

- (BOOL) isLogin
{
    return [[FBSession activeSession] isOpen];
}

- (void) login:(ItsBetaCallbackLogin)callback
{
    switch(mType)
    {
        case ItsBetaUserTypeFacebook:
            if([[FBSession activeSession] isOpen] == NO)
            {
                [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObjects:@"publish_stream", @"publish_actions", nil]
                                                   defaultAudience:FBSessionDefaultAudienceOnlyMe
                                                      allowLoginUI:YES
                                                 completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                                     switch(state)
                                                     {
                                                         case FBSessionStateOpen:
                                                         case FBSessionStateOpenTokenExtended:
                                                             [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary< FBGraphUser > *user, NSError *error) {
                                                                 if(error == nil)
                                                                 {
                                                                     mID = [[user id] retain];
                                                                     callback(nil);
                                                                 }
                                                                 else
                                                                 {
                                                                     callback(error);
                                                                 }
                                                             }];
                                                             break;
                                                         case FBSessionStateClosedLoginFailed:
                                                             [[FBSession activeSession] closeAndClearTokenInformation];
                                                             error = [NSError errorWithDomain:ItsBetaErrorDomain
                                                                                         code:ItsBetaErrorFacebookAuth
                                                                                     userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                               @"Fail open facecebook session", NSLocalizedDescriptionKey,
                                                                                               nil]];
                                                             break;
                                                         case FBSessionStateClosed:
                                                             break;
                                                         default:
                                                             error = [NSError errorWithDomain:ItsBetaErrorDomain
                                                                                         code:ItsBetaErrorFacebookAuth
                                                                                     userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                               @"Unknown state facecebook session", NSLocalizedDescriptionKey,
                                                                                               nil]];
                                                             break;
                                                     }
                                                     if(error != nil)
                                                     {
                                                         callback(error);
                                                     }
                                                 }];
            }
            break;
    }
}

- (void) logout:(ItsBetaCallbackLogout)callback
{
    switch(mType)
    {
        case ItsBetaUserTypeFacebook:
            if([FBSession activeSession] != nil)
            {
                [[FBSession activeSession] closeAndClearTokenInformation];
            }
            break;
    }
    if(callback != nil)
    {
        callback(nil);
    }
}

+ (BOOL) handleOpenURL:(NSURL*)url
{
    return [[FBSession activeSession] handleOpenURL:url];
}

@end

/*--------------------------------------------------*/

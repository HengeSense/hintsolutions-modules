/*--------------------------------------------------*/

#import "YandexMoney.h"

/*--------------------------------------------------*/

@implementation YandexMoneyPayment

@synthesize patternID = mPatternID;
@synthesize status = mStatus;
@synthesize error = mError;

+ (YandexMoneyPayment*) paymentWithPatternID:(NSString*)patternID
{
    return [[[self alloc] initWithPatternID:patternID] autorelease];
}

- (id) initWithPatternID:(NSString*)patternID
{
    self = [super init];
    if(self != nil)
    {
        mPatternID = [patternID retain];
    }
    return self;
}

- (void) dealloc
{
    [mPatternID release];
    [mStatus release];
    [mError release];
    [super dealloc];
}

- (void) setStatusWithJSON:(id)status
{
    if([status isKindOfClass:[NSString class]] == YES)
    {
        if([mStatus isEqual:status] == NO)
        {
            [mStatus release];
            mStatus = [status retain];
        }
    }
    else
    {
        [mStatus release];
        mStatus = nil;
    }
}

- (BOOL) isStatusSuccess
{
    return [mStatus isEqualToString:@"success"];
}

- (BOOL) isStatusRefused
{
    return [mStatus isEqualToString:@"refused"];
}

@end

/*--------------------------------------------------*/
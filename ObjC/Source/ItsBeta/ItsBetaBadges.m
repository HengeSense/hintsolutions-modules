/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaBadges

@synthesize list = mList;

+ (ItsBetaBadges*) badges
{
    return [[[self alloc] init] autorelease];
}

- (id) init
{
    self = [super init];
    if(self != nil)
    {
        mList = [[NSMutableArray arrayWithCapacity:32] retain];
    }
    return self;
}

- (void) dealloc
{
    [mList release];
    [super dealloc];
}

- (void) addBadge:(ItsBetaBadge*)badge
{
    [mList addObject:badge];
}
- (void) removeBadge:(ItsBetaBadge*)badge
{
    [mList removeObject:badge];
}

- (void) removeBadgeByID:(NSString*)badgeID
{
    NSUInteger index = 0;
    for(ItsBetaBadge* badge in mList)
    {
        if([[badge ID] isEqualToString:badgeID] == YES)
        {
            [mList removeObjectAtIndex:index];
        }
        index++;
    }
}

- (ItsBetaBadge*) badgeAtID:(NSString*)badgeID
{
    for(ItsBetaBadge* badge in mList)
    {
        if([[badge ID] isEqualToString:badgeID] == YES)
        {
            return badge;
        }
    }
    return nil;
}

- (ItsBetaBadge*) badgeAt:(NSUInteger)index
{
    return [mList objectAtIndex:index];
}

@end

/*--------------------------------------------------*/
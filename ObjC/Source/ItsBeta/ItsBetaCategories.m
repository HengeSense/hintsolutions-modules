/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaCategories

@synthesize list = mList;

+ (ItsBetaCategories*) categories
{
    return [[[self alloc] init] autorelease];
}

+ (ItsBetaCategories*) categoriesWithCategory:(ItsBetaCategory*)category
{
    return [[[self alloc] initWithCategory:category] autorelease];
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

- (id) initWithCategory:(ItsBetaCategory*)category
{
    self = [super init];
    if(self != nil)
    {
        mList = [[NSMutableArray arrayWithObject:category] retain];
    }
    return self;
}

- (void) dealloc
{
    [mList release];
    [super dealloc];
}

- (void) addCategory:(ItsBetaCategory*)category
{
    [mList addObject:category];
}

- (void) removeCategory:(ItsBetaCategory*)category
{
    [mList removeObject:category];
}

- (void) removeCategoryByID:(NSString*)categoryID
{
    NSUInteger index = 0;
    for(ItsBetaCategory* category in mList)
    {
        if([[category ID] isEqualToString:categoryID] == YES)
        {
            [mList removeObjectAtIndex:index];
        }
        index++;
    }
}

- (ItsBetaCategory*) categoryAtID:(NSString*)categoryID
{
    for(ItsBetaCategory* category in mList)
    {
        if([[category ID] isEqualToString:categoryID] == YES)
        {
            return category;
        }
    }
    return nil;
}

- (ItsBetaCategory*) categoryAt:(NSUInteger)index
{
    return [mList objectAtIndex:index];
}

@end

/*--------------------------------------------------*/

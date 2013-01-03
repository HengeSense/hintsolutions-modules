/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaCategory

@synthesize ID = mID;
@synthesize name = mName;
@synthesize title = mTitle;

+ (ItsBetaCategory*) categoryWithID:(NSString*)ID
                               name:(NSString*)name
                              title:(NSString*)title
{
    return [[[self alloc] initWithID:ID
                                name:name
                               title:title] autorelease];
}

- (id) initWithID:(NSString*)ID
             name:(NSString*)name
            title:(NSString*)title
{
    self = [super init];
    if(self != nil)
    {
        mID = [ID retain];
        mName = [name retain];
        mTitle = [title retain];
    }
    return self;
}

- (void) dealloc
{
    [mTitle release];
    [mName release];
    [mID release];
    [super dealloc];
}

@end

/*--------------------------------------------------*/

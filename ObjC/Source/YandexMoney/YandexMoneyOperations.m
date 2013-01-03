/*--------------------------------------------------*/

#import "YandexMoney.h"
#import "RestAPI.h"

/*--------------------------------------------------*/

@implementation YandexMoneyOperations

@synthesize list = mList;

+ (YandexMoneyOperations*) operations
{
    return [[[self alloc] init] autorelease];
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
    [mList release];
    [super dealloc];
}

- (void) addOperation:(YandexMoneyOperation*)operation
{
    [mList addObject:operation];
}

- (void) removeOperation:(YandexMoneyOperation*)operation
{
    [mList removeObject:operation];
}

- (void) removeOperationByPaymentID:(NSString*)paymentID
{
    NSUInteger index = 0;
    for(YandexMoneyOperation* operation in mList)
    {
        if([[operation paymentID] isEqualToString:paymentID] == YES)
        {
            [mList removeObjectAtIndex:index];
        }
        index++;
    }
}

- (YandexMoneyOperation*) operationAtPaymentID:(NSString*)paymentID
{
    for(YandexMoneyOperation* operation in mList)
    {
        if([[operation paymentID] isEqualToString:paymentID] == YES)
        {
            return operation;
        }
    }
    return nil;
}

- (YandexMoneyOperation*) operationAt:(NSUInteger)index
{
    return [mList objectAtIndex:index];
}

@end

/*--------------------------------------------------*/
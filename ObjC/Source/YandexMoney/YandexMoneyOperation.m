/*--------------------------------------------------*/

#import "YandexMoney.h"

/*--------------------------------------------------*/

@implementation YandexMoneyOperation

@synthesize paymentID = mPaymentID;
@synthesize patternID = mPatternID;
@synthesize status = mStatus;
@synthesize direction = mDirection;
@synthesize amount = mAmount;
@synthesize datetime = mDatetime;
@synthesize title = mTitle;
@synthesize sender = mSender;
@synthesize recipient = mRecipient;
@synthesize recipientType = mRecipientType;
@synthesize message = mMessage;
@synthesize comment = mComment;
@synthesize codepro = mCodepro;
@synthesize label = mLabel;
@synthesize details = mDetails;

+ (YandexMoneyOperation*) operation
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
    [mPaymentID release];
    [mPatternID release];
    [mStatus release];
    [mAmount release];
    [mDatetime release];
    [mTitle release];
    [mSender release];
    [mRecipient release];
    [mMessage release];
    [mComment release];
    [mLabel release];
    [mDetails release];
    [super dealloc];
}

- (void) setPaymentIDWithJSON:(id)paymentID
{
    if([paymentID isKindOfClass:[NSString class]] == YES)
    {
        if([mPaymentID isEqual:paymentID] == NO)
        {
            [mPaymentID release];
            mPaymentID = [paymentID retain];
        }
    }
    else
    {
        [mPaymentID release];
        mPaymentID = nil;
    }
}

- (void) setPatternIDWithJSON:(id)patternID
{
    if([patternID isKindOfClass:[NSString class]] == YES)
    {
        if([mPatternID isEqual:patternID] == NO)
        {
            [mPatternID release];
            mPatternID = [patternID retain];
        }
    }
    else
    {
        [mPatternID release];
        mPatternID = nil;
    }
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

- (void) setDirectionWithJSON:(id)direction
{
    if([direction isKindOfClass:[NSString class]] == YES)
    {
        if([direction isEqualToString:@"in"] == YES)
        {
            mDirection = YandexMoneyOperationDirectionIn;
        }
        else if([direction isEqualToString:@"out"] == YES)
        {
            mDirection = YandexMoneyOperationDirectionOut;
        }
        else
        {
            mDirection = YandexMoneyOperationDirectionUnknown;
        }
    }
    else
    {
        mDirection = YandexMoneyOperationDirectionUnknown;
    }
}

- (void) setAmountWithJSON:(id)amount
{
    if([amount isKindOfClass:[NSNumber class]] == YES)
    {
        if([mAmount isEqual:amount] == NO)
        {
            [mAmount release];
            mAmount = [amount retain];
        }
    }
    else
    {
        [mAmount release];
        mAmount = nil;
    }
}

- (void) setDatetimeWithJSON:(id)datetime
{
    if([datetime isKindOfClass:[NSString class]] == YES)
    {
        NSDate* date = [[YandexMoney RFC3339SecondFormatter] dateFromString:datetime];
        if([mDatetime isEqual:date] == NO)
        {
            [mDatetime release];
            mDatetime = [datetime retain];
        }
    }
    else
    {
        [mDatetime release];
        mDatetime = nil;
    }
}

- (void) setTitleWithJSON:(id)title
{
    if([title isKindOfClass:[NSString class]] == YES)
    {
        if([mTitle isEqual:title] == NO)
        {
            [mTitle release];
            mTitle = [title retain];
        }
    }
    else
    {
        [mTitle release];
        mTitle = nil;
    }
}

- (void) setSenderWithJSON:(id)sender
{
    if([sender isKindOfClass:[NSString class]] == YES)
    {
        if([mSender isEqual:sender] == NO)
        {
            [mSender release];
            mSender = [sender retain];
        }
    }
    else
    {
        [mSender release];
        mSender = nil;
    }
}

- (void) setRecipientWithJSON:(id)recipient
{
    if([recipient isKindOfClass:[NSString class]] == YES)
    {
        if([mRecipient isEqual:recipient] == NO)
        {
            [mRecipient release];
            mRecipient = [recipient retain];
        }
    }
    else
    {
        [mRecipient release];
        mRecipient = nil;
    }
}

- (void) setRecipientTypeWithJSON:(id)recipientType
{
    if([recipientType isKindOfClass:[NSString class]] == YES)
    {
        if([recipientType isEqualToString:@"account"] == YES)
        {
            mRecipientType = YandexMoneyRecipientTypeAccount;
        }
        else if([recipientType isEqualToString:@"phone"] == YES)
        {
            mRecipientType = YandexMoneyRecipientTypePhone;
        }
        else if([recipientType isEqualToString:@"email"] == YES)
        {
            mRecipientType = YandexMoneyRecipientTypeEmail;
        }
        else
        {
            mRecipientType = YandexMoneyRecipientTypeUnknown;
        }
    }
    else
    {
        mRecipientType = YandexMoneyRecipientTypeUnknown;
    }
}

- (void) setMessageWithJSON:(id)message
{
    if([message isKindOfClass:[NSString class]] == YES)
    {
        if([mMessage isEqual:message] == NO)
        {
            [mMessage release];
            mMessage = [message retain];
        }
    }
    else
    {
        [mMessage release];
        mMessage = nil;
    }
}

- (void) setCommentWithJSON:(id)comment
{
    if([comment isKindOfClass:[NSString class]] == YES)
    {
        if([mComment isEqual:comment] == NO)
        {
            [mComment release];
            mComment = [comment retain];
        }
    }
    else
    {
        [mComment release];
        mComment = nil;
    }
}

- (void) setCodeproWithJSON:(id)codepro
{
    if([codepro isKindOfClass:[NSNumber class]] == YES)
    {
        mCodepro = [codepro boolValue];
    }
    else
    {
        mCodepro = NO;
    }
}

- (void) setLabelWithJSON:(id)label
{
    if([label isKindOfClass:[NSString class]] == YES)
    {
        if([mLabel isEqual:label] == NO)
        {
            [mLabel release];
            mLabel = [label retain];
        }
    }
    else
    {
        [mLabel release];
        mLabel = nil;
    }
}

- (void) setDetailsWithJSON:(id)details
{
    if([details isKindOfClass:[NSString class]] == YES)
    {
        if([mDetails isEqual:details] == NO)
        {
            [mDetails release];
            mDetails = [details retain];
        }
    }
    else
    {
        [mDetails release];
        mDetails = nil;
    }
}

@end

/*--------------------------------------------------*/
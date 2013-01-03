/*--------------------------------------------------*/

#import "YandexMoney.h"
#import "RestAPI.h"

/*--------------------------------------------------*/

@implementation YandexMoneyPaymentP2P

@synthesize requestTo = mRequestTo;
@synthesize requestIdentifierType = mRequestIdentifierType;
@synthesize requestAmount = mRequestAmount;
@synthesize requestComment = mRequestComment;
@synthesize requestMessage = mRequestMessage;
@synthesize requestLabel = mRequestLabel;
@synthesize requestID = mRequestID;
@synthesize requestMoneySource = mRequestMoneySource;
@synthesize requestContract = mRequestContract;
@synthesize requestBalance = mRequestBalance;
@synthesize requestRecipientIdentified = mRequestRecipientIdentified;
@synthesize requestRecipientAccountType = mRequestRecipientAccountType;
@synthesize paymentCSC = mPaymentCSC;
@synthesize paymentMoneySource = mPaymentMoneySource;
@synthesize paymentID = mPaymentID;
@synthesize paymentBalance = mPaymentBalance;
@synthesize paymentInvoiceID = mPaymentInvoiceID;
@synthesize paymentPayer = mPaymentPayer;
@synthesize paymentPayee = mPaymentPayee;
@synthesize paymentCreditAmount = mPaymentCreditAmount;
@synthesize paymentPinSerial = mPaymentPinSerial;
@synthesize paymentPinSecret = mPaymentPinSecret;

+ (YandexMoneyPaymentP2P*) paymentWithTo:(NSString*)to
                          identifierType:(YandexMoneyIdentifierType)identifierType
                                  amount:(NSNumber*)amount
                                 comment:(NSString*)comment
                                 message:(NSString*)message
                                   label:(NSString*)label
{
    return [[[self alloc] initWithPatternTo:to
                             identifierType:identifierType
                                     amount:amount
                                    comment:comment
                                    message:message
                                      label:label] autorelease];
}

- (id) initWithPatternTo:(NSString*)to
          identifierType:(YandexMoneyIdentifierType)identifierType
                  amount:(NSNumber*)amount
                 comment:(NSString*)comment
                 message:(NSString*)message
                   label:(NSString*)label
{
    self = [super initWithPatternID:@"p2p"];
    if(self != nil)
    {
        mRequestTo = [to retain];
        mRequestIdentifierType = identifierType;
        mRequestAmount = [amount retain];
        mRequestComment = [comment retain];
        mRequestMessage = [message retain];
        mRequestLabel = [label retain];
    }
    return self;
}

- (void) dealloc
{
    [mRequestTo release];
    [mRequestAmount release];
    [mRequestComment release];
    [mRequestMessage release];
    [mRequestLabel release];
    [mRequestID release];
    [mRequestContract release];
    [mRequestBalance release];
    [mRequestRecipientAccountType release];
    [mPaymentCSC release];
    [super dealloc];
}

- (void) setRequestIDWithJSON:(id)requestID
{
    if([requestID isKindOfClass:[NSString class]] == YES)
    {
        if([mRequestID isEqual:requestID] == NO)
        {
            [mRequestID release];
            mRequestID = [requestID retain];
        }
    }
    else
    {
        [mRequestID release];
        mRequestID = nil;
    }
}

- (void) setRequestMoneySourceWithJSON:(id)requestMoneySource
{
    YandexMoneyPaymentMoneySource flags = YandexMoneyPaymentMoneySourceUnknown;
    if([requestMoneySource isKindOfClass:[NSDictionary class]] == YES)
    {
        NSDictionary* wallet = [requestMoneySource objectForKey:@"wallet"];
        if([wallet isKindOfClass:[NSDictionary class]] == YES)
        {
            NSString* allowed = [wallet objectForKey:@"allowed"];
            if([allowed isEqualToString:@"false"] == NO)
            {
                flags = YandexMoneyPaymentMoneySourceWallet;
            }
        }
        NSDictionary* card = [requestMoneySource objectForKey:@"card"];
        if([card isKindOfClass:[NSDictionary class]] == YES)
        {
            NSString* allowed = [card objectForKey:@"allowed"];
            if([allowed isEqualToString:@"false"] == NO)
            {
                flags = YandexMoneyPaymentMoneySourceCard;
            }
        }
    }
    mRequestMoneySource = flags;
}

- (void) setRequestContractWithJSON:(id)requestContract
{
    if([requestContract isKindOfClass:[NSString class]] == YES)
    {
        if([mRequestContract isEqual:requestContract] == NO)
        {
            [mRequestContract release];
            mRequestContract = [requestContract retain];
        }
    }
    else
    {
        [mRequestContract release];
        mRequestContract = nil;
    }
}

- (void) setRequestBalanceWithJSON:(id)requestBalance
{
    if([requestBalance isKindOfClass:[NSNumber class]] == YES)
    {
        if([mRequestBalance isEqual:requestBalance] == NO)
        {
            [mRequestBalance release];
            mRequestBalance = [requestBalance retain];
        }
    }
    else
    {
        [mRequestBalance release];
        mRequestBalance = nil;
    }
}

- (void) setRequestRecipientIdentifiedWithJSON:(id)requestRecipientIdentified
{
    if([requestRecipientIdentified isKindOfClass:[NSNumber class]] == YES)
    {
        mRequestRecipientIdentified = [requestRecipientIdentified boolValue];
    }
    else
    {
        mRequestRecipientIdentified = NO;
    }
}

- (void) setRequestRecipientAccountTypeWithJSON:(id)requestRecipientAccountType
{
    if([requestRecipientAccountType isKindOfClass:[NSString class]] == YES)
    {
        if([mRequestRecipientAccountType isEqual:requestRecipientAccountType] == NO)
        {
            [mRequestRecipientAccountType release];
            mRequestRecipientAccountType = [requestRecipientAccountType retain];
        }
    }
    else
    {
        [mRequestRecipientAccountType release];
        mRequestRecipientAccountType = nil;
    }
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

- (void) setPaymentBalanceWithJSON:(id)paymentBalance
{
    if([paymentBalance isKindOfClass:[NSNumber class]] == YES)
    {
        if([mPaymentBalance isEqual:paymentBalance] == NO)
        {
            [mPaymentBalance release];
            mPaymentBalance = [paymentBalance retain];
        }
    }
    else
    {
        [mPaymentBalance release];
        mPaymentBalance = nil;
    }
}

- (void) setPaymentInvoiceIDWithJSON:(id)paymentInvoiceID
{
    if([paymentInvoiceID isKindOfClass:[NSString class]] == YES)
    {
        if([mPaymentInvoiceID isEqual:paymentInvoiceID] == NO)
        {
            [mPaymentInvoiceID release];
            mPaymentInvoiceID = [paymentInvoiceID retain];
        }
    }
    else
    {
        [mPaymentInvoiceID release];
        mPaymentInvoiceID = nil;
    }
}

- (void) setPaymentPayerWithJSON:(id)paymentPayer
{
    if([paymentPayer isKindOfClass:[NSString class]] == YES)
    {
        if([mPaymentPayer isEqual:paymentPayer] == NO)
        {
            [mPaymentPayer release];
            mPaymentPayer = [paymentPayer retain];
        }
    }
    else
    {
        [mPaymentPayer release];
        mPaymentPayer = nil;
    }
}

- (void) setPaymentPayeeWithJSON:(id)paymentPayee
{
    if([paymentPayee isKindOfClass:[NSString class]] == YES)
    {
        if([mPaymentPayee isEqual:paymentPayee] == NO)
        {
            [mPaymentPayee release];
            mPaymentPayee = [paymentPayee retain];
        }
    }
    else
    {
        [mPaymentPayee release];
        mPaymentPayee = nil;
    }
}

- (void) setPaymentCreditAmountWithJSON:(id)paymentCreditAmount
{
    if([paymentCreditAmount isKindOfClass:[NSNumber class]] == YES)
    {
        if([mPaymentCreditAmount isEqual:paymentCreditAmount] == NO)
        {
            [mPaymentCreditAmount release];
            mPaymentCreditAmount = [paymentCreditAmount retain];
        }
    }
    else
    {
        [mPaymentCreditAmount release];
        mPaymentCreditAmount = nil;
    }
}

- (void) setPaymentPinSerialWithJSON:(id)paymentPinSerial
{
    if([paymentPinSerial isKindOfClass:[NSString class]] == YES)
    {
        if([mPaymentPinSerial isEqual:paymentPinSerial] == NO)
        {
            [mPaymentPinSerial release];
            mPaymentPinSerial = [paymentPinSerial retain];
        }
    }
    else
    {
        [mPaymentPinSerial release];
        mPaymentPinSerial = nil;
    }
}

- (void) setPaymentPinSecretWithJSON:(id)paymentPinSecret
{
    if([paymentPinSecret isKindOfClass:[NSString class]] == YES)
    {
        if([mPaymentPinSecret isEqual:paymentPinSecret] == NO)
        {
            [mPaymentPinSecret release];
            mPaymentPinSecret = [paymentPinSecret retain];
        }
    }
    else
    {
        [mPaymentPinSecret release];
        mPaymentPinSecret = nil;
    }
}

@end

/*--------------------------------------------------*/

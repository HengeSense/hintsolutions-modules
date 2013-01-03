/*--------------------------------------------------*/

#import "YandexMoney.h"
#import "RestAPI.h"

/*--------------------------------------------------*/

#import "YandexMoneyLoginController.h"

/*--------------------------------------------------*/

NSString* const YandexMoneyErrorDomain = @"YandexMoneyErrorDomain";

/*--------------------------------------------------*/

@interface YandexMoney (Private)

- (BOOL) isSessionValid;
- (void) saveSession;
- (void) loadSession;

- (void) setAccessTokenWithJSON:(id)accessToken;
- (void) setAccountWithJSON:(id)account;
- (void) setBalanceWithJSON:(id)balance;
- (void) setCurrencyWithJSON:(id)currency;
- (void) setIdentifiedWithJSON:(id)identified;
- (void) setAccountTypeWithJSON:(id)accountType;

- (NSError*) errorWithDescription:(NSString*)description;

@end

/*--------------------------------------------------*/

@implementation YandexMoney (Private)

- (BOOL) isSessionValid
{
    return (mAccessToken != nil);
}

- (void) saveSession
{
    NSUserDefaults* storage = [NSUserDefaults standardUserDefaults];
    [storage setValue:mAccessToken forKey:@"YandexMoneyAccessToken"];
    [storage synchronize];
}

- (void) loadSession
{
    NSUserDefaults* storage = [NSUserDefaults standardUserDefaults];
    [self setAccessTokenWithJSON:[storage objectForKey:@"YandexMoneyAccessToken"]];
}

- (void) setAccessTokenWithJSON:(id)accessToken
{
    if([accessToken isKindOfClass:[NSString class]] == YES)
    {
        if([mAccessToken isEqual:accessToken] == NO)
        {
            [mAccessToken release];
            mAccessToken = [accessToken retain];
        }
    }
    else
    {
        [mAccessToken release];
        mAccessToken = nil;
    }
}

- (void) setAccountWithJSON:(id)account
{
    if([account isKindOfClass:[NSString class]] == YES)
    {
        if([mAccount isEqual:account] == NO)
        {
            [mAccount release];
            mAccount = [account retain];
        }
    }
    else
    {
        [mAccount release];
        mAccount = nil;
    }
}

- (void) setBalanceWithJSON:(id)balance
{
    if([balance isKindOfClass:[NSNumber class]] == YES)
    {
        if([mBalance isEqual:balance] == NO)
        {
            [mBalance release];
            mBalance = [balance retain];
        }
    }
    else
    {
        [mBalance release];
        mBalance = nil;
    }
}

- (void) setCurrencyWithJSON:(id)currency
{
    if([currency isKindOfClass:[NSString class]] == YES)
    {
        if([currency isEqualToString:@"643"] == YES)
        {
            mCurrency = YandexMoneyCurrencyRUB;
        }
        else
        {
            mCurrency = YandexMoneyCurrencyUnknown;
        }
    }
    else
    {
        mCurrency = YandexMoneyCurrencyUnknown;
    }
}

- (void) setIdentifiedWithJSON:(id)identified
{
    if([identified isKindOfClass:[NSNumber class]] == YES)
    {
        mIdentified = [identified boolValue];
    }
    else
    {
        mIdentified = NO;
    }
}

- (void) setAccountTypeWithJSON:(id)accountType
{
    if([accountType isKindOfClass:[NSString class]] == YES)
    {
        if([accountType isEqualToString:@"personal"] == YES)
        {
            mAccountType = YandexMoneyAccountTypePersonal;
        }
        else if([accountType isEqualToString:@"professional"] == YES)
        {
            mAccountType = YandexMoneyAccountTypeProfessional;
        }
        else
        {
            mAccountType = YandexMoneyAccountTypeUnknown;
        }
    }
    else
    {
        mAccountType = YandexMoneyAccountTypeUnknown;
    }
}

- (NSError*) errorWithDescription:(NSString*)description
{
    return [NSError errorWithDomain:YandexMoneyErrorDomain
                               code:YandexMoneyErrorInternal
                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                     description, NSLocalizedDescriptionKey,
                                     nil]];
}

@end

/*--------------------------------------------------*/

@implementation YandexMoney

@synthesize clientID = mClientID;
@synthesize redirectURI = mRedirectURI;
@synthesize scope = mScope;
@synthesize clientSecret = mClientSecret;
@synthesize authorizationCode = mAuthorizationCode;
@synthesize accessToken = mAccessToken;
@synthesize account = mAccount;
@synthesize balance = mBalance;
@synthesize currency = mCurrency;
@synthesize identified = mIdentified;
@synthesize accountType = mAccountType;
@synthesize status = mStatus;
@synthesize error = mError;

+ (YandexMoney*) sharedYandexMoney
{
    if(sharedYandexMoney == nil)
    {
        @synchronized(self)
        {
            if(sharedYandexMoney == nil)
            {
                sharedYandexMoney = [[self alloc] init];
            }
        }
    }
    return sharedYandexMoney;
}

- (id) init
{
    self = [super init];
    if(self != nil)
    {
        [self loadSession];
    }
    return self;
}

- (void) dealloc
{
    [self setClientID:nil];
    [self setRedirectURI:nil];
    [self setClientSecret:nil];
    [mAuthorizationCode release];
    [mAccessToken release];
    [mAccount release];
    [mBalance release];
    [mStatus release];
    [mError release];
    [super dealloc];
}

- (BOOL) isLogin
{
    return [self isSessionValid];
}

- (void) login:(UIViewController*)controller
      callback:(YandexMoneyCallbackLogin)callback
{
    if([self isSessionValid] == NO)
    {
        YandexMoneyLoginController* loginController = [YandexMoneyLoginController controllerWithClientID:mClientID
                                                                                             redirectURI:mRedirectURI
                                                                                                   scope:mScope
                                                                                            clientSecret:mClientSecret
                                                                                         successCallback:^(id accessToken) {
                                                                                             [self setAccessTokenWithJSON:accessToken];
                                                                                             [self saveSession];
                                                                                             callback(nil);
                                                                                         }
                                                                                         failureCallback:^(NSError* error) {
                                                                                             callback(error);
                                                                                         }];
        [controller presentModalViewController:loginController
                                      animated:YES];
    }
    else
    {
        callback(nil);
    }
}

- (void) logout:(YandexMoneyCallbackLogout)callback
{
    if([self isSessionValid] == YES)
    {
        [RestAPIConnection connectionWithMethod:@"POST"
                                            url:@"https://m.sp-money.yandex.ru/oauth/revoke"
                                        headers:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Bearer %@", mAccessToken]
                                                                            forKey:@"Authorization"]
                                        success:^(RestAPIConnection *connection) {
                                            [self setAccessTokenWithJSON:nil];
                                            [self saveSession];
                                            if(callback != nil)
                                            {
                                                callback(nil);
                                            }
                                        }
                                        failure:^(RestAPIConnection *connection, NSError *error) {
                                            if(callback != nil)
                                            {
                                                callback(error);
                                            }
                                        }];
    }
    else
    {
        if(callback != nil)
        {
            callback(nil);
        }
    }
}

- (void) requestAccountInfo:(YandexMoneyCallbackAccountInfo)callback
{
    [RestAPIConnection connectionWithMethod:@"POST"
                                        url:@"https://money.yandex.ru/api/account-info"
                                    headers:[NSDictionary dictionaryWithObjectsAndKeys:
                                             @"application/x-www-form-urlencoded;charset=UTF-8", @"Content-Type",
                                             [NSString stringWithFormat:@"Bearer %@", mAccessToken], @"Authorization",
                                             nil]
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        id responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil)
                                        {
                                            [self setAccountWithJSON:[responseJSON objectForKey:@"account"]];
                                            [self setBalanceWithJSON:[responseJSON objectForKey:@"balance"]];
                                            [self setCurrencyWithJSON:[responseJSON objectForKey:@"currency"]];
                                            [self setIdentifiedWithJSON:[responseJSON objectForKey:@"identified"]];
                                            [self setAccountTypeWithJSON:[responseJSON objectForKey:@"account_type"]];
                                            callback(nil);
                                        }
                                        if(responseError != nil)
                                        {
                                            callback(responseError);
                                        }
                                    }
                                    failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(error);
                                    }];
}

- (YandexMoneyPayment*) requestPaymentWithP2P:(NSString*)to
                               identifierType:(YandexMoneyIdentifierType)identifierType
                                       amount:(NSNumber*)amount
                                      comment:(NSString*)comment
                                      message:(NSString*)message
                                        label:(NSString*)label
                                     callback:(YandexMoneyCallbackReguestPaymentP2P)callback
{
    YandexMoneyPaymentP2P* payment = [YandexMoneyPaymentP2P paymentWithTo:to
                                                          identifierType:identifierType
                                                                  amount:amount
                                                                 comment:comment
                                                                 message:message
                                                                   label:label];
    if(payment != nil)
    {
        NSMutableDictionary* query = [NSMutableDictionary dictionaryWithObject:[payment patternID]
                                                                         forKey:@"pattern_id"];
        if([payment requestTo] != nil)
        {
            [query setObject:[payment requestTo]
                      forKey:@"to"];
        }
        switch([payment requestIdentifierType])
        {
            case YandexMoneyIdentifierTypeAccount:
                [query setObject:@"account"
                          forKey:@"identifier_type"];
                break;
            case YandexMoneyIdentifierTypePhone:
                [query setObject:@"phone"
                          forKey:@"identifier_type"];
                break;
        }
        if([payment requestAmount] != nil)
        {
            [query setObject:[payment requestAmount]
                      forKey:@"amount"];
        }
        if([payment requestComment] != nil)
        {
            [query setObject:[payment requestComment]
                      forKey:@"comment"];
        }
        if([payment requestMessage] != nil)
        {
            [query setObject:[payment requestMessage]
                      forKey:@"message"];
        }
        if([payment requestLabel] != nil)
        {
            [query setObject:[payment requestLabel]
                      forKey:@"label"];
        }
        [RestAPIConnection connectionWithMethod:@"POST"
                                            url:@"https://money.yandex.ru/api/request-payment"
                                        headers:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 @"application/x-www-form-urlencoded;charset=UTF-8", @"Content-Type",
                                                 [NSString stringWithFormat:@"Bearer %@", mAccessToken], @"Authorization",
                                                 nil]
                                          query:query
                                        success:^(RestAPIConnection *connection) {
                                            NSError* responseError = nil;
                                            id responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                            if(responseError == nil)
                                            {
                                                [payment setStatusWithJSON:[responseJSON objectForKey:@"status"]];
                                                if([payment isStatusSuccess] == YES)
                                                {
                                                    [payment setRequestIDWithJSON:[responseJSON objectForKey:@"request_id"]];
                                                    [payment setRequestMoneySourceWithJSON:[responseJSON objectForKey:@"money_source"]];
                                                    [payment setRequestContractWithJSON:[responseJSON objectForKey:@"contract"]];
                                                    [payment setRequestBalanceWithJSON:[responseJSON objectForKey:@"balance"]];
                                                    [payment setRequestRecipientIdentifiedWithJSON:[responseJSON objectForKey:@"recipient_identified"]];
                                                    [payment setRequestRecipientAccountTypeWithJSON:[responseJSON objectForKey:@"recipient_account_type"]];
                                                    callback(payment, nil);
                                                }
                                                else
                                                {
                                                    responseError = [self errorWithDescription:[responseJSON objectForKey:@"error"]];
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
    return payment;
}

- (void) processPaymentP2P:(YandexMoneyPaymentP2P*)payment
          cardSecurityCode:(NSString*)cardSecurityCode
               moneySource:(YandexMoneyPaymentMoneySource)moneySource
                  callback:(YandexMoneyCallbackProcessPaymentP2P)callback
{
    NSMutableDictionary* query = nil;
    if([payment isKindOfClass:[YandexMoneyPaymentP2P class]] == YES)
    {
        query = [NSMutableDictionary dictionaryWithObject:[payment requestID]
                                                   forKey:@"request_id"];
        if(cardSecurityCode != nil)
        {
            [query setObject:cardSecurityCode
                      forKey:@"csc"];
        }
        switch(moneySource)
        {
            case YandexMoneyPaymentMoneySourceWallet:
                [query setObject:@"wallet"
                          forKey:@"money_source"];
                break;
            case YandexMoneyPaymentMoneySourceCard:
                [query setObject:@"card"
                          forKey:@"money_source"];
                break;
        }
    }
    [RestAPIConnection connectionWithMethod:@"POST"
                                        url:@"https://money.yandex.ru/api/process-payment"
                                    headers:[NSDictionary dictionaryWithObjectsAndKeys:
                                             @"application/x-www-form-urlencoded;charset=UTF-8", @"Content-Type",
                                             [NSString stringWithFormat:@"Bearer %@", mAccessToken], @"Authorization",
                                             nil]
                                      query:query
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        id responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil)
                                        {
                                            [payment setStatusWithJSON:[responseJSON objectForKey:@"status"]];
                                            if([payment isStatusSuccess] == YES)
                                            {
                                                if([payment isKindOfClass:[YandexMoneyPaymentP2P class]] == YES)
                                                {
                                                    [payment setPaymentIDWithJSON:[responseJSON objectForKey:@"payment_id"]];
                                                    [payment setPaymentBalanceWithJSON:[responseJSON objectForKey:@"balance"]];
                                                    [payment setPaymentInvoiceIDWithJSON:[responseJSON objectForKey:@"invoice_id"]];
                                                    [payment setPaymentPayerWithJSON:[responseJSON objectForKey:@"payer"]];
                                                    [payment setPaymentPayeeWithJSON:[responseJSON objectForKey:@"payee"]];
                                                    [payment setPaymentCreditAmountWithJSON:[responseJSON objectForKey:@"credit_amount"]];
                                                    [payment setPaymentPinSerialWithJSON:[responseJSON objectForKey:@"pin_serial"]];
                                                    [payment setPaymentPinSecretWithJSON:[responseJSON objectForKey:@"pin_secret"]];
                                                    callback(payment, nil);
                                                }
                                            }
                                            else
                                            {
                                                responseError = [self errorWithDescription:[responseJSON objectForKey:@"error"]];
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

- (void) requestHistoryWithDirection:(YandexMoneyOperationDirection)direction
                               label:(NSString*)label
                                from:(NSDate*)from
                                till:(NSDate*)till
                         startRecord:(NSNumber*)startRecord
                             records:(NSNumber*)records
                             details:(BOOL)details
                            callback:(YandexMoneyCallbackHistory)callback
{
    NSMutableDictionary* query = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithBool:details]
                                                                    forKey:@"details"];
    switch(direction)
    {
        case YandexMoneyOperationDirectionIn:
            [query setObject:@"deposition"
                      forKey:@"type"];
            break;
        case YandexMoneyOperationDirectionOut:
            [query setObject:@"payment"
                      forKey:@"type"];
            break;
    }
    if(label != nil)
    {
        [query setObject:label
                  forKey:@"label"];
    }
    if(from != nil)
    {
        [query setObject:[[YandexMoney RFC3339SecondFormatter] stringFromDate:from]
                  forKey:@"from"];
    }
    if(till != nil)
    {
        [query setObject:[[YandexMoney RFC3339SecondFormatter] stringFromDate:till]
                  forKey:@"till"];
    }
    if(startRecord != nil)
    {
        [query setObject:startRecord
                  forKey:@"start_record"];
    }
    if(records != nil)
    {
        [query setObject:records
                  forKey:@"records"];
    }
    [RestAPIConnection connectionWithMethod:@"POST"
                                        url:@"https://money.yandex.ru/api/operation-history"
                                    headers:[NSDictionary dictionaryWithObjectsAndKeys:
                                             @"application/x-www-form-urlencoded;charset=UTF-8", @"Content-Type",
                                             [NSString stringWithFormat:@"Bearer %@", mAccessToken], @"Authorization",
                                             nil]
                                      query:query
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        id responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil)
                                        {
                                            NSString* error = [responseJSON objectForKey:@"error"];
                                            if(error == nil)
                                            {
                                                NSArray* operations = [responseJSON objectForKey:@"operations"];
                                                if(operations != nil)
                                                {
                                                    YandexMoneyOperations* result = [YandexMoneyOperations operations];
                                                    if(result != nil)
                                                    {
                                                        for(NSDictionary* item in operations)
                                                        {
                                                            YandexMoneyOperation* operation = [YandexMoneyOperation operation];
                                                            if(operation != nil)
                                                            {
                                                                [operation setPaymentIDWithJSON:[item objectForKey:@"operation_id"]];
                                                                [operation setPatternIDWithJSON:[item objectForKey:@"pattern_id"]];
                                                                [operation setStatusWithJSON:[item objectForKey:@"status"]];
                                                                [operation setDatetimeWithJSON:[item objectForKey:@"datetime"]];
                                                                [operation setAmountWithJSON:[item objectForKey:@"amount"]];
                                                                [operation setDirectionWithJSON:[item objectForKey:@"direction"]];
                                                                [operation setTitleWithJSON:[item objectForKey:@"title"]];
                                                                [operation setLabelWithJSON:[item objectForKey:@"label"]];
                                                                [result addOperation:operation];
                                                            }
                                                        }
                                                        callback(result, nil);
                                                    }
                                                    else
                                                    {
                                                        responseError = [self errorWithDescription:@"Out of memory"];
                                                    }
                                                }
                                                else
                                                {
                                                }
                                            }
                                            else
                                            {
                                                responseError = [self errorWithDescription:error];
                                                
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

- (void) requestDetail:(NSString*)paymentID
              callback:(YandexMoneyCallbackDetail)callback
{
    [RestAPIConnection connectionWithMethod:@"POST"
                                        url:@"https://money.yandex.ru/api/operation-details"
                                    headers:[NSDictionary dictionaryWithObjectsAndKeys:
                                             @"application/x-www-form-urlencoded;charset=UTF-8", @"Content-Type",
                                             [NSString stringWithFormat:@"Bearer %@", mAccessToken], @"Authorization",
                                             nil]
                                      query:[NSMutableDictionary dictionaryWithObject:paymentID
                                                                               forKey:@"operation_id"]
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        id responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil)
                                        {
                                            NSString* error = [responseJSON objectForKey:@"error"];
                                            if(error == nil)
                                            {
                                                YandexMoneyOperation* operation = [YandexMoneyOperation operation];
                                                if(operation != nil)
                                                {
                                                    [operation setPaymentIDWithJSON:[responseJSON objectForKey:@"operation_id"]];
                                                    [operation setPatternIDWithJSON:[responseJSON objectForKey:@"pattern_id"]];
                                                    [operation setStatusWithJSON:[responseJSON objectForKey:@"status"]];
                                                    [operation setDatetimeWithJSON:[responseJSON objectForKey:@"datetime"]];
                                                    [operation setAmountWithJSON:[responseJSON objectForKey:@"amount"]];
                                                    [operation setDirectionWithJSON:[responseJSON objectForKey:@"direction"]];
                                                    [operation setRecipientWithJSON:[responseJSON objectForKey:@"recipient"]];
                                                    [operation setRecipientTypeWithJSON:[responseJSON objectForKey:@"recipient_type"]];
                                                    [operation setCodeproWithJSON:[responseJSON objectForKey:@"codepro"]];
                                                    [operation setTitleWithJSON:[responseJSON objectForKey:@"title"]];
                                                    [operation setLabelWithJSON:[responseJSON objectForKey:@"label"]];
                                                    [operation setSenderWithJSON:[responseJSON objectForKey:@"sender"]];
                                                    [operation setMessageWithJSON:[responseJSON objectForKey:@"message"]];
                                                    [operation setCommentWithJSON:[responseJSON objectForKey:@"comment"]];
                                                    [operation setDetailsWithJSON:[responseJSON objectForKey:@"details"]];
                                                    callback(operation, nil);
                                                }
                                                else
                                                {
                                                    responseError = [self errorWithDescription:@"Out of memory"];
                                                }
                                            }
                                            else
                                            {
                                                responseError = [self errorWithDescription:error];
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

+ (NSDateFormatter*) RFC3339SecondFormatter
{
    static NSString* format = @"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ";
    static NSDateFormatter* dateFormatter = nil;
    if(dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale* enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        assert(enUSPOSIXLocale != nil);
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setDateFormat:format];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [enUSPOSIXLocale release];
    }
    return dateFormatter;
}

+ (NSDateFormatter*) RFC3339MillisecondFormatter
{
    static NSString* format =  @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ";
    static NSDateFormatter* dateFormatter = nil;
    if(dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale* enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        assert(enUSPOSIXLocale != nil);
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setDateFormat:format];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [enUSPOSIXLocale release];
    }
    return dateFormatter;
}

@end

/*--------------------------------------------------*/

YandexMoney * sharedYandexMoney = nil;

/*--------------------------------------------------*/
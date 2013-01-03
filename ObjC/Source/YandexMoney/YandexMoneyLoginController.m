/*--------------------------------------------------*/

#import "YandexMoneyLoginController.h"
#import "RestAPI.h"

/*--------------------------------------------------*/

@interface YandexMoneyLoginController (Private)

- (NSError*) errorWithDescription:(NSString*)description;

@end

/*--------------------------------------------------*/

@implementation YandexMoneyLoginController (Private)

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

@implementation YandexMoneyLoginController

+ (YandexMoneyLoginController*) controllerWithClientID:(NSString*)clientID
                                           redirectURI:(NSString*)redirectURI
                                                 scope:(YandexMoneyScope)scope
                                          clientSecret:(NSString*)clientSecret
                                       successCallback:(YandexMoneyLoginCallbackSuccess)successCallback
                                       failureCallback:(YandexMoneyLoginCallbackFailure)failureCallback
{
    return [[[self alloc] initWithClientID:clientID
                               redirectURI:redirectURI
                                     scope:scope
                              clientSecret:clientSecret
                           successCallback:successCallback
                           failureCallback:failureCallback] autorelease];
}

- (id) initWithClientID:(NSString*)clientID
            redirectURI:(NSString*)redirectURI
                  scope:(YandexMoneyScope)scope
           clientSecret:(NSString*)clientSecret
        successCallback:(YandexMoneyLoginCallbackSuccess)successCallback
        failureCallback:(YandexMoneyLoginCallbackFailure)failureCallback
{
    self = [super initWithNibName:@"YandexMoneyLoginController_iPhone"
                           bundle:nil];
    if(self != nil)
    {
        mClientID = [clientID retain];
        mRedirectURI = [redirectURI retain];
        mScope = scope;
        mClientSecret = [clientSecret retain];
        mSuccessCallback = Block_copy(successCallback);
        mFailureCallback = Block_copy(failureCallback);
    }
    return self;
}


- (void) dealloc
{
    [_loadingIndicator release];
    [_webView release];
    [super dealloc];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableDictionary* query = [NSMutableDictionary dictionaryWithObject:@"code"
                                                                    forKey:@"response_type"];
    if(query != nil)
    {
        if(mClientID != nil)
        {
            [query setValue:mClientID
                     forKey:@"client_id"];
        }
        if(mRedirectURI != nil)
        {
            [query setValue:mRedirectURI
                     forKey:@"redirect_uri"];
        }
        if(mScope != YandexMoneyScopeNone)
        {
            NSMutableArray* scopeArray = [NSMutableArray arrayWithCapacity:8];
            if((mScope & YandexMoneyScopeAccountInfo) == YandexMoneyScopeAccountInfo)
            {
                [scopeArray addObject:@"account-info"];
            }
            if((mScope & YandexMoneyScopeOperationHistory) == YandexMoneyScopeOperationHistory)
            {
                [scopeArray addObject:@"operation-history"];
            }
            if((mScope & YandexMoneyScopeOperationDetails) == YandexMoneyScopeOperationDetails)
            {
                [scopeArray addObject:@"operation-details"];
            }
            if((mScope & YandexMoneyScopePayment) == YandexMoneyScopePayment)
            {
                [scopeArray addObject:@"payment"];
            }
            if((mScope & YandexMoneyScopePaymentShop) == YandexMoneyScopePaymentShop)
            {
                [scopeArray addObject:@"payment-shop"];
            }
            if((mScope & YandexMoneyScopePaymentP2P) == YandexMoneyScopePaymentP2P)
            {
                [scopeArray addObject:@"payment-p2p"];
            }
            if((mScope & YandexMoneyScopeShoppingCart) == YandexMoneyScopeShoppingCart)
            {
                [scopeArray addObject:@"shopping-cart"];
            }
            if((mScope & (YandexMoneyScopeMoneySourceWallet | YandexMoneyScopeMoneySourceCard)) != 0)
            {
                NSMutableArray* moneySourceArray = [NSMutableArray arrayWithCapacity:4];
                if((mScope & YandexMoneyScopeMoneySourceWallet) == YandexMoneyScopeMoneySourceWallet)
                {
                    [moneySourceArray addObject:@"\"wallet\""];
                }
                if((mScope & YandexMoneyScopeMoneySourceCard) == YandexMoneyScopeMoneySourceCard)
                {
                    [moneySourceArray addObject:@"\"card\""];
                }
                [scopeArray addObject:[NSString stringWithFormat:@"money-source(%@)", [moneySourceArray componentsJoinedByString:@","]]];
            }
            [query setValue:[scopeArray componentsJoinedByString:@" "]
                     forKey:@"scope"];
        }
        [[self webView] loadRequest:[RestAPIRequest requestWithMethod:@"POST"
                                                                  url:@"https://m.sp-money.yandex.ru/oauth/authorize"
                                                              headers:[NSDictionary dictionaryWithObject:@"application/x-www-form-urlencoded;charset=UTF-8"
                                                                                                  forKey:@"Content-Type"]
                                                                query:query]];
    }
    else
    {
        mFailureCallback([self errorWithDescription:@"Out of memory"]);
    }
}

- (void) viewDidUnload
{
    [self setLoadingIndicator:nil];
    [self setWebView:nil];
    [super viewDidUnload];
}

- (IBAction) closePressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL) webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* url = [NSString stringWithFormat:@"%@://%@", [[request URL] scheme], [[request URL] host]];
    if([url isEqualToString:mRedirectURI] == YES)
    {
        NSArray* pairs = [[[request URL] query] componentsSeparatedByString:@"&"];
        for(NSString* pair in pairs)
        {
            NSArray* pairBits = [pair componentsSeparatedByString:@"="];
            NSString* pairName = [[pairBits objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            NSString* pairValue = [[pairBits objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            if([pairName isEqualToString:@"code"] == YES)
            {
                NSMutableDictionary* query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                              @"authorization_code", @"grant_type",
                                              mClientID, @"client_id",
                                              mRedirectURI, @"redirect_uri",
                                              pairValue, @"code",
                                              nil];
                if(mClientSecret != nil)
                {
                    [query setValue:mClientSecret
                             forKey:@"client_secret"];
                }
                [RestAPIConnection connectionWithMethod:@"POST"
                                                    url:@"https://m.sp-money.yandex.ru/oauth/token"
                                                headers:[NSDictionary dictionaryWithObject:@"application/x-www-form-urlencoded;charset=UTF-8"
                                                                                    forKey:@"Content-Type"]
                                                  query:query
                                                success:^(RestAPIConnection *connection) {
                                                    NSError* responseError = nil;
                                                    id responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                                    if(responseError == nil)
                                                    {
                                                        NSString* access_token = [responseJSON objectForKey:@"access_token"];
                                                        if(access_token != nil)
                                                        {
                                                            mSuccessCallback(access_token);
                                                        }
                                                        else
                                                        {
                                                            responseError = [self errorWithDescription:[responseJSON objectForKey:@"error"]];
                                                        }
                                                    }
                                                    if(responseError != nil)
                                                    {
                                                        mFailureCallback(responseError);
                                                    }
                                                }
                                                failure:^(RestAPIConnection *connection, NSError *error) {
                                                    mFailureCallback(error);
                                                }];
                break;
            }
            else if([pairName isEqualToString:@"error"] == YES)
            {
                mFailureCallback([self errorWithDescription:pairValue]);
            }
        }
        [self closePressed:webView];
        return NO;
    }
    return YES;
}

- (void) webViewDidStartLoad:(UIWebView*)webView
{
    [[self loadingIndicator] setHidden:NO];
    [[self loadingIndicator] startAnimating];
}

- (void) webViewDidFinishLoad:(UIWebView*)webView
{
    [[self loadingIndicator] stopAnimating];
    [[self loadingIndicator] setHidden:YES];
}

- (void) webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error
{
    mFailureCallback(error);
}

@end

/*--------------------------------------------------*/


/*--------------------------------------------------*/

#import "YandexMoney.h"

/*--------------------------------------------------*/

typedef void (^YandexMoneyLoginCallbackSuccess)(id accessToken);
typedef void (^YandexMoneyLoginCallbackFailure)(NSError* error);

/*--------------------------------------------------*/

@interface YandexMoneyLoginController : UIViewController< UIWebViewDelegate >
{
@protected
    NSString* mClientID;
    NSString* mRedirectURI;
    YandexMoneyScope mScope;
    NSString* mClientSecret;
    
@protected
    YandexMoneyLoginCallbackSuccess mSuccessCallback;
    YandexMoneyLoginCallbackFailure mFailureCallback;
}

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

+ (YandexMoneyLoginController*) controllerWithClientID:(NSString*)clientID
                                           redirectURI:(NSString*)redirectURI
                                                 scope:(YandexMoneyScope)scope
                                          clientSecret:(NSString*)clientSecret
                                       successCallback:(YandexMoneyLoginCallbackSuccess)successCallback
                                       failureCallback:(YandexMoneyLoginCallbackFailure)failureCallback;


- (id) initWithClientID:(NSString*)clientID
            redirectURI:(NSString*)redirectURI
                  scope:(YandexMoneyScope)scope
           clientSecret:(NSString*)clientSecret
        successCallback:(YandexMoneyLoginCallbackSuccess)successCallback
        failureCallback:(YandexMoneyLoginCallbackFailure)failureCallback;

@end

/*--------------------------------------------------*/

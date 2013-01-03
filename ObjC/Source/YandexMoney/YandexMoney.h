/*--------------------------------------------------*/

#import <Foundation/Foundation.h>

/*--------------------------------------------------*/

NSString* const YandexMoneyErrorDomain;

/*--------------------------------------------------*/

enum
{
    YandexMoneyErrorInternal,
    YandexMoneyErrorResponse
};
typedef NSUInteger YandexMoneyError;

/*--------------------------------------------------*/

enum
{
    YandexMoneyScopeNone = 0x0000, // Получение информации о состоянии счета.
    YandexMoneyScopeAccountInfo = 0x0001, // Получение информации о состоянии счета.
    YandexMoneyScopeOperationHistory = 0x0002, // Просмотр истории операций.
    YandexMoneyScopeOperationDetails = 0x0004, // Просмотр деталей операции.
    YandexMoneyScopePayment = 0x0008, // Возможность осуществлять платежи в конкретный магазин или переводить средства на конкретный счет пользователя.
    YandexMoneyScopePaymentShop = 0x0010, // Возможность осуществлять платежи во все доступные для API магазины.
    YandexMoneyScopePaymentP2P = 0x0020, // Возможность переводить средства на любые счета других пользователей.
    YandexMoneyScopeShoppingCart = 0x0040, // Оплата корзины товаров.
    YandexMoneyScopeMoneySourceWallet = 0x0080, // Проведения платежа через кошелек.
    YandexMoneyScopeMoneySourceCard = 0x0100 // Проведения платежа через привязанную карту.
};
typedef NSUInteger YandexMoneyScope;

/*--------------------------------------------------*/

enum
{
    YandexMoneyCurrencyUnknown = 0,
    YandexMoneyCurrencyRUB = 643 // Код валюты для рубля РФ
};
typedef NSUInteger YandexMoneyCurrency;

/*--------------------------------------------------*/

enum
{
    YandexMoneyAccountTypeUnknown,
    YandexMoneyAccountTypePersonal, // Счет пользователя системы "Яндекс.Деньги".
    YandexMoneyAccountTypeProfessional // Профессиональный счет в системе "Яндекс.Деньги".
};
typedef NSUInteger YandexMoneyAccountType;

/*--------------------------------------------------*/

enum
{
    YandexMoneyPaymentMoneySourceUnknown = 0x00,
    YandexMoneyPaymentMoneySourceWallet = 0x01, // Платеж со счета пользователя.
    YandexMoneyPaymentMoneySourceCard = 0x02 // Платеж с привязанной к счету банковской карты.
};
typedef NSUInteger YandexMoneyPaymentMoneySource;

/*--------------------------------------------------*/

enum
{
    YandexMoneyOperationDirectionUnknown,
    YandexMoneyOperationDirectionIn, // Направление движения средств (приход).
    YandexMoneyOperationDirectionOut // Направление движения средств (расход).
};
typedef NSUInteger YandexMoneyOperationDirection;

/*--------------------------------------------------*/

enum
{
    YandexMoneyIdentifierTypeUnknown,
    YandexMoneyIdentifierTypeAccount, // Тип идентификатора получателя платежа. Номер счета в системе Яндекс.Деньги.
    YandexMoneyIdentifierTypePhone // Тип идентификатора получателя платежа. Номер привязанного мобильного телефона.
};
typedef NSUInteger YandexMoneyIdentifierType;

/*--------------------------------------------------*/

enum
{
    YandexMoneyRecipientTypeUnknown,
    YandexMoneyRecipientTypeAccount, // Номер счета получателя в системе Яндекс.Деньги.
    YandexMoneyRecipientTypePhone, // Номер привязанного мобильного телефона получателя.
    YandexMoneyRecipientTypeEmail // E-mail получателя перевода.
};
typedef NSUInteger YandexMoneyRecipientType;

/*--------------------------------------------------*/

@class YandexMoneyPayment;
@class YandexMoneyPaymentP2P;
@class YandexMoneyOperation;
@class YandexMoneyOperations;

/*--------------------------------------------------*/

typedef void (^YandexMoneyCallbackLogin)(NSError* error);
typedef void (^YandexMoneyCallbackLogout)(NSError* error);
typedef void (^YandexMoneyCallbackAccountInfo)(NSError* error);
typedef void (^YandexMoneyCallbackReguestPaymentP2P)(YandexMoneyPaymentP2P* payment, NSError* error);
typedef void (^YandexMoneyCallbackProcessPaymentP2P)(YandexMoneyPaymentP2P* payment, NSError* error);
typedef void (^YandexMoneyCallbackHistory)(YandexMoneyOperations* operations, NSError* error);
typedef void (^YandexMoneyCallbackDetail)(YandexMoneyOperation* operation, NSError* error);

/*--------------------------------------------------*/

@interface YandexMoney : NSObject
{
@protected
    NSString* mClientID; // Идентификатор приложения, полученный при регистрации.
    NSString* mRedirectURI; // URI, на который OAuth сервер передает результат авторизации.
    YandexMoneyScope mScope; // Список запрашиваемых прав.
    NSString* mClientSecret; // Секретное слово для проверки подлинности приложения.
    
@protected
    NSString* mAccessToken; // Токен авторизации.
    
@protected
    NSString* mAccount; // Номер счета пользователя.
    NSNumber* mBalance; // Баланс счета пользователя.
    YandexMoneyCurrency mCurrency; // Код валюты счета пользователя.
    BOOL mIdentified; // Пользователь идентифицирован в системе.
    YandexMoneyAccountType mAccountType; // Тип счета пользователя.
}

@property(nonatomic, readwrite, retain) NSString* clientID;
@property(nonatomic, readwrite, retain) NSString* redirectURI;
@property(nonatomic, readwrite) YandexMoneyScope scope;
@property(nonatomic, readwrite, retain) NSString* clientSecret;
@property(nonatomic, readonly) NSString* authorizationCode;
@property(nonatomic, readonly) NSString* accessToken;
@property(nonatomic, readonly) NSString* account;
@property(nonatomic, readonly) NSNumber* balance;
@property(nonatomic, readonly) YandexMoneyCurrency currency;
@property(nonatomic, readonly) BOOL identified;
@property(nonatomic, readonly) YandexMoneyAccountType accountType;
@property(nonatomic, readonly) NSString* status;
@property(nonatomic, readonly) NSString* error;

+ (YandexMoney*) sharedYandexMoney;

- (BOOL) isLogin;

- (void) login:(UIViewController*)controller
      callback:(YandexMoneyCallbackLogin)callback;

- (void) logout:(YandexMoneyCallbackLogout)callback;

- (void) requestAccountInfo:(YandexMoneyCallbackAccountInfo)callback;

- (YandexMoneyPaymentP2P*) requestPaymentWithP2P:(NSString*)to
                               identifierType:(YandexMoneyIdentifierType)identifierType
                                       amount:(NSNumber*)amount
                                      comment:(NSString*)comment
                                      message:(NSString*)message
                                        label:(NSString*)label
                                     callback:(YandexMoneyCallbackReguestPaymentP2P)callback;

- (void) processPaymentP2P:(YandexMoneyPaymentP2P*)payment
          cardSecurityCode:(NSString*)cardSecurityCode
               moneySource:(YandexMoneyPaymentMoneySource)moneySource
                  callback:(YandexMoneyCallbackProcessPaymentP2P)callback;

- (void) requestHistoryWithDirection:(YandexMoneyOperationDirection)direction
                               label:(NSString*)label
                                from:(NSDate*)from
                                till:(NSDate*)till
                         startRecord:(NSNumber*)startRecord
                             records:(NSNumber*)records
                             details:(BOOL)details
                            callback:(YandexMoneyCallbackHistory)callback;

- (void) requestDetail:(NSString*)paymentID
              callback:(YandexMoneyCallbackDetail)callback;

+ (NSDateFormatter*) RFC3339SecondFormatter;
+ (NSDateFormatter*) RFC3339MillisecondFormatter;

@end

/*--------------------------------------------------*/

@interface YandexMoneyPayment : NSObject
{
@protected
    YandexMoney* mYandexMoney;
    
@protected
    NSString* mPatternID; // Идентификатор шаблона платежа.
    NSString* mStatus; // Код результата выполнения операции.
}

@property(nonatomic, readonly) NSString* patternID;
@property(nonatomic, readonly) NSString* status;
@property(nonatomic, readonly) NSString* error;

+ (YandexMoneyPayment*) paymentWithPatternID:(NSString*)patternID;

- (id) initWithPatternID:(NSString*)patternID;

- (void) setStatusWithJSON:(id)status;
- (BOOL) isStatusSuccess;
- (BOOL) isStatusRefused;

@end

/*--------------------------------------------------*/

@interface YandexMoneyPaymentP2P : YandexMoneyPayment
{
@protected
    NSString* mRequestTo; // Идентификатор получателя перевода.
    YandexMoneyIdentifierType mRequestIdentifierType; // Тип идентификатора получателя перевода.
    NSNumber* mRequestAmount; // Сумма перевода.
    NSString* mRequestComment; // Комментарий к переводу, отображается в истории отправителя.
    NSString* mRequestMessage; // Комментарий к переводу, отображается получателю.
    NSString* mRequestLabel; // Метка платежа. Необязательный параметр.
    
@protected
    NSString* mRequestID; // Идентификатор запроса платежа, сгенерированный системой.
    YandexMoneyPaymentMoneySource mRequestMoneySource; // Доступные для приложения методы проведения платежа.
    NSString* mRequestContract; // Текст описания платежа (контракт).
    NSNumber* mRequestBalance; // Текущий баланс счета пользователя.
    BOOL mRequestRecipientIdentified; // Идентифицирован ли получатель в системе "Яндекс.Деньги".
    NSString* mRequestRecipientAccountType; // Тип счета получателя в системе "Яндекс.Деньги".
       
@protected
    NSString* mPaymentID; // Идентификатор проведенного платежа.
    NSNumber* mPaymentBalance; // Баланс счета пользователя после проведения платежа.
    NSString* mPaymentInvoiceID; // Номер транзакции магазина в системе Яндекс.Деньги.
    NSString* mPaymentPayer; // Номер счета плательщика.
    NSString* mPaymentPayee; // Номер счета получателя.
    NSNumber* mPaymentCreditAmount; // Сумма, полученная на счет получателем.
    NSString* mPaymentPinSerial; // Серийный номер (открытая часть) ПИН-кода.
    NSString* mPaymentPinSecret; // Секрет (закрытая часть) ПИН-кода.
}

@property(nonatomic, readonly) NSString* requestTo;
@property(nonatomic, readonly) YandexMoneyIdentifierType requestIdentifierType;
@property(nonatomic, readonly) NSNumber* requestAmount;
@property(nonatomic, readonly) NSString* requestComment;
@property(nonatomic, readonly) NSString* requestMessage;
@property(nonatomic, readonly) NSString* requestLabel;
@property(nonatomic, readonly) NSString* requestID;
@property(nonatomic, readonly) YandexMoneyPaymentMoneySource requestMoneySource;
@property(nonatomic, readonly) NSString* requestContract;
@property(nonatomic, readonly) NSNumber* requestBalance;
@property(nonatomic, readonly) BOOL requestRecipientIdentified;
@property(nonatomic, readonly) NSString* requestRecipientAccountType;
@property(nonatomic, readonly) NSString* paymentCSC;
@property(nonatomic, readonly) YandexMoneyPaymentMoneySource paymentMoneySource;
@property(nonatomic, readonly) NSString* paymentID;
@property(nonatomic, readonly) NSNumber* paymentBalance;
@property(nonatomic, readonly) NSString* paymentInvoiceID;
@property(nonatomic, readonly) NSString* paymentPayer;
@property(nonatomic, readonly) NSString* paymentPayee;
@property(nonatomic, readonly) NSNumber* paymentCreditAmount;
@property(nonatomic, readonly) NSString* paymentPinSerial;
@property(nonatomic, readonly) NSString* paymentPinSecret;

+ (YandexMoneyPaymentP2P*) paymentWithTo:(NSString*)to
                          identifierType:(YandexMoneyIdentifierType)identifierType
                                  amount:(NSNumber*)amount
                                 comment:(NSString*)comment
                                 message:(NSString*)message
                                   label:(NSString*)label;

- (id) initWithPatternTo:(NSString*)to
          identifierType:(YandexMoneyIdentifierType)identifierType
                  amount:(NSNumber*)amount
                 comment:(NSString*)comment
                 message:(NSString*)message
                   label:(NSString*)label;

- (void) setRequestIDWithJSON:(id)requestID;
- (void) setRequestMoneySourceWithJSON:(id)requestMoneySource;
- (void) setRequestContractWithJSON:(id)requestContract;
- (void) setRequestBalanceWithJSON:(id)requestBalance;
- (void) setRequestRecipientIdentifiedWithJSON:(id)requestRecipientIdentified;
- (void) setRequestRecipientAccountTypeWithJSON:(id)requestRecipientAccountType;
- (void) setPaymentIDWithJSON:(id)paymentID;
- (void) setPaymentBalanceWithJSON:(id)paymentBalance;
- (void) setPaymentInvoiceIDWithJSON:(id)paymentInvoiceID;
- (void) setPaymentPayerWithJSON:(id)paymentPayer;
- (void) setPaymentPayeeWithJSON:(id)paymentPayee;
- (void) setPaymentCreditAmountWithJSON:(id)paymentCreditAmount;
- (void) setPaymentPinSerialWithJSON:(id)paymentPinSerial;
- (void) setPaymentPinSecretWithJSON:(id)paymentPinSecret;

@end

/*--------------------------------------------------*/

@interface YandexMoneyOperation : NSObject
{
@protected
    NSString* mPaymentID; // Идентификатор операции.
    NSString* mPatternID; // Идентификатор шаблона платежа, по которому совершен платеж.
    NSString* mStatus; // Статус платежа.
    YandexMoneyOperationDirection mDirection; // Направление движения средств.
    NSNumber* mAmount; // Сумма операции.
    NSDate* mDatetime; // Дата и время совершения операции.
    NSString* mTitle; // Краткое описание операции (название магазина или источник пополнения).
    NSString* mSender; // Номер счета отправителя перевода.
    NSString* mRecipient; // Идентификатор получателя перевода.
    YandexMoneyRecipientType mRecipientType; // Тип идентификатора получателя перевода.
    NSString* mMessage; // Сообщение получателю перевода.
    NSString* mComment; // Комментарий к переводу (для отправителя).
    BOOL mCodepro; // Перевод защищен кодом протекции.
    NSString* mLabel; // Метка платежа.
    NSString* mDetails; // Детальное описание платежа.
}

@property(nonatomic, readonly) NSString* paymentID;
@property(nonatomic, readonly) NSString* patternID;
@property(nonatomic, readonly) NSString* status;
@property(nonatomic, readonly) YandexMoneyOperationDirection direction;
@property(nonatomic, readonly) NSNumber* amount;
@property(nonatomic, readonly) NSDate* datetime;
@property(nonatomic, readonly) NSString* title;
@property(nonatomic, readonly) NSString* sender;
@property(nonatomic, readonly) NSString* recipient;
@property(nonatomic, readonly) YandexMoneyRecipientType recipientType;
@property(nonatomic, readonly) NSString* message;
@property(nonatomic, readonly) NSString* comment;
@property(nonatomic, readonly) BOOL codepro;
@property(nonatomic, readonly) NSString* label;
@property(nonatomic, readonly) NSString* details;

+ (YandexMoneyOperation*) operation;

- (void) setPaymentIDWithJSON:(id)paymentID;
- (void) setPatternIDWithJSON:(id)patternID;
- (void) setStatusWithJSON:(id)status;
- (void) setDirectionWithJSON:(id)direction;
- (void) setAmountWithJSON:(id)amount;
- (void) setDatetimeWithJSON:(id)datetime;
- (void) setTitleWithJSON:(id)title;
- (void) setSenderWithJSON:(id)sender;
- (void) setRecipientWithJSON:(id)recipient;
- (void) setRecipientTypeWithJSON:(id)recipientType;
- (void) setMessageWithJSON:(id)message;
- (void) setCommentWithJSON:(id)comment;
- (void) setCodeproWithJSON:(id)codepro;
- (void) setLabelWithJSON:(id)label;
- (void) setDetailsWithJSON:(id)details;

@end

/*--------------------------------------------------*/

@interface YandexMoneyOperations : NSObject
{
@protected
    NSMutableArray* mList; // Список операций.
}

@property(nonatomic, readonly) NSArray* list;

+ (YandexMoneyOperations*) operations;

- (void) addOperation:(YandexMoneyOperation*)operation;
- (void) removeOperation:(YandexMoneyOperation*)operation;
- (void) removeOperationByPaymentID:(NSString*)paymentID;
- (YandexMoneyOperation*) operationAtPaymentID:(NSString*)paymentID;
- (YandexMoneyOperation*) operationAt:(NSUInteger)index;

@end

/*--------------------------------------------------*/

extern YandexMoney * sharedYandexMoney;

/*--------------------------------------------------*/

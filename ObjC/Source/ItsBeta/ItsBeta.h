/*--------------------------------------------------*/

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

/*--------------------------------------------------*/

NSString* const ItsBetaErrorDomain;

/*--------------------------------------------------*/

enum
{
    ItsBetaErrorInternal,
    ItsBetaErrorResponse,
    ItsBetaErrorFacebookAuth,

};
typedef NSUInteger ItsBetaError;

/*--------------------------------------------------*/

enum
{
    ItsBetaUserTypeFacebook
};
typedef NSUInteger ItsBetaUserType;

/*--------------------------------------------------*/

@class ItsBetaUser;
@class ItsBetaImage;
@class ItsBetaCategory;
@class ItsBetaCategories;
@class ItsBetaProject;
@class ItsBetaProjects;
@class ItsBetaParams;
@class ItsBetaBadge;
@class ItsBetaBadges;
@class ItsBetaAchievement;
@class ItsBetaAchievements;

/*--------------------------------------------------*/

typedef void (^ItsBetaCallbackLogin)(NSError* error);
typedef void (^ItsBetaCallbackLogout)(NSError* error);
typedef void (^ItsBetaCallbackCategories)(ItsBetaCategories* categories, NSError* error);
typedef void (^ItsBetaCallbackProjects)(ItsBetaProjects* projects, NSError* error);
typedef void (^ItsBetaCallbackParams)(ItsBetaParams* params, NSError* error);
typedef void (^ItsBetaCallbackBadges)(ItsBetaBadges* badges, NSError* error);
typedef void (^ItsBetaCallbackAchievements)(ItsBetaAchievements* achievements, NSError* error);
typedef void (^ItsBetaCallbackCreateAchievement)(NSString* activateCode, NSError* error);
typedef void (^ItsBetaCallbackActivateAchievement)(ItsBetaAchievement* achievement, NSError* error);
typedef void (^ItsBetaCallbackLoadImage)(ItsBetaImage* image, NSError* error);

/*--------------------------------------------------*/

@interface ItsBeta : NSObject
{
@protected
    NSString* mServiceURL; // Базовый URL сервиса
    NSString* mAccessToken; // Уникальный ключ доступа
}

@property(nonatomic, readwrite, retain) NSString* serviceURL;
@property(nonatomic, readwrite, retain) NSString* accessToken;

+ (ItsBeta*) sharedItsBeta;

- (void) requestAllCategories:(ItsBetaCallbackCategories)callback;

- (void) requestProjectsByCategory:(ItsBetaCategory*)byCategory
                          callback:(ItsBetaCallbackProjects)callback;

- (void) requestParamsByProject:(ItsBetaProject*)byProject
                       callback:(ItsBetaCallbackParams)callback;

- (void) requestBadgesByProject:(ItsBetaProject*)byProject
                       callback:(ItsBetaCallbackBadges)callback;

- (void) requestAchievementsByUser:(ItsBetaUser*)byUser
                        byCategory:(ItsBetaCategory*)byCategory
                         byProject:(ItsBetaProject*)byProject
                          byBadges:(ItsBetaBadges*)byBadges
                          callback:(ItsBetaCallbackAchievements)callback;

- (void) requestAchievementsByUser:(ItsBetaUser*)byUser
                        byCategory:(ItsBetaCategory*)byCategory
                        byProjects:(ItsBetaProjects*)byProjects
                          byBadges:(ItsBetaBadges*)byBadges
                          callback:(ItsBetaCallbackAchievements)callback;

- (void) requestAchievementsByUser:(ItsBetaUser*)byUser
                      byCategories:(ItsBetaCategories*)byCategories
                        byProjects:(ItsBetaProjects*)byProjects
                          byBadges:(ItsBetaBadges*)byBadges
                          callback:(ItsBetaCallbackAchievements)callback;

- (void) requestCreateAchievementByBadge:(ItsBetaBadge*)byBadge
                                byParams:(NSDictionary*)byParams
                          byExternalCode:(NSString*)byExternalCode
                                callback:(ItsBetaCallbackCreateAchievement)callback;

- (void) requestActivateAchievementByUser:(ItsBetaUser*)byUser
                                  byBadge:(ItsBetaBadge*)byBadge
                           byActivateCode:(NSString*)byActivateCode
                           byExternalCode:(NSString*)byExternalCode
                                 callback:(ItsBetaCallbackActivateAchievement)callback;

@end

/*--------------------------------------------------*/

@interface ItsBetaUser : NSObject
{
@protected
    ItsBetaUserType mType; // Тип пользователя
    NSString* mID; // Уникальный ID пользователя
}

@property(nonatomic, readonly) ItsBetaUserType type;
@property(nonatomic, readonly) NSString* typeAsString;
@property(nonatomic, readonly) NSString* ID;

+ (ItsBetaUser*) userWithType:(ItsBetaUserType)type;

- (id) initWithType:(ItsBetaUserType)type;

- (BOOL) isLogin;
- (void) login:(ItsBetaCallbackLogin)callback;
- (void) logout:(ItsBetaCallbackLogout)callback;

+ (BOOL) handleOpenURL:(NSURL*)url;

@end

/*--------------------------------------------------*/

@interface ItsBetaImage : NSObject
{
@protected
    NSString* mFileName; // Удаленный путь до изображения
    NSString* mFileKey; // Локальный ключ изображения
#if TARGET_OS_IPHONE
    UIImage* mImageData;
#else
    NSImage* mImageData;
#endif
}

@property(nonatomic, readonly) NSString* fileName;
#if TARGET_OS_IPHONE
@property(nonatomic, readonly) UIImage* imageData;
#else
@property(nonatomic, readonly) NSImage* imageData;
#endif

+ (ItsBetaImage*) imageWithFileName:(NSString*)fileName;

- (id) initWithFileName:(NSString*)fileName;

- (void) loadWithOriginal:(ItsBetaCallbackLoadImage)callback;

@end

/*--------------------------------------------------*/

@interface ItsBetaCategory : NSObject
{
@protected
    NSString* mID; // Уникальный ID категории
    NSString* mName; // Имя категории
    NSString* mTitle; // Внешнее название категории
}

@property(nonatomic, readonly) NSString* ID;
@property(nonatomic, readonly) NSString* name;
@property(nonatomic, readonly) NSString* title;

+ (ItsBetaCategory*) categoryWithID:(NSString*)ID
                               name:(NSString*)name
                              title:(NSString*)title;

- (id) initWithID:(NSString*)ID
             name:(NSString*)name
            title:(NSString*)title;

@end

/*--------------------------------------------------*/

@interface ItsBetaCategories : NSObject
{
@protected
    NSMutableArray* mList; // Массив категорий
}

@property(nonatomic, readonly) NSArray* list;

+ (ItsBetaCategories*) categories;
+ (ItsBetaCategories*) categoriesWithCategory:(ItsBetaCategory*)category;

- (id) initWithCategory:(ItsBetaCategory*)category;

- (void) addCategory:(ItsBetaCategory*)category;
- (void) removeCategory:(ItsBetaCategory*)category;
- (void) removeCategoryByID:(NSString*)categoryID;
- (ItsBetaCategory*) categoryAtID:(NSString*)categoryID;
- (ItsBetaCategory*) categoryAt:(NSUInteger)index;

@end

/*--------------------------------------------------*/

@interface ItsBetaProject : NSObject
{
@protected
    NSString* mID; // Уникальный ID проекта
    NSString* mName; // Имя проекта
    NSString* mTitle; // заголовок проекта
    
@protected
    ItsBetaCategory* mCategory; // Указатель на категорию
}

@property(nonatomic, readonly) NSString* ID;
@property(nonatomic, readonly) NSString* name;
@property(nonatomic, readonly) NSString* title;

@property(nonatomic, readonly) ItsBetaCategory* category;

+ (ItsBetaProject*) projectWithID:(NSString*)ID
                             name:(NSString*)name
                            title:(NSString*)title
                         category:(ItsBetaCategory*)category;

- (id) initWithID:(NSString*)ID
             name:(NSString*)name
            title:(NSString*)title
         category:(ItsBetaCategory*)category;

@end

/*--------------------------------------------------*/

@interface ItsBetaProjects : NSObject
{
@protected
    NSMutableArray* mList; // Массив проектов
}

@property(nonatomic, readonly) NSArray* list;

+ (ItsBetaProjects*) projects;
+ (ItsBetaProjects*) projectsWithProject:(ItsBetaProject*)project;

- (id) initWithProject:(ItsBetaProject*)project;

- (void) addProject:(ItsBetaProject*)project;
- (void) removeProject:(ItsBetaProject*)project;
- (void) removeProjectByID:(NSString*)projectID;
- (ItsBetaProject*) projectAtID:(NSString*)projectID;
- (ItsBetaProject*) projectAt:(NSUInteger)index;

@end

/*--------------------------------------------------*/

typedef NSString ItsBetaParam;

/*--------------------------------------------------*/

@interface ItsBetaParams : NSObject
{
@protected
    NSString* mID; // Уникальный ID спика параметров
    NSArray* mKeys; // Массив параметров
}

@property(nonatomic, readonly) NSString* ID;
@property(nonatomic, readonly) NSArray* keys;

+ (ItsBetaParams*) paramsWithID:(NSString*)ID
                           keys:(NSArray*)keys;

- (id) initWithID:(NSString*)ID
             keys:(NSArray*)keys;

@end

/*--------------------------------------------------*/

@interface ItsBetaBadge : NSObject
{
@protected
    NSString* mID; // ID бейджа
    NSString* mName; // имя бейджа
    NSString* mTitle; // название бейджа
    NSString* mDescription; // описание бейджа
    NSString* mImageURL; // URL картинки бейджа
    
@protected
    ItsBetaProject* mProject; // Указатель на проект
    ItsBetaImage* mImage; // Указатель на изображение
}

@property(nonatomic, readonly) NSString* ID;
@property(nonatomic, readonly) NSString* name;
@property(nonatomic, readonly) NSString* title;
@property(nonatomic, readonly) NSString* description;
@property(nonatomic, readonly) NSString* imageURL;

@property(nonatomic, readonly) ItsBetaProject* project;
@property(nonatomic, readonly) ItsBetaImage* image;

+ (ItsBetaBadge*) badgeWithID:(NSString*)ID
                         name:(NSString*)name
                        title:(NSString*)title
                  description:(NSString*)description
                     imageURL:(NSString*)imageURL
                      project:(ItsBetaProject*)project;

- (id) initWithID:(NSString*)ID
             name:(NSString*)name
            title:(NSString*)title
      description:(NSString*)description
         imageURL:(NSString*)imageURL
          project:(ItsBetaProject*)project;

@end

/*--------------------------------------------------*/

@interface ItsBetaBadges : NSObject
{
@protected
    NSMutableArray* mList; // Массив бейджей
}

@property(nonatomic, readonly) NSArray* list;

+ (ItsBetaBadges*) badges;

- (void) addBadge:(ItsBetaBadge*)badge;
- (void) removeBadge:(ItsBetaBadge*)badge;
- (void) removeBadgeByID:(NSString*)badgeID;
- (ItsBetaBadge*) badgeAtID:(NSString*)badgeID;
- (ItsBetaBadge*) badgeAt:(NSUInteger)index;

@end

/*--------------------------------------------------*/

@interface ItsBetaAchievement : NSObject
{
@protected
    NSString* mID; // ID достижения
    NSString* mBadgeID; // ID бейджа
    NSString* mDetails; // Полное описание достижения (c учетом вставки параметров)
    BOOL mActivated; // Статус достижения
    
@protected
    ItsBetaUser* mUser; // Указатель на пользователя
    ItsBetaBadge* mBadge; // Указатель на бейдж
}

@property(nonatomic, readonly) NSString* ID;
@property(nonatomic, readonly) NSString* badgeID;
@property(nonatomic, readonly) NSString* details;
@property(nonatomic, readonly) BOOL activated;

@property(nonatomic, readonly) ItsBetaUser* user;
@property(nonatomic, readonly) ItsBetaBadge* badge;

+ (ItsBetaAchievement*) achievementWithID:(NSString*)ID
                                  badgeID:(NSString*)badgeID
                                  details:(NSString*)details
                                activated:(BOOL)activated
                                     user:(ItsBetaUser*)user
                                    badge:(ItsBetaBadge*)badge;

- (id) initWithID:(NSString*)ID
          badgeID:(NSString*)badgeID
          details:(NSString*)details
        activated:(BOOL)activated
             user:(ItsBetaUser*)user
            badge:(ItsBetaBadge*)badge;

@end

/*--------------------------------------------------*/

@interface ItsBetaAchievements : NSObject
{
@protected
    NSMutableArray* mList; // Массив достидений
}

@property(nonatomic, readonly) NSArray* list;

+ (ItsBetaAchievements*) achievements;

- (void) addAchievement:(ItsBetaAchievement*)achievement;
- (void) removeAchievement:(ItsBetaAchievement*)achievement;
- (void) removeAchievementByID:(NSString*)achievementID;
- (ItsBetaAchievement*) achievementAtID:(NSString*)achievementID;
- (ItsBetaAchievement*) achievementAt:(NSUInteger)index;

@end

/*--------------------------------------------------*/

extern ItsBeta * sharedItsBeta;

/*--------------------------------------------------*/

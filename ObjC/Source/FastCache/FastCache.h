/*--------------------------------------------------*/

#import <Foundation/Foundation.h>

/*--------------------------------------------------*/

#if TARGET_OS_IPHONE
#   import <UIKit/UIKit.h>
#endif

/*--------------------------------------------------*/

@interface FastCache : NSObject
{
@protected
	NSString* mDirectory;
    NSTimeInterval mDefaultTimeout;
    
@protected
	dispatch_queue_t mCacheInfoQueue;
	dispatch_queue_t mFrozenCacheInfoQueue;
	dispatch_queue_t mDiskQueue;
    
@protected
	NSMutableDictionary* mCacheInfo;
	NSMutableDictionary* mFrozenCacheInfo;
    
@protected
	BOOL mNeedsSave;
}

@property(nonatomic, assign) NSTimeInterval defaultTimeout;
@property(nonatomic, copy) NSDictionary* frozenCacheInfo;

+ (instancetype) sharedFastCache;

- (id) initWithCacheDirectory:(NSString*)cacheDirectory;

- (void) clearCache;

- (BOOL) hasCacheForKey:(NSString*)key;

- (void) removeCacheForKey:(NSString*)key;

- (NSData*) dataForKey:(NSString*)key;

- (void) setData:(NSData*)data
          forKey:(NSString*)key;

- (void) setData:(NSData*)data
          forKey:(NSString*)key
     withTimeout:(NSTimeInterval)timeout;

- (NSString*) stringForKey:(NSString*)key;

- (void) setString:(NSString*)aString
            forKey:(NSString*)key;

- (void) setString:(NSString*)aString
            forKey:(NSString*)key
       withTimeout:(NSTimeInterval)timeout;

#if TARGET_OS_IPHONE
- (UIImage*) imageForKey:(NSString*)key;

- (void) setImage:(UIImage*)anImage
           forKey:(NSString*)key;

- (void) setImage:(UIImage*)anImage
           forKey:(NSString*)key
      withTimeout:(NSTimeInterval)timeout;
#else
- (NSImage*) imageForKey:(NSString*)key;

- (void) setImage:(NSImage*)anImage
           forKey:(NSString*)key;

- (void) setImage:(NSImage*)anImage
           forKey:(NSString*)key
      withTimeout:(NSTimeInterval)timeout;
#endif

- (NSData*) plistForKey:(NSString*)key;

- (void) setPlist:(id)plistObject
           forKey:(NSString*)key;

- (void) setPlist:(id)plistObject
           forKey:(NSString*)key
      withTimeout:(NSTimeInterval)timeout;

- (void) copyFilePath:(NSString*)filePath
                asKey:(NSString*)key;

- (void) copyFilePath:(NSString*)filePath
                asKey:(NSString*)key
          withTimeout:(NSTimeInterval)timeout;

- (id< NSCoding >) objectForKey:(NSString*)key;

- (void) setObject:(id< NSCoding >)anObject
            forKey:(NSString*)key;

- (void) setObject:(id< NSCoding >)anObject
            forKey:(NSString*)key
       withTimeout:(NSTimeInterval)timeout;

@end

/*--------------------------------------------------*/

extern FastCache * sharedFastCache;

/*--------------------------------------------------*/

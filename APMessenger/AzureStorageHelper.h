#import <Foundation/Foundation.h>

@interface AzureStorageHelper : NSObject

+(void)createContainerWithName: (NSString*)name storageConnectionString:(NSString*)connectionString;
+(void)uploadBlobToContainerWithName:(NSString*)name data:(NSData*)data blobName:(NSString*)blobName storageConnectionString:(NSString*)connectionString;
+(NSData*)downloadBlobToDataWithName:(NSString*)blobName blobContainerName:(NSString*)blobContainerName storageConnectionString:(NSString*)connectionString;

@end

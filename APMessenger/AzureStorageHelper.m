//
//  AzureStorageHelper.m
//  APMessenger
//
//  Created by Elma Arslanagic on 3/7/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AzureStorageHelper.h"
#import <AZSClient/AZSClient.h>

@implementation AzureStorageHelper

//https://nameofyourstorageaccount.blob.core.windows.net/containerpublic/sampleblob

+(void)createContainerWithName: (NSString*)name storageConnectionString:(NSString*)connectionString{
    NSError *accountCreationError;
    
    // Create a storage account object from a connection string.
    AZSCloudStorageAccount *account = [AZSCloudStorageAccount accountFromConnectionString:connectionString error:&accountCreationError];
    
    if(accountCreationError){
        NSLog(@"Error in creating account.");
    }
    
    // Create a blob service client object.
    AZSCloudBlobClient *blobClient = [account getBlobClient];
    
    // Create a local container object.
    AZSCloudBlobContainer *blobContainer = [blobClient containerReferenceFromName:name];
    
    // Create container in your Storage account if the container doesn't already exist
    [blobContainer createContainerIfNotExistsWithCompletionHandler:^(NSError *error, BOOL exists) {
        if (error){
            NSLog(@"Error in creating container.");
        }
    }];
}


+(void)uploadBlobToContainerWithName:(NSString*)name data:(NSData*)data blobName:(NSString*)blobName storageConnectionString:(NSString*)connectionString{
    NSError *accountCreationError;
    
    // Create a storage account object from a connection string.
    AZSCloudStorageAccount *account = [AZSCloudStorageAccount accountFromConnectionString:connectionString error:&accountCreationError];
    
    if(accountCreationError){
        NSLog(@"Error in creating account.");
    }
    
    // Create a blob service client object.
    AZSCloudBlobClient *blobClient = [account getBlobClient];
    
    // Create a local container object.
    AZSCloudBlobContainer *blobContainer = [blobClient containerReferenceFromName:name];
    
    [blobContainer createContainerIfNotExistsWithAccessType:AZSContainerPublicAccessTypeContainer requestOptions:nil operationContext:nil completionHandler:^(NSError *error, BOOL exists)
     {
         if (error){
             NSLog(@"Error in creating container.");
         }
         else{
             // Create a local blob object
             AZSCloudBlockBlob *blockBlob = [blobContainer blockBlobReferenceFromName:blobName];
             
             // Upload blob to Storage
             [blockBlob uploadFromData:data completionHandler:^(NSError *error) {
                 if (error){
                     NSLog(@"Error in creating blob.");
                 }
             }];
         }
     }];
    
}


-(void)listBlobsInContainer{
    NSError *accountCreationError;
    
    // Create a storage account object from a connection string.
    AZSCloudStorageAccount *account = [AZSCloudStorageAccount accountFromConnectionString:@"DefaultEndpointsProtocol=https;AccountName=your_account_name_here;AccountKey=your_account_key_here" error:&accountCreationError];
    
    if(accountCreationError){
        NSLog(@"Error in creating account.");
    }
    
    // Create a blob service client object.
    AZSCloudBlobClient *blobClient = [account getBlobClient];
    
    // Create a local container object.
    AZSCloudBlobContainer *blobContainer = [blobClient containerReferenceFromName:@"containerpublic"];
    
    //List all blobs in container
    [self listBlobsInContainerHelper:blobContainer continuationToken:nil prefix:nil blobListingDetails:AZSBlobListingDetailsAll maxResults:-1 completionHandler:^(NSError *error) {
        if (error != nil){
            NSLog(@"Error in creating container.");
        }
    }];
}

//List blobs helper method
-(void)listBlobsInContainerHelper:(AZSCloudBlobContainer *)container continuationToken:(AZSContinuationToken *)continuationToken prefix:(NSString *)prefix blobListingDetails:(AZSBlobListingDetails)blobListingDetails maxResults:(NSUInteger)maxResults completionHandler:(void (^)(NSError *))completionHandler
{
    [container listBlobsSegmentedWithContinuationToken:continuationToken prefix:prefix useFlatBlobListing:YES blobListingDetails:blobListingDetails maxResults:maxResults completionHandler:^(NSError *error, AZSBlobResultSegment *results) {
        if (error)
        {
            completionHandler(error);
        }
        else
        {
            for (int i = 0; i < results.blobs.count; i++) {
                NSLog(@"%@",[(AZSCloudBlockBlob *)results.blobs[i] blobName]);
            }
            if (results.continuationToken)
            {
                [self listBlobsInContainerHelper:container continuationToken:results.continuationToken prefix:prefix blobListingDetails:blobListingDetails maxResults:maxResults completionHandler:completionHandler];
            }
            else
            {
                completionHandler(nil);
            }
        }
    }];
}

+(NSData*)downloadBlobToDataWithName:(NSString*)blobName blobContainerName:(NSString*)blobContainerName storageConnectionString:(NSString*)connectionString{
    NSError *accountCreationError;
    
    // Create a storage account object from a connection string.
    AZSCloudStorageAccount *account = [AZSCloudStorageAccount accountFromConnectionString:connectionString error:&accountCreationError];
    
    if(accountCreationError){
        NSLog(@"Error in creating account.");
    }
    
    // Create a blob service client object.
    AZSCloudBlobClient *blobClient = [account getBlobClient];
    
    // Create a local container object.
    AZSCloudBlobContainer *blobContainer = [blobClient containerReferenceFromName:blobContainerName];
    
    // Create a local blob object
    AZSCloudBlockBlob *blockBlob = [blobContainer blockBlobReferenceFromName:blobName];
    
    NSData* downloadedData;
    // Download blob
    [blockBlob downloadToDataWithCompletionHandler:^(NSError *error, NSData *data) {
        if (error) {
            NSLog(@"Error in downloading blob");
        }
        else{
            NSLog(@"%@",data);
        }
    }];
    
    return downloadedData;
}

-(void)deleteBlob{
    NSError *accountCreationError;
    
    // Create a storage account object from a connection string.
    AZSCloudStorageAccount *account = [AZSCloudStorageAccount accountFromConnectionString:@"DefaultEndpointsProtocol=https;AccountName=your_account_name_here;AccountKey=your_account_key_here" error:&accountCreationError];
    
    if(accountCreationError){
        NSLog(@"Error in creating account.");
    }
    
    // Create a blob service client object.
    AZSCloudBlobClient *blobClient = [account getBlobClient];
    
    // Create a local container object.
    AZSCloudBlobContainer *blobContainer = [blobClient containerReferenceFromName:@"containerpublic"];
    
    // Create a local blob object
    AZSCloudBlockBlob *blockBlob = [blobContainer blockBlobReferenceFromName:@"sampleblob1"];
    
    // Delete blob
    [blockBlob deleteWithCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"Error in deleting blob.");
        }
    }];
}


-(void)deleteContainer{
    NSError *accountCreationError;
    
    // Create a storage account object from a connection string.
    AZSCloudStorageAccount *account = [AZSCloudStorageAccount accountFromConnectionString:@"DefaultEndpointsProtocol=https;AccountName=your_account_name_here;AccountKey=your_account_key_here" error:&accountCreationError];
    
    if(accountCreationError){
        NSLog(@"Error in creating account.");
    }
    
    // Create a blob service client object.
    AZSCloudBlobClient *blobClient = [account getBlobClient];
    
    // Create a local container object.
    AZSCloudBlobContainer *blobContainer = [blobClient containerReferenceFromName:@"containerpublic"];
    
    // Delete container
    [blobContainer deleteContainerIfExistsWithCompletionHandler:^(NSError *error, BOOL success) {
        if(error){
            NSLog(@"Error in deleting container");
        }
    }];
}






@end

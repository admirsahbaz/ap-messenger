//
//  RestHelper.m
//  APMessenger
//
//  Created by Irvin Stevic on 1/17/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "RestHelper.h"

@implementation RestHelper


-(void)requestPath:(NSString *)path withData:(NSDictionary*)params andHttpMethod:(NSString*)method onCompletion:(RequestCompletionHandler)complete{
    NSOperationQueue *bgQueue = [[NSOperationQueue alloc] init];
    
    //NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:path]
    //                                              cachePolicy:NSURLCacheStorageAllowedInMemoryOnly                             timeoutInterval:10];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
                                                          delegate:self
                                                     delegateQueue:bgQueue];
    NSString *baseUrl = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"RestServiceUrl"];
    NSString *fullPath = [NSString stringWithFormat:@"%@%@", baseUrl, path];
    NSURL *urlPath = [NSURL URLWithString:fullPath];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlPath
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10];
    //[request setValue:self.misfitAccessToken forHTTPHeaderField:@"access_token"];
    [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"text/html" forHTTPHeaderField:@"Accept"];
    if(params)
        [request setHTTPBody:[self httpBodyForParameters:params]];
    
    [request setHTTPMethod:method];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                                        if(complete)
                                                            complete(data, error);
                                                    }];
    
    [postDataTask resume];
}

-(NSData *)httpBodyForParameters:(NSDictionary *)parameters{
    NSMutableArray *parametersArray = [NSMutableArray array];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * stop) {
        NSString *param = [NSString stringWithFormat:@"%@=%@", [self percentEscapeString:key], [self percentEscapeString:obj]];
        [parametersArray addObject:param];
    }];
    
    NSString *string = [parametersArray componentsJoinedByString:@"&"];
    
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

-(NSString *)percentEscapeString:(NSString *)string{
    NSCharacterSet *allowed = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-._~"];
    return [string stringByAddingPercentEncodingWithAllowedCharacters:allowed];
}

-(BOOL)checkLogin:(NSString*)username withPassword:(NSString*)password{
    return ([username isEqualToString: @"test@authoritypartners.com"] && [password isEqualToString:@"test"]);
}
@end

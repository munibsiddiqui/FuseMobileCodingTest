//
//  HttpClient.m
//  HttpClient
//
//  Created by Munib Siddiqui on 12/2/2016.
//  Copyright © 2016 Pro. All rights reserved.
//

#import "HttpClient.h"


@implementation HttpClient


+ (instancetype)sharedClient
{
    static HttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HttpClient alloc] initWithBaseURL:nil];
        _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
    });
    return _sharedClient;
}

+ (instancetype)sharedResponseDataClient
{
    static HttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HttpClient alloc] initWithBaseURL:nil];
        _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return _sharedClient;
}


+ (instancetype)sharedJSONClient
{
    static HttpClient *_sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        _sharedClient = [[HttpClient alloc] initWithBaseURL:nil];
        
        _sharedClient.requestSerializer.timeoutInterval = 3;
        
        _sharedClient.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        
        AFJSONResponseSerializer * response  = [AFJSONResponseSerializer serializer];
        response.removesKeysWithNullValues = YES;
        _sharedClient.responseSerializer = response;

        [_sharedClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSMutableSet* set = [NSMutableSet set];
        [set addObjectsFromArray:[_sharedClient.responseSerializer.acceptableContentTypes allObjects]];
        [set addObject:@"text/plain"];
        [set addObject:@"text/html"];
        [set addObject:@"application/json"];
        [set addObject:@"text/json"];
        [set addObject:@"text/javascript"];
        [_sharedClient.responseSerializer setAcceptableContentTypes:[set copy]];
        
    });
    return _sharedClient;
}



#pragma mark - Request---get/post

/**
 *  Network request for POST / GET
 *
 *  @param type         get / post
 *  @param urlString    Request end point
 *  @param paraments    Array of parameters
 *  @param success      Call back for success
 *  @param failure      Call back for Failure
 */
+(void)requestWithType:(HttpRequestType)type withBaseUrlString:(NSString *)BaseUrlString withUrlString:(NSString *)urlString withParaments:(id)paraments progress:(requestProgress)progress withSuccess:(requestSuccess)success withFailure:(requestFailure)failure {
    NSString *url;
    if (nil != urlString) {
        url = [NSString stringWithFormat:@"%@%@",BaseUrlString,[urlString isKindOfClass:[NSNull class]]? nil:urlString];
    }else{
        
        url = [NSString stringWithFormat:@"%@",BaseUrlString];
    }

    NSString *decodedURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    switch (type) {
        case HttpRequestTypeGet:
        {
            [[HttpClient sharedJSONClient] GET:decodedURL parameters:paraments progress:^(NSProgress * _Nonnull downloadProgress) {
                
                progress((float)downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                success(task,responseObject);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                failure(task,error);
            }];

    }
        case HttpRequestTypePost:
        {
            
            [[HttpClient sharedJSONClient] POST:decodedURL parameters:paraments progress:^(NSProgress * _Nonnull uploadProgress) {
                
                progress((float)uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                success(task,responseObject);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                failure(task,error);
            }];

        }
    }
}


+(NSURLSessionDownloadTask *)downloadWithURL:(NSString *)url
                                 savePathURL:(NSURL *)fileURL
                                    progress:(downloadProgress )progress
                                     success:(void (^)(NSURLResponse *response, NSURL *filePath))success
                                        fail:(void (^)(NSError *error))fail{


    NSURL *urlpath = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlpath];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDownloadTask *downloadtask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
        progress((float)downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        

        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {

        return [fileURL URLByAppendingPathComponent:[response suggestedFilename]];
    
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            fail(error);
        }else{
            success(response,filePath);
        }
    }];
    
    return downloadtask;
}


#pragma mark -  CancelAllRequest

/**
 *  Cancel all Request
 *  a finished (or canceled) operation is still given a chance to execute its completion block before it iremoved from the queue.
 */

+(void)cancelAllRequest
{
    [[HttpClient sharedJSONClient].operationQueue cancelAllOperations];
}



+(void)cancelHttpRequestWithRequestType:(NSString *)requestType requestUrlString:(NSString *)string
{
    
    NSError * error;
    
    NSString * urlToPeCanced = [[[[HttpClient sharedJSONClient].requestSerializer requestWithMethod:requestType URLString:string parameters:nil error:&error] URL] path];
    
    
    for (NSOperation * operation in [HttpClient sharedJSONClient].operationQueue.operations) {
        
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            
            BOOL hasMatchRequestType = [requestType isEqualToString:[[(NSURLSessionTask *)operation currentRequest] HTTPMethod]];
            
            BOOL hasMatchRequestUrlString = [urlToPeCanced isEqualToString:[[[(NSURLSessionTask *)operation currentRequest] URL] path]];
            
            if (hasMatchRequestType&&hasMatchRequestUrlString) {
                
                [operation cancel];
                
            }
        }
        
    }
}



@end

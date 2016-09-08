//
//  HttpClient.h
//  HttpClient
//
//  Created by Munib Siddiqui on 12/2/2016.
//  Copyright © 2016 Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking.h>

typedef NS_ENUM(NSInteger,HttpRequestType) {
    HttpRequestTypeGet = 0,
    HttpRequestTypePost = 1
};


/**Success block*/
typedef void (^requestSuccess)(NSURLSessionDataTask * task,id responseObject);
/**Failure block*/
typedef void (^requestFailure)(NSURLSessionDataTask * task, NSError * error);

typedef void(^requestProgress)(float progress);

typedef void(^downloadProgress)(float progress);


@interface HttpClient:AFHTTPSessionManager



+ (instancetype)sharedClient;
+ (instancetype)sharedResponseDataClient;
+ (instancetype)sharedJSONClient;


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
+(void)requestWithType:(HttpRequestType)type withBaseUrlString:(NSString *)BaseUrlString withUrlString:(NSString *)urlString withParaments:(id)paraments progress:(requestProgress)progress withSuccess:(requestSuccess)success withFailure:(requestFailure)failure;



+(NSURLSessionDownloadTask *)downloadWithURL:(NSString *)url
                                 savePathURL:(NSURL *)fileURL
                                    progress:(downloadProgress )progress
                                     success:(void (^)(NSURLResponse *response, NSURL *filePath))success
                                        fail:(void (^)(NSError *error))fail;

#pragma mark -  CancelAllRequest

/**
 *  Cancel all network requests
 *  a finished (or canceled) operation is still given a chance to execute its completion block before it iremoved from the queue.
 */

+(void)cancelAllRequest;
#pragma mark -  CancelSpecificRequest/
/**
 * Cancels a specified url request
 *
 *  @param requestType HttpRequestType
 *  @param string      end point url
 */

+(void)cancelHttpRequestWithRequestType:(NSString *)requestType requestUrlString:(NSString *)string;

@end

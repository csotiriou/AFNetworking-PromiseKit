/*
 The MIT License (MIT)
 
 Copyright (c) 2014 Christos Sotiriou
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */
#import <AFNetworking/AFNetworking.h>
#import <PromiseKit/PromiseKit.h>
#import <Promise.h>

static NSString *AFHTTPRequestOperationErrorKey =  @"afHTTPRequestOperationError";

@interface AFHTTPRequestOperation (Promises)
/**
 @brief Returns a new Promise with a ready to use AFHTTPRequestOperation inside.
 
 Returned objects in the Promise Completion:
 AFHTTPRequestOperation *operation, id responseObject
 */
- (PMKPromise *)promise;

/**
 @brief Returns a new Promise with a ready to use AFHTTPRequestOperation inside. The operation will immediately start
 */
- (PMKPromise *)promiseAndStartImmediately;


/**
 @brief Returns a new Promise with a ready to use AFHTTPRequestOperation inside
 
 If 'startImmediately is 'YES' then the operation will start immediately
 */
- (PMKPromise *)promiseByStartingImmediately:(BOOL)startImmediately;

/**
 @brief Executes immediately an AFHTTPRequestOperation by adding an operation set up with a NSURLRequest
 to the current queue (or to the main queue if there is no current queue
 */
+ (PMKPromise *)request:(NSURLRequest *)request;

/**
 @brief Executes immediately an AFHTTPRequestOperation by adding an operation set up with a NSURLRequest
 to the queue passed as the argument
 */
+ (PMKPromise *)request:(NSURLRequest *)request queue:(NSOperationQueue *)queue;
@end


@interface AFHTTPRequestOperationManager (Promises)

- (PMKPromise *)GET:(NSString *)URLString parameters:(id)parameters;
- (PMKPromise *)POST:(NSString *)URLString parameters:(id)parameters;
- (PMKPromise *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block;
- (PMKPromise *)PUT:(NSString *)URLString parameters:(id)parameters;
- (PMKPromise *)DELETE:(NSString *)URLString parameters:(id)parameters;
- (PMKPromise *)PATCH:(NSString *)URLString parameters:(id)parameters;
@end


@interface AFHTTPSessionManager (Promises)

- (PMKPromise *)dataTaskWithRequest:(NSURLRequest *)request;

- (PMKPromise *)uploadTaskWithRequest:(NSURLRequest *)request
                             fromFile:(NSURL *)fileURL
                             progress:(NSProgress * __autoreleasing *)progress;
- (PMKPromise *)uploadTaskWithRequest:(NSURLRequest *)request
                             fromData:(NSData *)bodyData
                             progress:(NSProgress * __autoreleasing *)progress;
- (PMKPromise *)uploadTaskWithStreamedRequest:(NSURLRequest *)request
                                     progress:(NSProgress * __autoreleasing *)progress;

- (PMKPromise *)downloadTaskWithRequest:(NSURLRequest *)request
                               progress:(NSProgress * __autoreleasing *)progress
                            destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination;
- (PMKPromise *)downloadTaskWithResumeData:(NSData *)resumeData
                                  progress:(NSProgress * __autoreleasing *)progress
                               destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination;


- (PMKPromise *)POST:(NSString *)urlString parameters:(id)parameters;
- (PMKPromise *)POST:(NSString *)urlString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block;
- (PMKPromise *)GET:(NSString *)urlString parameters:(id)parameters;
- (PMKPromise *)PUT:(NSString *)urlString parameters:(id)parameters;
- (PMKPromise *)HEAD:(NSString *)urlString parameters:(id)parameters;
- (PMKPromise *)PATCH:(NSString *)urlString parameters:(id)parameters;
- (PMKPromise *)DELETE:(NSString *)urlString parameters:(id)parameters;
@end
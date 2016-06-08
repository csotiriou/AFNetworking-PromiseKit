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


#define AFPromise AnyPromise
FOUNDATION_EXPORT const NSString *AFHTTPRequestOperationErrorKey;


#define kPMKAFResponseObjectKey @"responseObject"
#define kPMKAFResponseTaskKey @"task"
#define kPMKAFResponseOperationKey @"operation"

@interface AFHTTPSessionManager (Promises)

@property (nonatomic, assign) BOOL startTasksImmediately;

- (AFPromise *)POST:(NSString *)urlString parameters:(id)parameters;
- (AFPromise *)POST:(NSString *)urlString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block;
- (AFPromise *)GET:(NSString *)urlString parameters:(id)parameters;
- (AFPromise *)PUT:(NSString *)urlString parameters:(id)parameters;
- (AFPromise *)HEAD:(NSString *)urlString parameters:(id)parameters;
- (AFPromise *)PATCH:(NSString *)urlString parameters:(id)parameters;
- (AFPromise *)DELETE:(NSString *)urlString parameters:(id)parameters;


/**
 *  Returns a Promise, with a ready-to-use data task, by performing the corresponding operation to the default AFHTTPSessionManager. 
 *  WARNING: The default behaviour of the task is NOT to run immediately.
 *  You must call '-resume' to the pointer in order to actually make the request. If you want to change this behaviour, set
 *  'startTasksImmediately' to YES
 *
 *  @param request the request to perform
 *  @param task Pass a pointer to the task, in order to have the task returned to this pointer.
 *
 *  @return a Promise.
 */
- (AFPromise *)dataTaskWithRequest:(NSURLRequest *)request
                               task:(NSURLSessionTask * __autoreleasing *)task;

/**
 *  Returns a Promise, with a ready-to-use data task, by performing the corresponding operation to the default AFHTTPSessionManager.
 *  WARNING: The default behaviour of the task is NOT to run immediately.
 *  You must call '-resume' to the pointer in order to actually make the request. If you want to change this behaviour, set
 *  'startTasksImmediately' to YES
 *
 *  @param request
 *  @param fileURL
 *  @param progress
 *  @param uploadTask
 *
 *  @return a Promise
 */
- (AFPromise *)uploadTaskWithRequest:(NSURLRequest *)request
                             fromFile:(NSURL *)fileURL
                             progress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                           uploadTask:(NSURLSessionTask * __autoreleasing *)uploadTask;

/**
 *  Returns a Promise, with a ready-to-use data task, by performing the corresponding operation to the default AFHTTPSessionManager.
 *  WARNING: The default behaviour of the task is NOT to run immediately.
 *  You must call '-resume' to the pointer in order to actually make the request. If you want to change this behaviour, set
 *  'startTasksImmediately' to YES
 *
 *  @param request
 *  @param bodyData
 *  @param progress
 *  @param uploadTask
 *
 *  @return
 */
- (AFPromise *)uploadTaskWithRequest:(NSURLRequest *)request
                             fromData:(NSData *)bodyData
                             progress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                           uploadTask:(NSURLSessionTask * __autoreleasing *)uploadTask;

/**
 *  Returns a Promise, with a ready-to-use data task, by performing the corresponding operation to the default AFHTTPSessionManager.
 *  WARNING: The default behaviour of the task is NOT to run immediately.
 *  You must call '-resume' to the pointer in order to actually make the request. If you want to change this behaviour, set
 *  'startTasksImmediately' to YES
 *
 *  @param request
 *  @param progress
 *  @param uploadTask
 *
 *  @return
 */
- (AFPromise *)uploadTaskWithStreamedRequest:(NSURLRequest *)request
                                     progress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                                   uploadTask:(NSURLSessionTask * __autoreleasing *)uploadTask;

/**
 *  Returns a Promise, with a ready-to-use data task, by performing the corresponding operation to the default AFHTTPSessionManager.
 *  WARNING: The default behaviour of the task is NOT to run immediately.
 *  You must call '-resume' to the pointer in order to actually make the request. If you want to change this behaviour, set
 *  'startTasksImmediately' to YES
 *
 *  @param request
 *  @param progress
 *  @param destination
 *  @param downloadTask
 *
 *  @return
 */
- (AFPromise *)downloadTaskWithRequest:(NSURLRequest *)request
                               progress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                            destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                           downloadTask:(NSURLSessionTask * __autoreleasing *)downloadTask;

/**
 *  Returns a Promise, with a ready-to-use data task, by performing the corresponding operation to the default AFHTTPSessionManager.
 *  WARNING: The default behaviour of the task is NOT to run immediately.
 *  You must call '-resume' to the pointer in order to actually make the request. If you want to change this behaviour, set
 *  'startTasksImmediately' to YES
 *
 *  @param resumeData
 *  @param progress
 *  @param destination
 *  @param downloadTask
 *
 *  @return
 */
- (AFPromise *)downloadTaskWithResumeData:(NSData *)resumeData
                                  progress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                               destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                              downloadTask:(NSURLSessionTask * __autoreleasing *)downloadTask;



/**
* @brief Performs a GET request on multiple URLs. It uses 'when' under the hood
*
* The parameters to be passed on URLs are given using an the associative array in 'parametersArray'. If you want to pass 'nil' as parameters, pass
*   an empty NSDictionary instead.
*
* When all requests are finished a 'then(^(NSArray *responsesArray){})' will return an array with NSDictionaries. Each one will have two values:
* -- kPMKAFResponseObjectKey --> The response Object of the request
* -- kPMKAFResponseTaskKey --> The task that initiated the request
*
* @param urlStringsArray an array of relative URL Strings
* @param parametersArray an associative array of parameters to be passed to their corresponding
*   URL strings (will be associated by their position in the array, so make sure they match)
*/
- (AFPromise *)GETMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray;


/**
* @brief Performs a PUT request on multiple URLs. It uses 'when' under the hood
*
* The parameters to be passed on URLs are given using an the associative array in 'parametersArray'. If you want to pass 'nil' as parameters, pass
*   an empty NSDictionary instead.
*
* When all requests are finished a 'then(^(NSArray *responsesArray){})' will return an array with NSDictionaries. Each one will have two values:
* -- kPMKAFResponseObjectKey --> The response Object of the request
* -- kPMKAFResponseTaskKey --> The task that initiated the request
*
* @param urlStringsArray an array of relative URL Strings
* @param parametersArray an associative array of parameters to be passed to their corresponding
*   URL strings (will be associated by their position in the array, so make sure they match)
*/
- (AFPromise *)PUTMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray;

/**
* @brief Performs a HEAD request on multiple URLs. It uses 'when' under the hood
*
* The parameters to be passed on URLs are given using an the associative array in 'parametersArray'. If you want to pass 'nil' as parameters, pass
*   an empty NSDictionary instead.
*
* When all requests are finished a 'then(^(NSArray *responsesArray){})' will return an array with NSDictionaries. Each one will have two values:
* -- kPMKAFResponseObjectKey --> The response Object of the request
* -- kPMKAFResponseTaskKey --> The task that initiated the request
*
* @param urlStringsArray an array of relative URL Strings
* @param parametersArray an associative array of parameters to be passed to their corresponding
*   URL strings (will be associated by their position in the array, so make sure they match)
*/
- (AFPromise *)HEADMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray;

/**
* @brief Performs a PATCH request on multiple URLs. It uses 'when' under the hood
*
* The parameters to be passed on URLs are given using an the associative array in 'parametersArray'. If you want to pass 'nil' as parameters, pass
*   an empty NSDictionary instead.
*
* When all requests are finished a 'then(^(NSArray *responsesArray){})' will return an array with NSDictionaries. Each one will have two values:
* -- kPMKAFResponseObjectKey --> The response Object of the request
* -- kPMKAFResponseTaskKey --> The task that initiated the request
*
* @param urlStringsArray an array of relative URL Strings
* @param parametersArray an associative array of parameters to be passed to their corresponding
*   URL strings (will be associated by their position in the array, so make sure they match)
*/
- (AFPromise *)PATCHMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray;


/**
* @brief Performs a DELETE request on multiple URLs. It uses 'when' under the hood
*
* The parameters to be passed on URLs are given using an the associative array in 'parametersArray'. If you want to pass 'nil' as parameters, pass
*   an empty NSDictionary instead.
*
* When all requests are finished a 'then(^(NSArray *responsesArray){})' will return an array with NSDictionaries. Each one will have two values:
* -- kPMKAFResponseObjectKey --> The response Object of the request
* -- kPMKAFResponseTaskKey --> The task that initiated the request
*
* @param urlStringsArray an array of relative URL Strings
* @param parametersArray an associative array of parameters to be passed to their corresponding
*   URL strings (will be associated by their position in the array, so make sure they match)
*/
- (AFPromise *)DELETEMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray;

@end

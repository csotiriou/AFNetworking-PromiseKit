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
#import <PromiseKit/AnyPromise.h>


#define AFPromise AnyPromise
FOUNDATION_EXPORT const NSString *AFHTTPRequestOperationErrorKey;


#define kPMKAFResponseObjectKey @"responseObject"
#define kPMKAFResponseTaskKey @"task"
#define kPMKAFResponseOperationKey @"operation"


@interface AFHTTPRequestOperation (Promises)
/**
 @brief Returns a new Promise with a ready to use AFHTTPRequestOperation inside.
 
 Returned objects in the Promise Completion:
 AFHTTPRequestOperation *operation, id responseObject
 */
- (AFPromise *)promise;

/**
 @brief Returns a new Promise with a ready to use AFHTTPRequestOperation inside. The operation will immediately start
 */
- (AFPromise *)promiseAndStartImmediately;


/**
 @brief Returns a new Promise with a ready to use AFHTTPRequestOperation inside
 
 If 'startImmediately is 'YES' then the operation will start immediately
 */
- (AFPromise *)promiseByStartingImmediately:(BOOL)startImmediately;

/**
 @brief Executes immediately an AFHTTPRequestOperation by adding an operation set up with a NSURLRequest
 to the current queue (or to the main queue if there is no current queue
 */
+ (AFPromise *)request:(NSURLRequest *)request;

/**
 @brief Executes immediately an AFHTTPRequestOperation by adding an operation set up with a NSURLRequest
 to the queue passed as the argument
 */
+ (AFPromise *)request:(NSURLRequest *)request queue:(NSOperationQueue *)queue;
@end


@interface AFHTTPRequestOperationManager (Promises)

- (AFPromise *)GET:(NSString *)URLString parameters:(id)parameters;
- (AFPromise *)POST:(NSString *)URLString parameters:(id)parameters;
- (AFPromise *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block;
- (AFPromise *)PUT:(NSString *)URLString parameters:(id)parameters;
- (AFPromise *)DELETE:(NSString *)URLString parameters:(id)parameters;
- (AFPromise *)HEAD:(NSString *)URLString parameters:(id)parameters;



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


@interface AFHTTPSessionManager (Promises)


- (AFPromise *)POST:(NSString *)urlString parameters:(id)parameters;
- (AFPromise *)POST:(NSString *)urlString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block;
- (AFPromise *)GET:(NSString *)urlString parameters:(id)parameters;
- (AFPromise *)PUT:(NSString *)urlString parameters:(id)parameters;
- (AFPromise *)HEAD:(NSString *)urlString parameters:(id)parameters;
- (AFPromise *)PATCH:(NSString *)urlString parameters:(id)parameters;
- (AFPromise *)DELETE:(NSString *)urlString parameters:(id)parameters;


- (AFPromise *)dataTaskWithRequest:(NSURLRequest *)request
                               task:(NSURLSessionTask * __autoreleasing *)task;

- (AFPromise *)uploadTaskWithRequest:(NSURLRequest *)request
                             fromFile:(NSURL *)fileURL
                             progress:(NSProgress * __autoreleasing *)progress
                           uploadTask:(NSURLSessionTask * __autoreleasing *)uploadTask;
- (AFPromise *)uploadTaskWithRequest:(NSURLRequest *)request
                             fromData:(NSData *)bodyData
                             progress:(NSProgress * __autoreleasing *)progress
                           uploadTask:(NSURLSessionTask * __autoreleasing *)uploadTask;
- (AFPromise *)uploadTaskWithStreamedRequest:(NSURLRequest *)request
                                     progress:(NSProgress * __autoreleasing *)progress
                                   uploadTask:(NSURLSessionTask * __autoreleasing *)uploadTask;

- (AFPromise *)downloadTaskWithRequest:(NSURLRequest *)request
                               progress:(NSProgress * __autoreleasing *)progress
                            destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                           downloadTask:(NSURLSessionTask * __autoreleasing *)downloadTask;
- (AFPromise *)downloadTaskWithResumeData:(NSData *)resumeData
                                  progress:(NSProgress * __autoreleasing *)progress
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
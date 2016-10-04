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

#import "AFNetworking+PromiseKit.h"
#import <objc/runtime.h>


const NSString *AFHTTPRequestOperationErrorKey =  @"afHTTPRequestOperationError";
static char AFHTTP_startTasksImmediately_PROPERTY_KEY;

typedef enum {
    AF_OPERATION_POST,
    AF_OPERATION_GET,
    AF_OPERATION_PATCH,
    AF_OPERATION_DELETE,
    AF_OPERATION_HEAD,
    AF_OPERATION_PUT
} AF_OPERATION_KIND;

@implementation AFHTTPSessionManager (Promises)
@dynamic startTasksImmediately;

- (void)setStartTasksImmediately:(BOOL)startTasksImmediately
{
    objc_setAssociatedObject(self, &AFHTTP_startTasksImmediately_PROPERTY_KEY, @(startTasksImmediately), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)startTasksImmediately
{
    NSNumber *booleanNumber =  objc_getAssociatedObject(self, &AFHTTP_startTasksImmediately_PROPERTY_KEY);
    return booleanNumber.boolValue;
}

- (NSURLSessionTask *__autoreleasing *)pointerToTaskFromTask:(NSURLSessionTask * __autoreleasing *)task {
    // create a pointer to a task, since we can't have a nil value
    if (!task) {
        NSURLSessionTask *__autoreleasing pointer;
        NSURLSessionTask *__autoreleasing *replacement = &pointer;
        task = replacement;
    }
    return task;
}

- (AFPromise *)dataTaskWithRequest:(NSURLRequest *)request
                              task:(NSURLSessionTask * __autoreleasing *)task
{
    task = [self pointerToTaskFromTask:task];
    return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                resolve(error);
            }
            else {
                resolve(PMKManifold(response, responseObject));
            }
        }];
        if (self.startTasksImmediately) [*task resume];
    }];
}

- (AFPromise *)uploadTaskWithRequest:(NSURLRequest *)request
                            fromFile:(NSURL *)fileURL
                            progress:(NSProgress * __autoreleasing *) uploadProgressBlock
                          uploadTask:(NSURLSessionTask * __autoreleasing *)uploadTask
{
    uploadTask = [self pointerToTaskFromTask:uploadTask];
    return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        *uploadTask = [self uploadTaskWithRequest:request fromFile:fileURL progress:uploadProgressBlock completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                resolve(error);
            }
            else {
                resolve(PMKManifold(response, responseObject));
            }
        }];
        if (self.startTasksImmediately) [*uploadTask resume];;
    }];
}

- (AFPromise *)uploadTaskWithRequest:(NSURLRequest *)request
                            fromData:(NSData *)bodyData
                            progress:(NSProgress * __autoreleasing *)uploadProgressBlock
                          uploadTask:(NSURLSessionTask * __autoreleasing *)uploadTask
{
    uploadTask = [self pointerToTaskFromTask:uploadTask];
    return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        *uploadTask = [self uploadTaskWithRequest:request fromData:bodyData progress:uploadProgressBlock completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                resolve(error);
            }
            else {
                resolve(PMKManifold(response, responseObject));
            }
        }];
        if (self.startTasksImmediately) [*uploadTask resume];
    }];
}

- (AFPromise *)uploadTaskWithStreamedRequest:(NSURLRequest *)request
                                    progress:(NSProgress * __autoreleasing *) uploadProgressBlock
                                  uploadTask:(NSURLSessionTask * __autoreleasing *)uploadTask
{
    uploadTask = [self pointerToTaskFromTask:uploadTask];
    return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        *uploadTask = [self uploadTaskWithStreamedRequest:request progress:uploadProgressBlock completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                resolve(error);
            }
            else {
                resolve(PMKManifold(response, responseObject));
            }
        }];
        if (self.startTasksImmediately) [*uploadTask resume];
    }];
}

- (AFPromise *)downloadTaskWithRequest:(NSURLRequest *)request
                              progress:(NSProgress * __autoreleasing *)uploadProgressBlock
                           destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                          downloadTask:(NSURLSessionTask * __autoreleasing *)downloadTask
{
    downloadTask = [self pointerToTaskFromTask:downloadTask];
    return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        
        *downloadTask = [self downloadTaskWithRequest:request progress:uploadProgressBlock destination:destination completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            if (error) {
                resolve(error);
            }
            else {
                resolve(PMKManifold(response, filePath));
            }
        }];
        if (self.startTasksImmediately) [*downloadTask resume];
    }];
}

- (AFPromise *)downloadTaskWithResumeData:(NSData *)resumeData
                                 progress:(NSProgress * __autoreleasing *)uploadProgressBlock
                              destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                             downloadTask:(NSURLSessionTask * __autoreleasing *)downloadTask
{
    downloadTask = [self pointerToTaskFromTask:downloadTask];
    return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        *downloadTask = [self downloadTaskWithResumeData:resumeData progress:uploadProgressBlock destination:destination completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            if (error) {
                resolve(error);
            }
            else {
                resolve(PMKManifold(response, filePath));
            }
        }];
        if (self.startTasksImmediately) [*downloadTask resume];
    }];
}


- (AFPromise *)POST:(NSString *)urlString parameters:(id)parameters
{
    return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        [[self POST:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            resolve(PMKManifold(responseObject, task));
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            resolve(error);
        }] resume];
    }];
}

- (AFPromise *)POSTMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
    return [self operationSequenceWithType:AF_OPERATION_POST urls:urlStringsArray parameters:parametersArray];
}

- (AFPromise *)POST:(NSString *)urlString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
{
    return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        [[self POST:urlString parameters:parameters constructingBodyWithBlock:block success:^(NSURLSessionDataTask *task, id responseObject) {
            resolve(PMKManifold(responseObject, task));
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }] resume];
    }];
}


- (AFPromise *)GET:(NSString *)urlString parameters:(id)parameters
{
    return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        
        [[self GET:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            resolve(PMKManifold(responseObject, task));
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }] resume];
    }];
}

- (AFPromise *)GETMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
    return [self operationSequenceWithType:AF_OPERATION_GET urls:urlStringsArray parameters:parametersArray];
}


- (AFPromise *)PUT:(NSString *)urlString parameters:(id)parameters
{
    return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        [[self PUT:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            resolve(PMKManifold(responseObject, task));
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }] resume];
    }];
}

- (AFPromise *)PUTMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
    return [self operationSequenceWithType:AF_OPERATION_PUT urls:urlStringsArray parameters:parametersArray];
}

- (AFPromise *)HEAD:(NSString *)urlString parameters:(id)parameters
{
    return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        [[self HEAD:urlString parameters:parameters success:^(NSURLSessionDataTask *task) {
            resolve(task);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }] resume];
    }];
}

- (AFPromise *)HEADMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
    return [self operationSequenceWithType:AF_OPERATION_HEAD urls:urlStringsArray parameters:parametersArray];
}

- (AFPromise *)PATCH:(NSString *)urlString parameters:(id)parameters
{
    return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        [[self PATCH:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            resolve(PMKManifold(responseObject, task));
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }] resume];
    }];
}

- (AFPromise *)PATCHMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
    return [self operationSequenceWithType:AF_OPERATION_PATCH urls:urlStringsArray parameters:parametersArray];
}



- (AFPromise *)DELETE:(NSString *)urlString parameters:(id)parameters
{
    return [AFPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        [[self DELETE:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            resolve(PMKManifold(responseObject, task));
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }] resume];
    }];
}

- (AFPromise *)DELETEMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
    return [self operationSequenceWithType:AF_OPERATION_DELETE urls:urlStringsArray parameters:parametersArray];
}




- (AFPromise *)operationSequenceWithType:(AF_OPERATION_KIND)operationKind urls:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
    assert (urlStringsArray.count == parametersArray.count);
    NSMutableArray *operations = [NSMutableArray array];
    
    for (int i=0; i<urlStringsArray.count; i++){
        NSString *urlString = urlStringsArray[i];
        NSDictionary *parameters = parametersArray[i];
        
        AFPromise *p = [self promiseForNetworkOperation:operationKind withURL:urlString andParameters:parameters];
        
        [operations addObject:p.then(^(id responseObject, NSURLSessionDataTask *task){
            return [AFPromise promiseWithValue:@{kPMKAFResponseObjectKey : responseObject, kPMKAFResponseTaskKey : task}];
        })];
    }
    
    return PMKWhen(operations);
}



- (AFPromise *)promiseForNetworkOperation:(AF_OPERATION_KIND)operationKind withURL:(NSString *)urlString andParameters:(id)parameters
{
    switch (operationKind) {
        case AF_OPERATION_GET:
            return [self GET:urlString parameters:parameters];
        case AF_OPERATION_DELETE:
            return [self DELETE:urlString parameters:parameters];
        case AF_OPERATION_PATCH:
            return [self PATCH:urlString parameters:parameters];
        case AF_OPERATION_POST:
            return [self POST:urlString parameters:parameters];
        case AF_OPERATION_PUT:
            return [self PUT:urlString parameters:parameters];
        case AF_OPERATION_HEAD:
            return [self HEAD:urlString parameters:parameters];
        default:
            break;
    }
    return nil;
}




@end




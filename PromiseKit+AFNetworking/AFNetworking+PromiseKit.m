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
#import <PromiseKit/Promise+When.h>

typedef enum {
	AF_OPERATION_POST,
	AF_OPERATION_GET,
	AF_OPERATION_PATCH,
	AF_OPERATION_DELETE,
	AF_OPERATION_HEAD,
	AF_OPERATION_PUT
} AF_OPERATION_KIND;

@implementation AFHTTPRequestOperation (Promises)

- (PMKPromise *)promise
{
	return [self promiseByStartingImmediately:NO];
}

- (PMKPromise *)promiseAndStartImmediately
{
	return [self promiseByStartingImmediately:YES];
}

- (PMKPromise *)promiseByStartingImmediately:(BOOL)startImmediately
{
	return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter){
		[self setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
			fulfiller(PMKManifold(responseObject, operation));
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			id info = error.userInfo.mutableCopy;
			info[AFHTTPRequestOperationErrorKey] = operation;
			id newerror = [NSError errorWithDomain:error.domain code:error.code userInfo:info];
			rejecter(newerror);
		}];
		if (startImmediately) {
			[self start];
		}
	}];
}

+ (PMKPromise *)request:(NSURLRequest *)request
{
	NSOperationQueue *q = [NSOperationQueue currentQueue] ? : [NSOperationQueue mainQueue];
	return [self request:request queue:q];
}

+ (PMKPromise *)request:(NSURLRequest *)request queue:(NSOperationQueue *)queue
{
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[queue addOperation:operation];
	return [operation promise];
}

@end



@implementation AFHTTPRequestOperationManager (Promises)

- (PMKPromise *)POST:(NSString *)URLString parameters:(id)parameters
{
	return [[self POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {} failure:^(AFHTTPRequestOperation *operation, NSError *error) {}] promise];
}

- (PMKPromise *)POSTMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
    return [self operationSequenceWithType:AF_OPERATION_POST urls:urlStringsArray parameters:parametersArray];
}


- (PMKPromise *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
{
	return [[self POST:URLString parameters:parameters constructingBodyWithBlock:block success:nil failure:nil] promise];
}

- (PMKPromise *)GET:(NSString *)URLString parameters:(id)parameters
{
	return [[self GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {} failure:^(AFHTTPRequestOperation *operation, NSError *error) {}] promise];
}

- (PMKPromise *)GETMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
    return [self operationSequenceWithType:AF_OPERATION_GET urls:urlStringsArray parameters:parametersArray];
}

- (PMKPromise *)PUT:(NSString *)URLString parameters:(id)parameters;
{
	return [[self PUT:URLString parameters:parameters success:nil failure:nil] promise];
}

- (PMKPromise *)PUTMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
    return [self operationSequenceWithType:AF_OPERATION_PUT urls:urlStringsArray parameters:parametersArray];
}

- (PMKPromise *)DELETE:(NSString *)URLString parameters:(id)parameters
{
	return [[self DELETE:URLString parameters:parameters success:nil failure:nil] promise];
}

- (PMKPromise *)DELETEMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
    return [self operationSequenceWithType:AF_OPERATION_DELETE urls:urlStringsArray parameters:parametersArray];
}


- (PMKPromise *)PATCH:(NSString *)URLString parameters:(id)parameters
{
	return [[self PATCH:URLString parameters:parameters success:nil failure:nil] promise];
}

- (PMKPromise *)PATCHMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
    return [self operationSequenceWithType:AF_OPERATION_PATCH urls:urlStringsArray parameters:parametersArray];
}


- (PMKPromise *)HEAD:(NSString *)URLString parameters:(id)parameters
{
    return [[self HEAD:URLString parameters:parameters success:nil failure:nil] promise];
}

- (PMKPromise *)HEADMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
    return [self operationSequenceWithType:AF_OPERATION_HEAD urls:urlStringsArray parameters:parametersArray];
}


- (PMKPromise *)operationSequenceWithType:(AF_OPERATION_KIND)operationKind urls:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
    assert (urlStringsArray.count == parametersArray.count);
    NSMutableArray *operations = [NSMutableArray array];

    for (int i=0; i<urlStringsArray.count; i++){
        NSString *urlString = urlStringsArray[i];
        NSDictionary *parameters = parametersArray[i];

        PMKPromise *p = [self promiseForNetworkOperation:operationKind withURL:urlString andParameters:parameters];

        [operations addObject:p.then(^(id responseObject, AFHTTPRequestOperation *operation){
            return [PMKPromise promiseWithValue:@{kPMKAFResponseObjectKey : responseObject, kPMKAFResponseOperationKey : operation}];
        })];
    }

    return [PMKPromise when:operations];
}



- (PMKPromise *)promiseForNetworkOperation:(AF_OPERATION_KIND)operationKind withURL:(NSString *)urlString andParameters:(id)parameters
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



@implementation AFHTTPSessionManager (Promises)

- (NSURLSessionTask *__autoreleasing *)pointerToTaskFromTask:(NSURLSessionTask * __autoreleasing *)task {
  // create a pointer to a task, since we can't have a nil value
  if (!task) {
    NSURLSessionTask *__autoreleasing pointer;
    NSURLSessionTask *__autoreleasing *replacement = &pointer;
    task = replacement;
  }
  return task;
}

- (PMKPromise *)dataTaskWithRequest:(NSURLRequest *)request
                               task:(NSURLSessionTask * __autoreleasing *)task
{
  task = [self pointerToTaskFromTask:task];
  return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
    *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
      if (error) {
        rejecter(error);
      }
      else {
        fulfiller(PMKManifold(response, responseObject));
      }
    }];
  }];
}

- (PMKPromise *)uploadTaskWithRequest:(NSURLRequest *)request
                             fromFile:(NSURL *)fileURL
                             progress:(NSProgress * __autoreleasing *)progress
                           uploadTask:(NSURLSessionTask * __autoreleasing *)uploadTask
{
  uploadTask = [self pointerToTaskFromTask:uploadTask];
  return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
    *uploadTask = [self uploadTaskWithRequest:request fromFile:fileURL progress:progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
      if (error) {
        rejecter(error);
      }
      else {
        fulfiller(PMKManifold(response, responseObject));
      }
    }];
  }];
}

- (PMKPromise *)uploadTaskWithRequest:(NSURLRequest *)request
                             fromData:(NSData *)bodyData
                             progress:(NSProgress * __autoreleasing *)progress
                           uploadTask:(NSURLSessionTask * __autoreleasing *)uploadTask
{
  uploadTask = [self pointerToTaskFromTask:uploadTask];
  return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
    *uploadTask = [self uploadTaskWithRequest:request fromData:bodyData progress:progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
      if (error) {
        rejecter(error);
      }
      else {
        fulfiller(PMKManifold(response, responseObject));
      }
    }];
  }];
}

- (PMKPromise *)uploadTaskWithStreamedRequest:(NSURLRequest *)request
                                     progress:(NSProgress * __autoreleasing *)progress
                                   uploadTask:(NSURLSessionTask * __autoreleasing *)uploadTask
{
  uploadTask = [self pointerToTaskFromTask:uploadTask];
  return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
    *uploadTask = [self uploadTaskWithStreamedRequest:request progress:progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
      if (error) {
        rejecter(error);
      }
      else {
        fulfiller(PMKManifold(response, responseObject));
      }
    }];
  }];
}

- (PMKPromise *)downloadTaskWithRequest:(NSURLRequest *)request
                               progress:(NSProgress * __autoreleasing *)progress
                            destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                           downloadTask:(NSURLSessionTask * __autoreleasing *)downloadTask
{
  downloadTask = [self pointerToTaskFromTask:downloadTask];
  return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
    *downloadTask = [self downloadTaskWithRequest:request progress:progress destination:destination completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
      if (error) {
        rejecter(error);
      }
      else {
        fulfiller(PMKManifold(response, filePath));
      }
    }];
  }];
}

- (PMKPromise *)downloadTaskWithResumeData:(NSData *)resumeData
                                  progress:(NSProgress * __autoreleasing *)progress
                               destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                              downloadTask:(NSURLSessionTask * __autoreleasing *)downloadTask
{
  downloadTask = [self pointerToTaskFromTask:downloadTask];
  return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
    *downloadTask = [self downloadTaskWithResumeData:resumeData progress:progress destination:destination completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
      if (error) {
        rejecter(error);
      }
      else {
        fulfiller(PMKManifold(response, filePath));
      }
    }];
    
  }];
}

- (PMKPromise *)POST:(NSString *)urlString parameters:(id)parameters
{
	return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
		[[self POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
			fulfiller(PMKManifold(responseObject, task));
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			rejecter(error);
		}] resume];
	}];
}

- (PMKPromise *)POSTMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
	return [self operationSequenceWithType:AF_OPERATION_POST urls:urlStringsArray parameters:parametersArray];
}

- (PMKPromise *)POST:(NSString *)urlString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
{
	return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
		[[self POST:urlString parameters:parameters constructingBodyWithBlock:block success:^(NSURLSessionDataTask *task, id responseObject) {
			fulfiller(PMKManifold(responseObject, task));
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			rejecter(error);
		}] resume];
	}];
}


- (PMKPromise *)GET:(NSString *)urlString parameters:(id)parameters
{
	return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
		[[self GET:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
			fulfiller(PMKManifold(responseObject, task));
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			rejecter(error);
		}] resume];
	}];
}

- (PMKPromise *)GETMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
	return [self operationSequenceWithType:AF_OPERATION_GET urls:urlStringsArray parameters:parametersArray];
}


- (PMKPromise *)PUT:(NSString *)urlString parameters:(id)parameters
{
	return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
		[[self PUT:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
			fulfiller(PMKManifold(responseObject, task));
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			rejecter(error);
		}] resume];
	}];
}

- (PMKPromise *)PUTMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
	return [self operationSequenceWithType:AF_OPERATION_PUT urls:urlStringsArray parameters:parametersArray];
}

- (PMKPromise *)HEAD:(NSString *)urlString parameters:(id)parameters
{
	return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
		[[self HEAD:urlString parameters:parameters success:^(NSURLSessionDataTask *task) {
			fulfiller(task);
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			rejecter(error);
		}] resume];
	}];
}

- (PMKPromise *)HEADMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
	return [self operationSequenceWithType:AF_OPERATION_HEAD urls:urlStringsArray parameters:parametersArray];
}

- (PMKPromise *)PATCH:(NSString *)urlString parameters:(id)parameters
{
	return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
		[[self PATCH:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
			fulfiller(PMKManifold(responseObject, task));
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			rejecter(error);
		}] resume];
	}];
}

- (PMKPromise *)PATCHMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
	return [self operationSequenceWithType:AF_OPERATION_PATCH urls:urlStringsArray parameters:parametersArray];
}



- (PMKPromise *)DELETE:(NSString *)urlString parameters:(id)parameters
{
	return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
		[[self DELETE:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
			fulfiller(PMKManifold(responseObject, task));
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			rejecter(error);
		}] resume];
	}];
}

- (PMKPromise *)DELETEMultiple:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
	return [self operationSequenceWithType:AF_OPERATION_DELETE urls:urlStringsArray parameters:parametersArray];
}




- (PMKPromise *)operationSequenceWithType:(AF_OPERATION_KIND)operationKind urls:(NSArray *)urlStringsArray parameters:(NSArray *)parametersArray
{
	assert (urlStringsArray.count == parametersArray.count);
	NSMutableArray *operations = [NSMutableArray array];
	
	for (int i=0; i<urlStringsArray.count; i++){
		NSString *urlString = urlStringsArray[i];
		NSDictionary *parameters = parametersArray[i];
		
		PMKPromise *p = [self promiseForNetworkOperation:operationKind withURL:urlString andParameters:parameters];
		
		[operations addObject:p.then(^(id responseObject, NSURLSessionDataTask *task){
			return [PMKPromise promiseWithValue:@{kPMKAFResponseObjectKey : responseObject, kPMKAFResponseTaskKey : task}];
		})];
	}
	
	return [PMKPromise when:operations];
}



- (PMKPromise *)promiseForNetworkOperation:(AF_OPERATION_KIND)operationKind withURL:(NSString *)urlString andParameters:(id)parameters
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




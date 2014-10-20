PromiseKit+AFNetworking	{#welcome}
=====================

PromiseKit+AFNetworking is a small category addition to the delightful [PromiseKit][1], enabling it to work with the widely used [AFNetworking v 2.0][2]

For the time being, it's a small category addition to the core AFNetworking, facilitating development with the plain AFHTTPRequestOperation and with the AFHTTPRequestOperationManager.

#Installation
You have two options: Either use cocoapods (look into the appropriate section below), or 
ust copy AFNetworking+Promises.h and AFNetworking+Promises.m in your project and use them.

I have just started using Cocoapods and making podfiles, so in case you encounter any issues with the podspec, please leave your comments in the issues section!!

#Sample Uses:

### Plain HTTP Request
```objectivec
[AFHTTPRequestOperation request:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://oramind.com/"]]].then(^(id responseObject){
	NSLog(@"operation completed! %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
}).catch(^(NSError *error){
	NSLog(@"error: %@", error.localizedDescription);
	NSLog(@"original operation: %@", error.userInfo[AFHTTPRequestOperationErrorKey]);
});
```

The above code will immediately execute the HTTP Request by adding it to the current queue, or the main queue if the current queue does not exist. You can also add it to a different queue (see the header file)

###AFHTTPRequestOperationManager
```objectivec
self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];


[self.manager GET:@"http://www.error-url.ss/" parameters:nil].then(^(id responseObject, AFHTTPRequestOperation *operation){
	NSLog(@"first request completed for operation: %@", operation.request.description);
	return [self.manager GET:@"http://www.apple.com" parameters:nil];
}).then(^{
	NSLog(@"second request completed");
}).catch(^(NSError *error){
	NSLog(@"error happened: %@", error.localizedDescription);
	NSLog(@"original operation: %@", error.userInfo[AFHTTPRequestOperationErrorKey]);
});
	
```

Objects returned by the plain AFHTTPRequestOperationManager are also returned here, as optional arguments (a response object of type 'id' and the AFHTTPRequestOperation). In case of errors, you can use the "catch" command of PromiseKit, and get the error thrown by AFNetworking and the original operation that spawned the error with 'error.userInfo[AFHTTPRequestOperationErrorKey]'

Making concurrent operations is a simple matter of calling "-when" on PMKPromise as described in the official documentation.

```objectivec
[PMKPromise when:@[
	[self.operationManager GET:@"ip" parameters:nil].then(^(){numberOfOperationsCompleted ++;}),
	[self.operationManager GET:@"get" parameters:nil].then(^(){numberOfOperationsCompleted ++;})
                   ]].then(^(){
		//do something when all operations are finished
    });
```

###AFHTTPSessionManager

New: Now AFHTTPSessionManager is supported, for use with AFNetworking 2.0 and iOS 7

Sample function that logins using an AFHTTPSessionManager below:
```objectivec
- (PMKPromise *)loginWithUserName:(NSString *)userName andPassword:(NSString *)password
{
	return [self.sessionManager POST:@"api/login" parameters:@{@"user": userName, @"password" : password}].then(^(id responseObject, NSURLSessionDataTask *dataTask){
	    //responseObject holds the response returned by AFNetworking
        //dataDask will hold an NSURLSessionDataTask associated with this request, like it happens in AFHTTPSessionManager
	});
}

```

Objects returned during these operations are optional here. Maximum arguments in "then()" blocks are "2", a responseObject (that has been deserialized by AFNetworking) and an NSURLSessionDataTask.

Of course, chaining and making concurrent operations work the same way as in AFHTTPRequestOperationManager.

#Samples
Now unit tests are available, which demonstrate the basic functionality and give some basic examples on how to use this category. More unit tests are going to be added in the near future.


#Pods integration
You can use the project with CocoaPods. Simply put this line into your podfile:

```
pod 'PromiseKit-AFNetworking'
```

Then do a ```pod update``` to get the latest version.


#To Do
- Update documentation
- Add unit tests (DONE!)
- Implement it for AFURLSessionManager (if it makes sense)
- Add some goodies, in cases where they make sense.

#Special Thanks
Special thanks to Jeff Miller ( https://github.com/jeffmax ) for his fixes and ```pod```ification of this repo

#Disclaimer
I have created this small addition in order to use it in a project I am making. I have had the opportunity to test it in real-life situations, but AFHTTPRequestOperationManager is not tested for DELETE, and PUT operations. If you find a bug, please submit a bug report.

#Something missing?
Of course something is missing. I have just began implementing this. If you have suggestions, additions, or you want to add a cool feature, I would be happy to hear about it. Please, please, please, leave your feedback and suggestions to the 'issues' section!


  [1]: http://promisekit.org
  [2]: https://github.com/AFNetworking/AFNetworking
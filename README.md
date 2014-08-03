  PromiseKit+AFNetworking	{#welcome}
=====================

PromiseKit+AFNetworking is a small category addition to the delightful [PromiseKit][1], enabling it to work with the widely used [AFNetworking v 2.0][2]

For the time being, it's a small category addition to the core AFNetworking, facilitating development with the plain AFHTTPRequestOperation and with the AFHTTPRequestOperationManager.

#Installation
Just copy AFNetworking+Promises.h and AFNetworking+Promises.m in your project and use them. CocoaPods integration is coming soon.

#Sample Uses:

### Plain HTTP Request
```
[AFHTTPRequestOperation request:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://oramind.com/"]]].then(^(id responseObject){
	NSLog(@"operation completed! %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
}).catch(^(NSError *error){
	NSLog(@"error: %@", error.localizedDescription);
	NSLog(@"original operation: %@", error.userInfo[AFHTTPRequestOperationErrorKey]);
});
```

The above code will immediately execute the HTTP Request by adding it to the current queue, or the main queue if the current queue does not exist. You can also add it to a different queue (see the header file)

###AFHTTPRequestOperationManager
```
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

###AFHTTPSessionManager

New: Now AFHTTPSessionManager is supported, for use with AFNetworking 2.0 and iOS 7

Sample function that logins using an AFHTTPSessionManager below:
```
- (PMKPromise *)loginWithUserName:(NSString *)userName andPassword:(NSString *)password
{
	return [self.sessionManager POST:@"api/login" parameters:@{@"user": userName, @"password" : password}].then(^(id responseObject, NSURLSessionDataTask *dataTask){
	    //responseObject holds the response returned by AFNetworking
        //dataDask will hold an NSURLSessionDataTask associated with this request, like it happens in AFHTTPSessionManager
	});
}

```

Objects returned during these operations are optional here. Maximum arguments in "then()" blocks are "2", a responseObject (that has been deserialized by AFNetworking) and an NSURLSessionDataTask.

#Pods integration
You can use the project with CocoaPods. I haven't found the time to integrate the project with the official CocoaPods repository, but you can use it anyway, like this:

```
pod 'PromiseKit-AFNetworking', :git => 'http://github.com/csotiriou/PromiseKit-AFNetworking'
```

Just put the above line into your podfile and then do a ```pod update``` to get the latest version.


#To Do
- Update documentation
- Add unit tests
- Implement it for AFHTTPSessionManager and AFURLSessionManager
- Add some goodies, in cases where they make sense.

#Disclaimer
I have created this small addition in order to use it in a project I am making. I have had the opportunity to test it in real-life situations, but AFHTTPRequestOperationManager is not tested for DELETE, and PUT operations. If you find a bug, please submit a bug report.

#Something missing?
Of course something is missing. I have just began implementing this. If you have suggestions, additions, or you want to add a cool feature, I would be happy to hear about it. Please, please, please, leave your feedback and suggestions to the 'issues' section!


  [1]: http://promisekit.org
  [2]: https://github.com/AFNetworking/AFNetworking
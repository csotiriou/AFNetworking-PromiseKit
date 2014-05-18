//
//  ViewController.m
//  PromiseTests
//
//  Created by Christos Sotiriou on 17/5/14.
//  Copyright (c) 2014 Oramind. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <PromiseKit/PromiseKit.h>
#import "AFNetworking+Promises.h"


@interface ViewController ()
@property (nonatomic, strong) AFHTTPRequestOperation *operation;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	
	[AFHTTPRequestOperation request:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://oramind.com/"]]].then(^(id responseObject){
		NSLog(@"operation completed! %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
	}).catch(^(NSError *error){
		NSLog(@"error: %@", error.userInfo[PMKThrown][0]);
	});
	
	self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
	self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
	
	
	[self.manager GET:@"http://www.oramind.com/" parameters:nil].then(^(id responseObject, AFHTTPRequestOperation *operation){
		NSLog(@"first request completed for operation: %@", operation.request.description);
		return [self.manager GET:@"http://www.apple.com" parameters:nil];
	}).then(^{
		NSLog(@"second request completed");
	}).catch(^(NSError *error){
		NSLog(@"error happened: %@", error.userInfo[PMKThrown][0]); //this will hold the actual error reported by the HTTP Client
	});
	
	
	
	
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

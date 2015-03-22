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
#import "AFNetworking+PromiseKit.h"


@interface ViewController ()
@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[[NSURL alloc] initWithString:@"http://oramind.com"]];
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [self.sessionManager GETMultiple:@[@"/", @"/", @"/", @"/"] parameters:@[@{},@{},@{},@{}]].then(^(NSArray * responsesArray){
        for (NSDictionary *responseDictionary in responsesArray){
            NSLog(@"task description: %@", responseDictionary[kPMKAFResponseTaskKey]);
            NSLog(@"response object description: %@", responseDictionary[kPMKAFResponseObjectKey]);
        }
    });

    self.operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[[NSURL alloc] initWithString:@"http://oramind.com"]];
    self.operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [self.operationManager GETMultiple:@[@"/", @"/", @"/", @"/"] parameters:@[@{},@{},@{},@{}]].then(^(NSArray * responsesArray){
        for (NSDictionary *responseDictionary in responsesArray){
            NSLog(@"operation description: %@", responseDictionary[kPMKAFResponseOperationKey]);
            NSLog(@"response object description: %@", responseDictionary[kPMKAFResponseObjectKey]);
        }
    });

	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

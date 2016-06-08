//
//  ViewController.m
//  PromiseTests
//
//  Created by Christos Sotiriou on 17/5/14.
//  Copyright (c) 2014 Oramind. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "AFNetworking+PromiseKit.h"


@interface ViewController ()
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
	
    //get the task
    NSURLSessionTask *task;
    
    //set the task to run immediately
    self.sessionManager.startTasksImmediately = YES;
    [self.sessionManager dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://oramind.com/"]] task:&task];
    NSLog(@"%@", task);
    
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

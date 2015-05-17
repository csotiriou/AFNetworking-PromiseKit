//
//  HTTPClient+PromiseKitTests.m
//  PromiseKit+AFNetworking
//
//  Created by Christos Sotiriou on 10/20/14.
//  Copyright (c) 2014 Oramind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "AFNetworking+PromiseKit.h"
#import <PromiseKit/AnyPromise.h>
#define EXP_SHORTHAND
#import "Expecta.h"
#import "TestCommon.h"


@interface HTTPClient_PromiseKitTests : XCTestCase
@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;
@end

@implementation HTTPClient_PromiseKitTests

- (void)setUp {
    [super setUp];
    self.operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kTestURL]];
    self.operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSingleOperation {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Operations completed"];
    
    __block id response = nil;
    __block id operationCompleted = nil;

    
    [self.operationManager GET:@"ip" parameters:nil].then(^(id responseObject, AFHTTPRequestOperation *operation){
        response = responseObject;
        operationCompleted = operation;
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        expect(error).to.beNil();
        expect([operationCompleted isKindOfClass:[AFHTTPRequestOperation class]]).to.beTruthy();
        expect([response isKindOfClass:[NSString class]]);
    }];
}

- (void)testMultipleOperations{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Operations completed"];
    __block int numberOfOperationsCompleted = 0;

    [self.operationManager GET:@"ip" parameters:nil].then(^(id responseObject, AFHTTPRequestOperation *operation){
        numberOfOperationsCompleted++;
        return [self.operationManager GET:@"get" parameters:nil];
    }).then(^(){
        [expectation fulfill];
    });

    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        expect(error).to.beNil();
    }];
}

- (void)testConcurrentOperations{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Operations completed"];
    __block int numberOfOperationsCompleted = 0;
	
	PMKWhen(@[
			  [self.operationManager GET:@"ip" parameters:nil].then(^(){numberOfOperationsCompleted ++;}),
			  [self.operationManager GET:@"get" parameters:nil].then(^(){numberOfOperationsCompleted ++;})
			  ]).then(^(){
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        expect(error).to.beNil();
    }];
}



@end

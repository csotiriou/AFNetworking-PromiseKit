//
//  PromiseKit_AFNetworkingTests.m
//  PromiseKit+AFNetworkingTests
//
//  Created by Christos Sotiriou on 19/5/14.
//  Copyright (c) 2014 Oramind. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AFNetworking+PromiseKit.h"
#import <PromiseKit/Promise.h>
#define EXP_SHORTHAND
#import "Expecta.h"
#import "TestCommon.h"

@interface PromiseKit_AFNetworkingTests : XCTestCase
@end

@implementation PromiseKit_AFNetworkingTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSingleOperation
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Operations completed"];
    __block id response = nil;
    __block id operationCompleted = nil;
    
    [[[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kTestURL]]] promiseAndStartImmediately].then(^(id responseObject, AFHTTPRequestOperation *operation){
        response = responseObject;
        operationCompleted = operation;
    }).finally(^(){
        [expectation fulfill];
    });

    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        expect(error).to.beNil();
        expect([operationCompleted isKindOfClass:[AFHTTPRequestOperation class]]).to.beTruthy();
        expect([response isKindOfClass:[NSString class]]);
    }];
}

- (void)testOperationSequence
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Operations completed"];
    __block int numberOfOperationsCompleted = 0;

    [[[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kTestURL]]] promiseAndStartImmediately].then(^(id responseObject, AFHTTPRequestOperation *operation){
        numberOfOperationsCompleted++;
        return [[[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kTestURL]]] promiseAndStartImmediately];
    }).then(^(){
        numberOfOperationsCompleted++;
    }).finally(^(){
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        expect(error).to.beNil();
        expect(numberOfOperationsCompleted).to.equal(2);
    }];
}

- (void)testOperationSequenceConcurrent
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Operations completed"];
    __block int numberOfOperationsCompleted = 0;
    
    PMKPromise *promise1 = [[[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kTestURL]]] promiseAndStartImmediately].then(^(){ numberOfOperationsCompleted ++; });
    PMKPromise *promise2 = [[[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kTestURL]]] promiseAndStartImmediately].then(^(){ numberOfOperationsCompleted ++; });
	
	PMKWhen(@[promise1, promise2]).then(^(){
		[expectation fulfill];
	});
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        expect(error).to.beNil();
        expect(numberOfOperationsCompleted).to.equal(2);
    }];
}


@end

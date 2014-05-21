//
//  AKNetworkManagerTests.m
//  Marvel
//
//  Created by Anton Kovalev on 5/21/14.
//  Copyright (c) 2014 Anton Kovalev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AKNetworkManager.h"
#import "Constants.h"

@interface AKNetworkManagerTests : XCTestCase

@end

@interface AKNetworkManagerTests ()
@property(nonatomic, strong) NSURLSession *currentSession;
@end

@implementation AKNetworkManagerTests

- (void)setUp
{
    [super setUp];
    self.currentSession = [AKNetworkManager sharedManager].currentSession;
}

- (void)tearDown
{
    [OHHTTPStubs removeAllStubs];
    [super tearDown];
}

- (void)testSession
{
    expect(self.currentSession).willNot.beNil();
}

- (void)testSessionHeaders
{
    NSURLSessionConfiguration *config = self.currentSession.configuration;
    expect(config.HTTPAdditionalHeaders).notTo.beNil();
}

-(void)testSessionAuthHeaders
{
    NSURLSessionConfiguration *config = self.currentSession.configuration;
    NSString *authKey = [config.HTTPAdditionalHeaders objectForKey:kKeyForPublicAPIKey];
    expect(authKey).to.equal(kPublicAPIKey);
}

-(void)testBaseURL
{
    NSURL *baseURL = [AKNetworkManager sharedManager].baseURL;
    expect([baseURL absoluteString]).to.equal(kBaseURL);
}

@end

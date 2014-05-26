//
//  AKCharactersLoaderTests.m
//  Marvel
//
//  Created by Anton Kovalev on 5/21/14.
//  Copyright (c) 2014 Anton Kovalev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AKCharactersLoader.h"
#import "AKCharacter.h"
#import "NSManagedObjectContext+Testing.h"

@interface AKCharactersLoaderTests : XCTestCase
@property (nonatomic, strong) AKCharactersLoader *loader;
@end

@interface AKCharactersLoaderTests ()
@property(nonatomic, strong) NSManagedObjectContext *context;
@end

@implementation AKCharactersLoaderTests

- (void)setUp
{
    [super setUp];

    NSError *error = nil;
    self.context = [NSManagedObjectContext tetsInMemoryStorageError:&error];
    expect(error).to.beNil();
    expect(self.context).notTo.beNil();
    self.loader = [AKCharactersLoader loaderWithContext:self.context];
}

- (void)tearDown
{
    [OHHTTPStubs removeAllStubs];
    [super tearDown];
}

- (void)testOneCharacter
{
    __block id character = nil;
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSString *url = [request.URL absoluteString];
        return [url isEqualToString:@"http://gateway.marvel.com/v1/public/characters/1009368?apikey=fb82139635150122c7e95c56127f1224"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"Character.json", nil)
                                                statusCode:200
                                                   headers:@{@"Content-Type":@"application/json"}];
    }];

    [self.loader loadCharacterWithId:@"1009368" andCompletion:^(id result) {
        character = result;
    }];


    expect(character).willNot.beNil();
    expect([character class]).will.equal([AKCharacter class]);

}

@end

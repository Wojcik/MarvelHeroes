//
// Created by Anton Kovalev on 5/22/14.
// Copyright (c) 2014 Anton Kovalev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AKRequestComposer.h"

@interface AKRequestComposerTests : XCTestCase
@property (nonatomic, strong) AKRequestComposer *composer;

@end

@implementation AKRequestComposerTests

- (void)setUp
{
    [super setUp];
    self.composer = [AKRequestComposer new];
}

+ (void)tearDown
{
    [super tearDown];
}


- (void)testParametersComposing
{
    //http://gateway.marvel.com:80/v1/public/characters/1009368?apikey=fb82139635150122c7e95c56127f1224
    NSString *composedString = @"characterID=1000&characterName=Godzilla&imageName=Godzilla%20Big";
    NSDictionary *paramsDictionary = @{
            @"characterID":@1000,
            @"characterName":@"Godzilla",
            @"imageName":@"Godzilla Big"
    };

    NSString *parameters = [self.composer composeDictionary:paramsDictionary];
    expect(parameters).to.equal(composedString);
}

@end
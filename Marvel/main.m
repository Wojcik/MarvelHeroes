//
//  main.m
//  Marvel
//
//  Created by Anton Kovalev on 5/21/14.
//  Copyright (c) 2014 Anton Kovalev. All rights reserved.
//

#import "AKAppDelegate.h"

static bool isRunningTests()
{
    NSDictionary* environment = [[NSProcessInfo processInfo] environment];
    NSString* injectBundle = environment[@"XCInjectBundle"];
    return [[injectBundle pathExtension] isEqualToString:@"xctest"];
}

int main(int argc, char *argv[])
{
    @autoreleasepool
    {
        if (isRunningTests())
        {
            return UIApplicationMain(argc, argv, nil, nil);
        }
        else {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AKAppDelegate class]));
        }
    }
}
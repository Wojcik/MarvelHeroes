//
// Created with AppCode
//  Created by Anton Kovalev on 5/24/14.
//  Copyright (c) 2014 Ant Coding. All rights reserved.
//

#import "NSString+Path.h"

@implementation NSString (Path)

+ (NSString *)documentPath
{
    return [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                    inDomains:NSUserDomainMask] lastObject]
            path];
}

+ (NSString *)cachesPath
{
    return [[[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory
                                                    inDomains:NSUserDomainMask] lastObject]
            path];
}
@end
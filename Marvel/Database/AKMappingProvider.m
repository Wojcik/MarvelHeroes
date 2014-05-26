//
//  AKMappingProvider.m
//  Marvel
//
//  Created by TOXA on 5/24/14.
//  Copyright (c) 2014 Anton Kovalev. All rights reserved.
//

#import "AKMappingProvider.h"
#import "EKManagedObjectMapping.h"
#import "AKCharacter.h"

@implementation AKMappingProvider


+ (EKManagedObjectMapping *)characterMapping
{
    void (^mappingBlock) (EKManagedObjectMapping *) = ^(EKManagedObjectMapping *mapping) {
        [mapping mapKey:@"id" toField:@"charactedId"];
        [mapping mapKey:@"name" toField:@"name"];
        [mapping mapKey:@"thumbnail.path" toField:@"thumbnail"];
    };

    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([AKCharacter class])
                                              withBlock:mappingBlock];;
}

@end

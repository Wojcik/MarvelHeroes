//
//  Created by Anton Kovalev on 5/24/14.
//  Copyright (c) 2014 Ant Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EKObjectMapping;


@interface AKResponseMappingProvider : NSObject

+ (EKObjectMapping *)mappingForResponse;

@end
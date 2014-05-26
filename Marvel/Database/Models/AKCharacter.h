//
//  AKCharacter.h
//  Marvel
//
//  Created by TOXA on 5/24/14.
//  Copyright (c) 2014 Anton Kovalev. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AKManagedObject.h"


@interface AKCharacter : NSManagedObject

@property (nonatomic, retain) NSNumber * charactedId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * thumbnail;

@end

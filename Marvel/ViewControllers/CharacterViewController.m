//
//  CharacterViewController.m
//  Marvel
//
//  Created by Anton Kovalev on 5/21/14.
//  Copyright (c) 2014 Anton Kovalev. All rights reserved.
//

#import "CharacterViewController.h"
#import "AKCharactersLoader.h"

@interface CharacterViewController ()
@property (nonatomic, strong) AKCharactersLoader *loader;
@end

@implementation CharacterViewController

#pragma mark - appearance

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loader = [AKCharactersLoader new];
    [self.loader loadCharacterWithId:@"1009368" andCompletion:^(id character) {
        NSLog(@"%@", character);
    }];
}


@end

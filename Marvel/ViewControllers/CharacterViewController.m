//
//  CharacterViewController.m
//  Marvel
//
//  Created by Anton Kovalev on 5/21/14.
//  Copyright (c) 2014 Anton Kovalev. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "CharacterViewController.h"
#import "AKCharactersLoader.h"
#import "AKCharacter.h"
#import "AKPersistenceStackHelper.h"

@interface CharacterViewController ()
@property (nonatomic, strong) AKCharactersLoader *loader;
@property(nonatomic) IBOutlet UILabel *charLabel;
@end

@implementation CharacterViewController

#pragma mark - appearance

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSManagedObjectContext *context = [AKPersistenceStackHelper sharedHelper].managedObjectContext;
    self.loader = [AKCharactersLoader loaderWithContext:context];
    [self.loader loadCharacterWithId:@"1009368" andCompletion:^(AKCharacter  *character) {
        NSLog(@"%@", character);
        self.charLabel.text = character.name;
    }];
    //[[AKPersistenceStackHelper sharedHelper] save];
}


@end

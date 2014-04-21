//
//  LLSearchViewController.h
//  MyGitHub
//
//  Created by Lauren Lee on 4/21/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LLMenuProtocol.h"

@class LLSearchDetailViewController;

@interface LLSearchViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) LLSearchDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, unsafe_unretained) id<LLMenuProtocol> menuDelegate;

@end

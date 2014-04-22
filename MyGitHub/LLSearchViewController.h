//
//  LLSearchViewController.h
//  MyGitHub
//
//  Created by Lauren Lee on 4/21/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLMenuProtocol.h"
#import "LLSearchDetailViewController.h"

@interface LLSearchViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, unsafe_unretained) id<LLMenuProtocol> menuDelegate;
@property (strong, nonatomic) LLSearchDetailViewController *detailViewController;

@end

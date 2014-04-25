//
//  LLSearchUsersViewController.h
//  MyGitHub
//
//  Created by Lauren Lee on 4/24/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLSearchUsersViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *searchResults;

-(void)performSearchWithString:(NSString*)searchString;

@end
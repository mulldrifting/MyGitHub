//
//  LLSearchUsersViewController.m
//  MyGitHub
//
//  Created by Lauren Lee on 4/24/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "LLSearchUsersViewController.h"
#import "LLAppDelegate.h"
#import "LLUser.h"
#import "LLUserCell.h"

@interface LLSearchUsersViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) LLNetworkController *networkController;

@end

@implementation LLSearchUsersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _networkController = [(LLAppDelegate*)[[UIApplication sharedApplication] delegate] networkController];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    self.searchResults = [NSMutableArray new];
}


-(void)performSearchWithString:(NSString*)searchString
{
    [_searchResults removeAllObjects];
    
    [_networkController searchFor:kUserQuery usingSearchString:searchString withCompletion:^(NSMutableArray *results) {
        
        [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LLUser *newUser = [[LLUser alloc] initWithName:obj[@"login"] imagePath:obj[@"avatar_url"]];
            [_searchResults addObject:newUser];
        }];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [_collectionView reloadData];
        }];
    }];
}

#pragma mark - Collection View Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _searchResults.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    LLUserCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"UserCell" forIndexPath:indexPath];
    
    LLUser *user = _searchResults[indexPath.row];
    cell.label.text = user.name;
    cell.label.adjustsFontSizeToFitWidth = YES;
    
    if (user.image) {
        cell.imageView.image = user.image;
    }
    else {
        
        cell.imageView.image = nil;
        [user downloadImageWithCompletionBlock:^{
            
            [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }];
    }
    
    return cell;
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showUserSegue"])
    {
        //        LLSearchDetailViewController *destination = segue.destinationViewController;
        
        
        //        destination.detailItem = [self.repoSearchResults objectAtIndex:[_collectionView indexPathsForSelectedItems]];
    }
}


@end

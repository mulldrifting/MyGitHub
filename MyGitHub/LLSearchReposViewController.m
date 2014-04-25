//
//  LLSearchReposViewController.m
//  MyGitHub
//
//  Created by Lauren Lee on 4/24/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "LLSearchReposViewController.h"
#import "LLAppDelegate.h"
#import "LLRepo.h"
#import "LLRepoCell.h"

@interface LLSearchReposViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) LLNetworkController *networkController;

@end

@implementation LLSearchReposViewController

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
    
    [_networkController searchFor:kRepoQuery usingSearchString:searchString withCompletion:^(NSMutableArray *results) {
        
        [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LLRepo *newRepo = [[LLRepo alloc] initWithName:obj[@"name"] withURL:obj[@"html_url"]];
            [_searchResults addObject:newRepo];
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
        LLRepoCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"RepoCell" forIndexPath:indexPath];
        cell.label.text = [[_searchResults objectAtIndex:indexPath.row] name];
        
        return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showRepoSegue"])
    {
        //        LLSearchDetailViewController *destination = segue.destinationViewController;
        
        
        //        destination.detailItem = [self.repoSearchResults objectAtIndex:[_collectionView indexPathsForSelectedItems]];
    }
}


@end

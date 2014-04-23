//
//  LLReposViewController.m
//  MyGitHub
//
//  Created by Lauren Lee on 4/21/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "LLReposViewController.h"
#import "LLAppDelegate.h"
#import "LLRepo.h"
#import "LLConstants.h"

@interface LLReposViewController () <UITableViewDataSource, UITableViewDelegate, LLNetworkControllerProtocol>

@property (weak, nonatomic) IBOutlet UIButton *gutterButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) LLNetworkController *networkController;
@property (strong, nonatomic) NSMutableArray *repos;

@end

@implementation LLReposViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.repos = [NSMutableArray new];
    
    self.gutterButton.imageView.image = [LLConstants gutterButtonNormalImage];
    [self.gutterButton setImage:[LLConstants gutterButtonHighlightedImage] forState:UIControlStateHighlighted];
    
    _networkController = [(LLAppDelegate*)[[UIApplication sharedApplication] delegate] networkController];
    
    _networkController.delegate = self;
    
    if (_networkController.tokenAuthenticated)
    {
        [self updateRepos];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuButtonPressed:(id)sender {
    [self.menuDelegate handleMenuButtonPressed];
}

-(void)updateRepos
{
    NSLog(@"repos updated");
    
    [self.repos removeAllObjects];
    
    void (^repoRequestCompletionBlock)(NSMutableArray *jsonArray) = ^void(NSMutableArray *jsonArray) {
        
        [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            LLRepo *newRepo = [[LLRepo alloc] initWithName:obj[@"name"] withURL:obj[@"html_url"]];
            [self.repos addObject:newRepo];
            
        }];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    };
    
    [_networkController requestReposForAuthenticatedUser:repoRequestCompletionBlock];
}

-(void)updateRepoArrayWithArray:(NSMutableArray *)array
{
    for (NSDictionary *dict in array) {
        LLRepo *newRepo = [[LLRepo alloc] initWithName:dict[@"name"] withURL:dict[@"html_url"]];
        [self.repos addObject:newRepo];
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
    
}

#pragma mark - Table View Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.repos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepoCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.repos[indexPath.row] name];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showRepoDetailSegue"])
    {
        LLRepoDetailViewController *destination = segue.destinationViewController;
        
        destination.detailItem = [self.repos objectAtIndex:[[_tableView indexPathForSelectedRow] row]];
    }
}

@end

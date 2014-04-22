//
//  LLSearchViewController.m
//  MyGitHub
//
//  Created by Lauren Lee on 4/21/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "LLSearchViewController.h"
#import "LLRepo.h"

@interface LLSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *arrayOfRepos;

@end

@implementation LLSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.arrayOfRepos = [NSMutableArray new];
    
    [[UISearchBar appearance] setTintColor:[UIColor blackColor]];
    
    // Make keyboard disappear upon tapping outside text field
    UITapGestureRecognizer *tapOutside = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(dismissKeyboard)];
    tapOutside.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapOutside];
}

- (IBAction)menuButtonPressed:(id)sender {
    [self.searchBar resignFirstResponder];
    [self.menuDelegate handleMenuButtonPressed];
}

- (void)reposForSearchString:(NSString *)searchString
{
    NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@", searchString]];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    
    id jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                  options:NSJSONReadingMutableContainers
                                                    error:nil];
    
    for (NSDictionary *repo in jsonDict[@"items"]) {
        LLRepo *newRepo = [[LLRepo alloc] initWithName:repo[@"name"] withURL:repo[@"html_url"]];
        [self.arrayOfRepos addObject:newRepo];
    }
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [self.arrayOfRepos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.arrayOfRepos[indexPath.row] name];
    return cell;
}

#pragma mark - Search Bar Methods

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self reposForSearchString:searchBar.text];
    [self dismissKeyboard];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self dismissKeyboard];
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetailViewSegue"])
    {
        LLSearchDetailViewController *destination = segue.destinationViewController;
        
        destination.detailItem = [self.arrayOfRepos objectAtIndex:[[_tableView indexPathForSelectedRow] row]];
    }
}


@end

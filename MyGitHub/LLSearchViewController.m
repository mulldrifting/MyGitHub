//
//  LLSearchViewController.m
//  MyGitHub
//
//  Created by Lauren Lee on 4/21/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "LLSearchViewController.h"

@interface LLSearchViewController () <UISearchBarDelegate>
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation LLSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.detailViewController = (LLSearchDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuButtonPressed:(id)sender {
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
        [self insertNewRepoWithName:repo[@"name"] andURL:repo[@"html_url"]];
    }
}

- (void)insertNewRepoWithName:(NSString *)name andURL:(NSString *)html_url
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    Repo *newRepo = [NSEntityDescription insertNewObjectForEntityForName:@"Repo" inManagedObjectContext:context];
    
    newRepo.name = name;
    newRepo.html_url = html_url;
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

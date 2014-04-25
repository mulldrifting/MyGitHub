//
//  LLSearchViewController.m
//  MyGitHub
//
//  Created by Lauren Lee on 4/21/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "LLSearchViewController.h"
#import "LLWebViewController.h"
#import "LLSearchUsersViewController.h"
#import "LLSearchReposViewController.h"
#import "LLAppDelegate.h"
#import "LLUserCell.h"
#import "LLRepoCell.h"
#import "LLRepo.h"
#import "LLUser.h"
#import "LLConstants.h"

@interface LLSearchViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIButton *gutterButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *containerView;


@property (strong, nonatomic) NSMutableArray *arrayOfViewControllers;
@property (strong, nonatomic) UIViewController *topViewController;

@property (weak, nonatomic) LLNetworkController *networkController;
@property (strong, nonatomic) NSMutableArray *userSearchResults;
@property (strong, nonatomic) NSMutableArray *repoSearchResults;
@property (nonatomic) BOOL showingRepos;
@property (strong, nonatomic) UITapGestureRecognizer *tapOutside;

@end

@implementation LLSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _networkController = [(LLAppDelegate*)[[UIApplication sharedApplication] delegate] networkController];
    
    [self setupViewControllers];
    
    self.repoSearchResults = [NSMutableArray new];
    self.userSearchResults = [NSMutableArray new];
    
    // Setup segmented control
    self.segmentedControl.selectedSegmentIndex = 0;
    self.showingRepos = YES;
    
    // Sets text cursor to black
    [[UISearchBar appearance] setTintColor:[UIColor blackColor]];
    
    self.gutterButton.imageView.image = [LLConstants gutterButtonNormalImage];
    [self.gutterButton setImage:[LLConstants gutterButtonHighlightedImage] forState:UIControlStateHighlighted];
    
    // Allocate gesture recognizer to make keyboard disappear upon tapping outside text field
    self.tapOutside = [UITapGestureRecognizer alloc];
    self.tapOutside.cancelsTouchesInView = NO;
    
        
}

- (IBAction)menuButtonPressed:(id)sender {
    [self dismissKeyboard];
    [self.menuDelegate handleMenuButtonPressed];
}

- (void)setupViewControllers
{
    LLSearchReposViewController *searchReposViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"searchRepos"];
    LLSearchUsersViewController *searchUsersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"searchUsers"];
    
    self.arrayOfViewControllers = [NSMutableArray arrayWithObjects:searchReposViewController, searchUsersViewController, nil];
    
    self.topViewController = self.arrayOfViewControllers[kRepoView];
    [self addChildViewController:self.topViewController];
    [self.containerView addSubview:self.topViewController.view];
    [self.topViewController didMoveToParentViewController:self];
}

#pragma mark - Search Bar Methods

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.tapOutside = [self.tapOutside initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:self.tapOutside];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (_showingRepos) {
        [(LLSearchReposViewController*)self.topViewController performSearchWithString:searchBar.text];
    }
    else {
        [(LLSearchUsersViewController*)self.topViewController performSearchWithString:searchBar.text];
    }
    
    [self dismissKeyboard];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self dismissKeyboard];
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
    [self.view removeGestureRecognizer:self.tapOutside];
}

#pragma mark - Segmented Control Methods

-(IBAction)switchLayout:(id)sender
{
    int index = (_showingRepos) ? kUserView : kRepoView;
    self.showingRepos = !self.showingRepos;
    
    [UIView animateWithDuration:.2 animations:^{
        
        self.topViewController.view.frame = self.containerView.bounds;
        
    } completion:^(BOOL finished) {
        
        CGRect offScreen = self.topViewController.view.frame;
        
        [self.topViewController.view removeFromSuperview];
        [self.topViewController removeFromParentViewController];
        
        self.topViewController = self.arrayOfViewControllers[index];
        
        self.topViewController.view.frame = offScreen;
        
        [self addChildViewController:self.topViewController];
        [self.containerView addSubview:self.topViewController.view];
        [self.topViewController didMoveToParentViewController:self];
        
    }];
    
}



@end

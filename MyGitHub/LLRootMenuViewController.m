//
//  LLRootMenuViewController.m
//  MyGitHub
//
//  Created by Lauren Lee on 4/21/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "LLAppDelegate.h"
#import "LLRootMenuViewController.h"
#import "LLReposViewController.h"
#import "LLWatchedViewController.h"
#import "LLSearchViewController.h"
#import "LLMenuProtocol.h"

#define PERCENT_ROOT_MENU_REVEALED .85
#define PERCENT_NEEDED_TO_OPEN_CLOSE .50

@interface LLRootMenuViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, LLMenuProtocol>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayOfViewControllers;
@property (strong, nonatomic) UIViewController *topViewController;

@property (strong, nonatomic) UITapGestureRecognizer *tapToClose;
@property (nonatomic) BOOL menuIsOpen;

@end

@implementation LLRootMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tapToClose = [UITapGestureRecognizer new];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(30, 0, 0, 0);
    self.tableView.contentInset = inset;
    
//    [self setNeedsStatusBarAppearanceUpdate];
    
    [self setupViewControllers];
    [self setupDragRecognizer];
    
}

- (void)setupViewControllers
{
    LLReposViewController *repoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"repos"];
    repoViewController.title = @"my repos";
    repoViewController.menuDelegate = self;
    UINavigationController *repoNav = [[UINavigationController alloc] initWithRootViewController:repoViewController];
    repoNav.navigationBarHidden = YES;
    
    LLWatchedViewController *watchedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"watched"];
    watchedViewController.title = @"my watched";
    watchedViewController.menuDelegate = self;
    
    LLSearchViewController *searchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    searchViewController.title = @"search";
    searchViewController.menuDelegate = self;
    UINavigationController *searchNav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    searchNav.navigationBarHidden = YES;
    
    self.arrayOfViewControllers = [NSMutableArray arrayWithObjects:repoViewController, watchedViewController, searchNav, nil];
    
    self.topViewController = self.arrayOfViewControllers[0];
    [self addChildViewController:self.topViewController];
    [self.view addSubview:self.topViewController.view];
    [self.topViewController didMoveToParentViewController:self];
    
}

-(void)setupDragRecognizer
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveMenu:)];
    
    panRecognizer.minimumNumberOfTouches = 1;
    panRecognizer.maximumNumberOfTouches = 1;
    
    panRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:panRecognizer];
    
}

-(void)moveMenu:(id)sender
{
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)sender;
    
    CGPoint translatedPoint = [pan translationInView:self.view];
    
    if (pan.state == UIGestureRecognizerStateChanged)
    {
        if (self.topViewController.view.center.x > self.view.center.x || translatedPoint.x > 0) {
            if (self.topViewController.view.frame.origin.x <= self.view.frame.size.width * PERCENT_ROOT_MENU_REVEALED) {
                self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translatedPoint.x, self.topViewController.view.center.y);
                [pan setTranslation:CGPointZero inView:self.view];
            }
        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded)
    {
        if (self.topViewController.view.frame.origin.x > self.view.frame.size.width * PERCENT_NEEDED_TO_OPEN_CLOSE) {
            
            [UIView animateWithDuration:.2 animations:^{
                self.topViewController.view.frame = CGRectMake(self.view.frame.size.width * PERCENT_ROOT_MENU_REVEALED, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                
            } completion:^(BOOL finished) {
                
                if (finished)
                {
                    self.tapToClose = [self.tapToClose initWithTarget:self action:@selector(closeMenu)];
                    [self.topViewController.view addGestureRecognizer:self.tapToClose];
                    self.menuIsOpen = YES;
                }
            }];
        }
        else
        {
            [UIView animateWithDuration:.2 animations:^{
                self.topViewController.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            }];
            
        }
    }
    
}

-(void)openMenu
{
    [UIView animateWithDuration:.2 animations:^{
        self.topViewController.view.frame = CGRectMake(self.view.frame.size.width * PERCENT_ROOT_MENU_REVEALED, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        if (finished)
        {
            self.tapToClose = [self.tapToClose initWithTarget:self action:@selector(closeMenu)];
            [self.topViewController.view addGestureRecognizer:self.tapToClose];
            self.menuIsOpen = YES;
        }
    }];
}

-(void)closeMenu
{
    [UIView animateWithDuration:.2 animations:^{
        
        self.topViewController.view.frame = self.view.frame;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self.topViewController.view removeGestureRecognizer:self.tapToClose];
            self.menuIsOpen = NO;
        }
    }];
}

-(void)switchToViewControllerAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:.2 animations:^{
        
        self.topViewController.view.frame = CGRectMake(self.view.frame.size.width * PERCENT_ROOT_MENU_REVEALED, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        CGRect offScreen = self.topViewController.view.frame;
        
        [self.topViewController.view removeFromSuperview];
        [self.topViewController removeFromParentViewController];
        
        self.topViewController = self.arrayOfViewControllers[indexPath.row];
        
        self.topViewController.view.frame = offScreen;
        
        [self addChildViewController:self.topViewController];
        [self.view addSubview:self.topViewController.view];
        [self.topViewController didMoveToParentViewController:self];
        
        [self closeMenu];
    }];
}

-(void)handleMenuButtonPressed
{
    if (self.menuIsOpen) {
    
        [self closeMenu];
    }
    else {
    
        [self openMenu];
    }
}

#pragma mark - Table View Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfViewControllers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithRed:0.889 green:0.882 blue:0.708 alpha:1.000];
    cell.textLabel.text = [self.arrayOfViewControllers[indexPath.row] title];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self switchToViewControllerAtIndexPath:indexPath];
}


@end


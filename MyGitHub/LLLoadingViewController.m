//
//  LLLoadingViewController.m
//  MyGitHub
//
//  Created by Lauren Lee on 4/23/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "LLLoadingViewController.h"
#import "LLAppDelegate.h"

@interface LLLoadingViewController ()
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LLLoadingViewController

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
    // Do any additional setup after loading the view.
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender {

    LLNetworkController *networkController = [(LLAppDelegate*)[[UIApplication sharedApplication] delegate] networkController];
    
    void (^loginCompletionBlock)(void) = ^void(void) {
//        [UIView animateWithDuration:0.9 animations:^{
//            self.view.alpha = 0;
//        } completion:^(BOOL b){
//            [self dismissViewControllerAnimated:NO completion:NO];
//            self.view.alpha = 1;
//        }];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [networkController requestOAuthAccessWithCompletion:loginCompletionBlock];
    
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

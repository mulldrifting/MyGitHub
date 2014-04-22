//
//  LLSearchDetailViewController.m
//  MyGitHub
//
//  Created by Lauren Lee on 4/21/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "LLSearchDetailViewController.h"

@interface LLSearchDetailViewController ()

@property (nonatomic, weak) IBOutlet UIWebView *webView;

- (void)configureView;

@end

@implementation LLSearchDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        
        NSData *webViewData;
        
        if ([self.detailItem valueForKey:@"html_cache"]) {
            webViewData = [self.detailItem valueForKey:@"html_cache"];
        } else {
            webViewData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.detailItem valueForKey:@"html_url"]]];
        }
        
        [self.detailItem setValue:webViewData forKey:@"html_cache"];
        
        [_webView loadData:[self.detailItem valueForKey:@"html_cache"]
                  MIMEType:nil
          textEncodingName:nil
                   baseURL:nil];
        
//        self.navigationItem.title = [[self.detailItem valueForKey:@"name"] description];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

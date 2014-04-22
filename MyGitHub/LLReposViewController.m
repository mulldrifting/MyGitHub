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

@interface LLReposViewController () <UITableViewDataSource, UITableViewDelegate, LLNetworkControllerProtocol>

//@property (weak, nonatomic) IBOutlet UIImageView *imageTest;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *repoArray;

@end

@implementation LLReposViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.repoArray = [NSMutableArray new];
    
    LLNetworkController *networkController = [(LLAppDelegate*)[[UIApplication sharedApplication] delegate] networkController];
    networkController.repoDelegate = self;
    [networkController requestReposForAuthenticatedUser];
    

    
//    UIImage *myIconImage = [UIImage imageNamed:@"GutterButton"];
//
//    UIGraphicsBeginImageContextWithOptions (myIconImage.size, NO, [[UIScreen mainScreen] scale]); // for correct resolution on retina, thanks @MobileVet
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextTranslateCTM(context, 0, myIconImage.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    
//    CGRect rect = CGRectMake(0, 0, myIconImage.size.width, myIconImage.size.height);
//    
//    /// draw tint color
//    CGContextSetBlendMode(context, kCGBlendModeNormal);
//    [[UIColor colorWithWhite:0.200 alpha:1.000] setFill];
//    CGContextFillRect(context, rect);
//    
//    // mask by alpha values of original image
//    CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
//    CGContextDrawImage(context, rect, myIconImage.CGImage);
//    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    self.imageTest.image = coloredImage;
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

-(void)updateRepoArrayWithArray:(NSMutableArray *)array
{
    for (NSDictionary *dict in array) {
        LLRepo *newRepo = [[LLRepo alloc] initWithName:dict[@"name"] withURL:dict[@"html_url"]];
        [self.repoArray addObject:newRepo];
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
    
}

#pragma mark - Table View Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.repoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepoCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.repoArray[indexPath.row] name];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showRepoDetailSegue"])
    {
        LLRepoDetailViewController *destination = segue.destinationViewController;
        
        destination.detailItem = [self.repoArray objectAtIndex:[[_tableView indexPathForSelectedRow] row]];
    }
}

@end

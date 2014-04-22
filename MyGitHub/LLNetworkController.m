//
//  LLNetworkController.m
//  MyGitHub
//
//  Created by Lauren Lee on 4/22/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "LLNetworkController.h"
#import "LLConstants.h"

@implementation LLNetworkController

-(id)init
{
    if (self = [super init])
    {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
        
        if (!token) {
//            NSOperationQueue *queue = [NSOperationQueue new];
//            [queue addOperationWithBlock:^{
//                [self requestOAuthAccess];
//            }];
            [self performSelector:@selector(requestOAuthAccess) withObject:nil afterDelay:0.01];
        }
    }
    
    return self;
}

-(void)requestOAuthAccess
{
    NSString *urlString = [NSString stringWithFormat:GITHUB_OAUTH_URL, GITHUB_CLIENT_ID, GITHUB_CALLBACK_URI, @"user,repo"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

-(void)handleOAuthCallbackWithURL:(NSURL *)url
{
    NSString *code = [self getCodeFromCallbackURL:url];
    NSString *postString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@", GITHUB_CLIENT_ID, GITHUB_CLIENT_SECRET, code];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:[NSURL URLWithString:@"https://github.com/login/oauth/access_token"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
//        NSLog(@"response: %@",response);
        
        if (error) {
            NSLog(@"error: %@", error);
        }
        else {
            NSString *token = [self convertResponseDataIntoToken:data];
            [[[session configuration] HTTPAdditionalHeaders] setValue:token forKey:@"Authorization"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:token forKey:@"accessToken"];
            [defaults synchronize];
        }
    }];
    
    [postDataTask resume];
}

-(void)requestReposForAuthenticatedUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"accessToken"];

    NSString *apiCallURLString = [GITHUB_API_URL stringByAppendingString:@"/user/repos"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:[NSURL URLWithString:apiCallURLString]];
    [request setValue:[NSString stringWithFormat:@"token %@", token] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        id repoArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        [self.repoDelegate updateRepoArrayWithArray:repoArray];
        
        NSLog(@"%@", repoArray);
        
    }];
    
    [dataTask resume];
}

-(NSString *)getCodeFromCallbackURL:(NSURL*)callbackURL
{
    NSString *query = [callbackURL query]; // gets everything past the ? in the URL
    
    NSArray *components = [query componentsSeparatedByString:@"code="];
    
    return [components lastObject];
    
}

-(NSString *)convertResponseDataIntoToken:(NSData*)responseData
{
    NSString *tokenResponse = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    
    NSArray *tokenComponents = [tokenResponse componentsSeparatedByString:@"&"];
    
    NSString *accessTokenWithCode = [tokenComponents firstObject];
    
    NSArray *accessTokenArray = [accessTokenWithCode componentsSeparatedByString:@"="];
    
    return accessTokenArray[1];

}

@end

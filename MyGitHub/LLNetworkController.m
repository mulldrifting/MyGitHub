//
//  LLNetworkController.m
//  MyGitHub
//
//  Created by Lauren Lee on 4/22/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "LLNetworkController.h"
#import "NSString+URLParse.h"
#import "LLRepo.h"

@interface LLNetworkController()

@property (copy, nonatomic) void (^loginCompletionBlock)(void);

@end

@implementation LLNetworkController

-(id)initWithToken
{
    if (self = [super init])
    {
        _session = [NSURLSession sharedSession];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]) {
            
            _tokenAuthenticated = YES;
            _session.configuration.HTTPAdditionalHeaders = @{@"Authorization":[NSString stringWithFormat:@"token %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]]};
            
        }
        
        else {
            _tokenAuthenticated = NO;
        }
    }
    
    return self;
}

-(void)requestOAuthAccessWithCompletion:(void(^)(void))completionBlock
{
    _loginCompletionBlock = completionBlock;
    
    NSString *urlString = [NSString stringWithFormat:GITHUB_OAUTH_PATH, GITHUB_CLIENT_ID, GITHUB_CALLBACK_URI, @"user,repo"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
}

-(void)handleOAuthCallbackWithURL:(NSURL *)url
{
    NSString *code = [self getCodeFromCallbackURL:url];
    
    NSString *postString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@", GITHUB_CLIENT_ID, GITHUB_CLIENT_SECRET, code];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:[NSURL URLWithString:GITHUB_ACCESS_TOKEN_PATH]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
//        NSLog(@"response: %@",response);
        
        if (error) {
            NSLog(@"oauth callback error: %@", error);
        }
        else {
            NSString *token = [self convertResponseDataIntoToken:data];
            
            _session.configuration.HTTPAdditionalHeaders = @{@"Authorization":[NSString stringWithFormat:@"token %@",token]};
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:token forKey:@"accessToken"];
            [defaults synchronize];
            
            _tokenAuthenticated = YES;
            
            [self.delegate updateRepos];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                 _loginCompletionBlock();
            });
            
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                _loginCompletionBlock();
//            }];
        }
    }];
    
    [postDataTask resume];
}

-(void)requestReposForAuthenticatedUserWithCompletion:(void(^)(NSMutableArray *repos))repoRequestCompletionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:[NSURL URLWithString:GITHUB_USER_REPOS]];
    [request setValue:[NSString stringWithFormat:@"token %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"request repos error: %@", error);
        }
        
        id jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

        if ([jsonArray isKindOfClass:[NSMutableArray class]]) {
            
            repoRequestCompletionBlock(jsonArray);
        }
        
        else {
            
            NSLog(@"jsonArray not NSMutableArray: %@", jsonArray);
        }
        
    }];
    
    [dataTask resume];
}

-(void)searchFor:(NSInteger)query usingSearchString:(NSString *)searchString withCompletion:(void (^)(NSMutableArray *))searchCompletionBlock
{
    searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *searchURLString;
    
    switch (query) {
        case kRepoQuery:
            searchURLString = [NSString stringWithFormat:GITHUB_SEARCH_REPOS,searchString];
            break;
        case kUserQuery:
            searchURLString = [NSString stringWithFormat:GITHUB_SEARCH_USERS,searchString];
            break;
        default:
            NSLog(@"Invalid Query Type");
            return;
    }
    
    [[_session dataTaskWithURL:[NSURL URLWithString:searchURLString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"search error: %@", error);
            return;
        }
        
        id jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingMutableContainers
                                                        error:nil];
        
        if ([jsonDict isKindOfClass:[NSMutableDictionary class]]) {
            searchCompletionBlock(jsonDict[@"items"]);
        }
        else {
            
            NSLog(@"jsonDict not NSMutableDictionary: %@", jsonDict);
        }
        
    }] resume];
}

-(NSString *)getCodeFromCallbackURL:(NSURL*)callbackURL
{
    NSString *query = [callbackURL query]; // gets everything past the ? in the URL
    
    NSDictionary *componentDictionary = [query breakQueryIntoComponents];
    
    return [componentDictionary objectForKey:@"code"];
    
}

-(NSString *)convertResponseDataIntoToken:(NSData*)responseData
{
    NSString *tokenResponse = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    
    NSDictionary *tokenComponents = [tokenResponse breakQueryIntoComponents];
    
    return [tokenComponents objectForKey:@"access_token"];
}

@end

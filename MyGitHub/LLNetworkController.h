//
//  LLNetworkController.h
//  MyGitHub
//
//  Created by Lauren Lee on 4/22/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLConstants.h"

@protocol LLNetworkControllerProtocol <NSObject>

@optional

-(void)updateRepos;

@end

@interface LLNetworkController : NSObject

@property (unsafe_unretained, nonatomic) id<LLNetworkControllerProtocol> delegate;

@property (nonatomic) BOOL tokenAuthenticated;
@property (weak, nonatomic) NSURLSession *session;

-(id)initWithToken;
-(void)requestOAuthAccessWithCompletion:(void(^)(void))completionBlock;
-(void)handleOAuthCallbackWithURL:(NSURL*)url;
-(void)requestReposForAuthenticatedUserWithCompletion:(void(^)(NSMutableArray *repos))completionBlock;
-(void)searchFor:(NSInteger)query usingSearchString:(NSString*)searchString withCompletion:(void(^)(NSMutableArray* results))searchCompletionBlock;


@end

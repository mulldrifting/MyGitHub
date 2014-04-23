//
//  LLNetworkController.h
//  MyGitHub
//
//  Created by Lauren Lee on 4/22/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

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
-(void)requestReposForAuthenticatedUser:(void(^)(NSMutableArray *repos))completionBlock;

@end

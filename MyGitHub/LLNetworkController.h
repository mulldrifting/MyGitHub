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

-(void)updateRepoArrayWithArray:(NSMutableArray*)array;

@end

@interface LLNetworkController : NSObject

@property (unsafe_unretained, nonatomic) id<LLNetworkControllerProtocol> repoDelegate;

-(void)requestOAuthAccess;
-(void)handleOAuthCallbackWithURL:(NSURL*)url;
-(void)requestReposForAuthenticatedUser;

@end

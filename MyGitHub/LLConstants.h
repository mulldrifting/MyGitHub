//
//  LLConstants.h
//  MyGitHub
//
//  Created by Lauren Lee on 4/22/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const GITHUB_CLIENT_ID = @"8391dcf5587bbedbabe6";
static NSString * const GITHUB_CLIENT_SECRET = @"0d205abfd11933f7d09a66b5477c427e248092ed";
static NSString * const GITHUB_CALLBACK_URI = @"gitauth://git_callback";
static NSString * const GITHUB_OAUTH_PATH = @"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@";
static NSString * const GITHUB_ACCESS_TOKEN_PATH = @"https://github.com/login/oauth/access_token";

static NSString * const GITHUB_API_HOME = @"https://api.github.com";
static NSString * const GITHUB_USER_REPOS = @"https://api.github.com/user/repos";
static NSString * const GITHUB_SEARCH_REPOS = @"https://api.github.com/search/repositories?q=%@";
static NSString * const GITHUB_SEARCH_USERS = @"https://api.github.com/search/users?q=%@";

typedef NS_ENUM(NSInteger, queryType) {
    kRepoQuery,
    kUserQuery
};

typedef NS_ENUM(NSInteger, searchViewType) {
    kRepoView,
    kUserView
};

@interface LLConstants : NSObject

+ (UIImage *)gutterButtonNormalImage;
+ (UIImage *)gutterButtonHighlightedImage;

@end

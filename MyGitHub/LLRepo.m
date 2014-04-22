//
//  LLRepo.m
//  MyGitHub
//
//  Created by Lauren Lee on 4/21/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "LLRepo.h"

@implementation LLRepo

- (id)initWithName:(NSString *)name withURL:(NSString *)html_url
{
    if (self = [super init])
    {
        _name = name;
        _html_url = html_url;
    }
    return self;
}

//@dynamic html_cache;
//@dynamic html_url;
//@dynamic name;

@end

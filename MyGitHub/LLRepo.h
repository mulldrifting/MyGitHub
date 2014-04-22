//
//  LLRepo.h
//  MyGitHub
//
//  Created by Lauren Lee on 4/21/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface LLRepo : NSObject

@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *html_url;
@property (retain, nonatomic) NSData *html_cache;

- (id)initWithName:(NSString *)name withURL:(NSString *)html_url;

@end

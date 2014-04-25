//
//  LLUser.m
//  MyGitHub
//
//  Created by Lauren Lee on 4/24/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "LLUser.h"

@interface LLUser ()

@end

@implementation LLUser

-(id)initWithName:(NSString*)name imagePath:(NSString*)imagePath
{
    if (self = [super init])
    {
        _name = name;
        _imagePath = imagePath;
    }
    
    return self;
}

-(void)downloadImageWithCompletionBlock:(void (^)())completion
{
    [[NSOperationQueue new] addOperationWithBlock:^{
        
        NSData *data = [NSData dataWithContentsOfURL:self.imageURL];
        _image = [UIImage imageWithData:data];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:completion];
    }];
}

-(NSURL*)imageURL
{
    return [NSURL URLWithString:_imagePath];
}

-(void)cancelImageDownload
{
    if (!self.imageDownloadOperation.isExecuting)
    {
        [self.imageDownloadOperation cancel];
    }
}

@end

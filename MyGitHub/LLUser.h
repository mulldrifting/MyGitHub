//
//  LLUser.h
//  MyGitHub
//
//  Created by Lauren Lee on 4/24/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLUser : NSObject

@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *imagePath;
@property (retain, nonatomic) UIImage *image;
@property (retain, nonatomic) NSOperation *imageDownloadOperation;

-(id)initWithName:(NSString*)name imagePath:(NSString*)imagePath;
-(NSURL*)imageURL;
-(void)downloadImageWithCompletionBlock:(void(^)())completion;
-(void)cancelImageDownload;

@end

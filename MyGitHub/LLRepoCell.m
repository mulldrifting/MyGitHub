//
//  LLRepoCell.m
//  MyGitHub
//
//  Created by Lauren Lee on 4/24/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "LLRepoCell.h"

@implementation LLRepoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.label.adjustsFontSizeToFitWidth = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

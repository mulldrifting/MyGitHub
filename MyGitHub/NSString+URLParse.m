//
//  NSString+URLParse.m
//  MyGitHub
//
//  Created by Lauren Lee on 4/23/14.
//  Copyright (c) 2014 Lauren Lee. All rights reserved.
//

#import "NSString+URLParse.h"

@implementation NSString (URLParse)

-(NSDictionary *)breakQueryIntoComponents
{
    NSArray *urlComponents = [self componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    
    for (NSString *keyValuePair in urlComponents)
    {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [pairComponents objectAtIndex:0];
        NSString *value = [pairComponents objectAtIndex:1];
        
        [queryStringDictionary setObject:value forKey:key];
    }

    return queryStringDictionary;
}

@end

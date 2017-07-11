//
//  NSString+Encode.h
//  ExpressionGuestRegistry
//
//  Created by nikhil on 6/3/14.
//  Copyright (c) 2014 quangitia. All rights reserved.
//1.1.4.3

#import <Foundation/Foundation.h>

@interface NSString (Encode)

- (NSString *)encodeToBase64String:(UIImage *)image;
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
@end

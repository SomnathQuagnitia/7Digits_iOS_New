//
//  NSString+Encode.m
//  ExpressionGuestRegistry
//
//  Created by nikhil on 6/3/14.
//  Copyright (c) 2014 quangitia. All rights reserved.
//

#import "NSString+Encode.h"

@implementation NSString (Encode)

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
    
    
        return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                   (CFStringRef)self,
                                                                   NULL,
                                                                   (CFStringRef)@"&€$₹¢£¥ç¿ßóòñ!*'\"();:@=+,/?%#[]%",
                                                                   CFStringConvertNSStringEncodingToEncoding(encoding)));

}


- (NSString *)encodeToBase64String:(UIImage *)image
{
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end

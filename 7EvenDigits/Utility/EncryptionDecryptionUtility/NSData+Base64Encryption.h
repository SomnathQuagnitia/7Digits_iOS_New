//
//  NSData+Base64Encryption.h
//  Jobs4Me
//
//  Created by Neha Salankar on 08/02/13.
//  Copyright (c) 2013 Quagnitia Sys Pvt Lmt. All rights reserved.
//

#import <Foundation/Foundation.h>
void *NewBase64Decode(
                      const char *inputBuffer,
                      size_t length,
                      size_t *outputLength);

char *NewBase64Encode(
                      const void *inputBuffer,
                      size_t length,
                      bool separateLines,
                      size_t *outputLength);


@interface NSData (Base64Encryption)
+ (NSData *)dataFromBase64String:(NSString *)aString;
- (NSString *)base64EncodedString;

@end

//
//  CommonNotification.h
//  MapHook
//
//  Created by Mohini on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "ServerIntegration.h"
//#import "CustomBadge.h"


@interface CommonNotification : NSObject

+(void)setMessageDetailsForChatWithUserID:(NSString *)recieverUserID :(NSDictionary*) userInfo;
+(NSMutableArray *)getMessageDetailsForChatWithUserID:(NSString *)recieverUserID;
+ (void)resetMessagesAfterLogoutForAll;
+ (void)resetMessagesForUser : (NSString *)UserId;
+(NSData *)getImageForChatWithUserID:(NSString *)recieverUserID;
+(NSString *)getImageURLForChatWithUserID:(NSString *)recieverUserID;
+(void)setImageForChatWithRecivedUserID:(NSString *)recieverUserID :(NSData*) userImageInfo;
+(NSData *)getImageKriForChatWithUserID:(NSString *)recieverUserID;
+ (void)resetImageBeforeAdd;
+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
+ (NSString *)createRandomName;
+ (UIImage*)loadImage:(NSURL *)videoURL;
+ (void)updatedownloadstatus:(NSString *)downloadtype senderuserid:(NSString *)senderid indextypeofmessage:(NSInteger) itype mediadata:(NSData *)mediadata filename:(NSString *)filename ;
@end

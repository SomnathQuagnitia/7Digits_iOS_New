//
//  CommonNotification.m
//  MapHook
//
//  Created by Mohini on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommonNotification.h"
@implementation CommonNotification

+(void)setMessageDetailsForChatWithUserID:(NSString *)recieverUserID :(NSDictionary*) userInfo
{
    NSUserDefaults *applicationUserDefault;
    applicationUserDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *messagesDict = [[NSMutableDictionary alloc] initWithDictionary:[applicationUserDefault valueForKey:@"Messages"]];
    NSString *key = [NSString stringWithFormat:@"Messages%@",recieverUserID];
    NSMutableArray *recieverArray =[[NSMutableArray alloc] initWithArray:[messagesDict valueForKey:key]];
    if (recieverArray == nil) {
        recieverArray = [[NSMutableArray alloc] init];
    }
    if (messagesDict == nil) {
        messagesDict = [[NSMutableDictionary alloc] init];
    }
    [recieverArray addObject:userInfo];
    [messagesDict setObject:recieverArray forKey:key];
    [applicationUserDefault setObject:messagesDict forKey:@"Messages"];
    [applicationUserDefault synchronize];
}

+ (void)updatedownloadstatus:(NSString *)downloadtype senderuserid:(NSString *)senderid indextypeofmessage:(NSInteger) itype mediadata:(NSData *)mediadata filename:(NSString *)filename ;
{
    
    NSUserDefaults *applicationUserDefault;
    applicationUserDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *messagesDict = [[NSMutableDictionary alloc] initWithDictionary:[applicationUserDefault valueForKey:@"Messages"]];
    NSString *key = [NSString stringWithFormat:@"Messages%@",senderid];
    NSMutableArray *recieverArray =[[NSMutableArray alloc] initWithArray:[messagesDict valueForKey:key]];
    NSMutableDictionary *userInfo=[[NSMutableDictionary alloc]initWithDictionary:[recieverArray objectAtIndex:itype]];
    [userInfo setValue:filename forKey:@"Filepath"];
    [userInfo setValue:@"1" forKey:@"download"];
    [userInfo setValue:mediadata forKey:@"attachment"];
    [recieverArray replaceObjectAtIndex:itype withObject:userInfo];
    [messagesDict setObject:recieverArray forKey:key];
    [applicationUserDefault setObject:messagesDict forKey:@"Messages"];
    [applicationUserDefault synchronize];
}

+(void)setImageForChatWithRecivedUserID:(NSString *)recieverUserID :(NSData*) userImageInfo
{
    NSUserDefaults *applicationUserDefault;
    applicationUserDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *messagesDict = [[NSMutableDictionary alloc] initWithDictionary:[applicationUserDefault valueForKey:@"Images"]];
    NSString *key = [NSString stringWithFormat:@"Images%@",recieverUserID];
    NSMutableArray *recieverArray =[[NSMutableArray alloc] initWithArray:[messagesDict valueForKey:key]];
    if (recieverArray == nil)
    {
        recieverArray = [[NSMutableArray alloc] init];
    }
    if (messagesDict == nil)
    {
        messagesDict = [[NSMutableDictionary alloc] init];
    }
    [recieverArray addObject:userImageInfo];
    [messagesDict setObject:recieverArray forKey:key];
    [applicationUserDefault setObject:messagesDict forKey:@"Images"];
    [applicationUserDefault synchronize];
}

+(NSData *)getImageKriForChatWithUserID:(NSString *)recieverUserID
{
    NSUserDefaults *applicationUserDefault;
    applicationUserDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *messagesDict = [applicationUserDefault valueForKey:@"Images"];
    NSString *key = [NSString stringWithFormat:@"Images%@",recieverUserID];
    NSMutableArray *recieverArray =[[NSMutableArray alloc] initWithArray:[messagesDict valueForKey:key]];
    if (recieverArray.count > 0) {
        NSData *imageData = [[recieverArray objectAtIndex:0] valueForKey:@"Images"];
        return imageData;
    }
    return nil;
}

+ (void)resetImageBeforeAdd
{
    NSUserDefaults *applicationUserDefault;
    applicationUserDefault = [NSUserDefaults standardUserDefaults];
    [applicationUserDefault setValue:nil forKey:@"Images"];
    [applicationUserDefault synchronize];
}

+(NSMutableArray *)getMessageDetailsForChatWithUserID:(NSString *)recieverUserID
{
    NSString *chatid;
    NSUserDefaults *applicationUserDefault;
    applicationUserDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *messagesDict = [applicationUserDefault valueForKey:@"Messages"];
    chatid = [applicationUserDefault valueForKey:@"Messages"];
    NSString *key = [NSString stringWithFormat:@"Messages%@",recieverUserID];
    NSMutableArray *recieverArray =[[NSMutableArray alloc] initWithArray:[messagesDict valueForKey:key]];
    return recieverArray;
}

+ (void)resetMessagesAfterLogoutForAll{
    NSUserDefaults *applicationUserDefault;
    applicationUserDefault = [NSUserDefaults standardUserDefaults];
    [applicationUserDefault setValue:nil forKey:@"Messages"];
    [applicationUserDefault synchronize];
}
+ (void)resetMessagesForUser : (NSString *)UserId
{
    NSUserDefaults *applicationUserDefault;
    applicationUserDefault = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"Messages%@",UserId];
    NSMutableDictionary *messagesDict=[[NSMutableDictionary alloc] initWithDictionary:[applicationUserDefault valueForKey:@"Messages"]];
    [messagesDict setValue:nil forKey:key];
    [applicationUserDefault setObject:messagesDict forKey:@"Messages"];
    [applicationUserDefault synchronize];
}

+(NSData *)getImageForChatWithUserID:(NSString *)recieverUserID
{
    NSMutableArray *recieverArray =[[NSMutableArray alloc] initWithArray:[self getMessageDetailsForChatWithUserID:recieverUserID]];
    if (recieverArray.count > 0) {
        NSData *imageData = [[recieverArray objectAtIndex:0] valueForKey:@"image"];
        return imageData;
    }
    return nil;
}

+(NSString *)getImageURLForChatWithUserID:(NSString *)recieverUserID
{
    NSMutableArray *recieverArray =[[NSMutableArray alloc] initWithArray:[self getMessageDetailsForChatWithUserID:recieverUserID]];
    if (recieverArray.count > 0) {
        NSString *imageData = [[recieverArray objectAtIndex:0] valueForKey:@"image"];
        return imageData;
    }
    return nil;
}


+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL
                             atTime:(NSTimeInterval)time
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetIG =
    [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetIG.appliesPreferredTrackTransform = YES;
    assetIG.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *igError = nil;
    thumbnailImageRef =
    [assetIG copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)
                    actualTime:NULL
                         error:&igError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", igError );
    
    UIImage *thumbnailImage = thumbnailImageRef
    ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]
    : nil;
    
    return thumbnailImage;
}


+ (UIImage*)loadImage:(NSURL *)videoURL
{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 60);
    CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
    NSLog(@"err==%@, imageRef==%@", err, imgRef);
    return [[UIImage alloc] initWithCGImage:imgRef];
    
}


+ (NSString *)createRandomName
{
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString *randomName = [NSString stringWithFormat:@"M%f", timeStamp];
    randomName = [randomName stringByReplacingOccurrencesOfString:@"." withString:@"" ];
    return randomName;
}

@end

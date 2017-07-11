//
//  ConnectionManager.h
//  WSTest
//
//  Created by Vijay on 17/09/13.
//  Copyright (c) 2013 Vijay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "parameters.h"
#import "Constant.h"
#import "NSString+Encode.h"


@interface ConnectionManager : NSObject
{
    id aDelegate;
    NSURLConnection *serverConnectionObj;
    NSMutableData *webData;
    SEL selector;
    NSString *mediaType;
    int totalSeconds;
    NSTimer *Timer;
    NSData *deleteData;
    NSMutableURLRequest *deleteURL;
   
}
@property (nonatomic,strong)NSMutableData *webData;

- (void)getWebData:(id)aDelegate commandURL:(NSString*)commandURL;

- (void)getWebDataFromRequestData:(NSData*)reqData URL:(NSString *)Baseurl;

- (id)initWithTarget: (id) delegate_in selector:(SEL) function;

- (void)webOperationEnded:(NSDictionary *)responseDict;

- (void)UploadImage:(NSString *)ImageName Image:(UIImage *)Image commandURL:(NSString*)commandURL;
-(void)uploadVideo:(NSString *)VideoName Video:(NSData *)Video commandURL:(NSString*)commandURL;
- (void)UploadChatImage:(NSString *)ImageName Image:(UIImage *)Image commandURL:(NSString*)commandURL;
-(void)uploadChatVideo:(NSString *)VideoName uploadVideo:(NSData *)uploadVideo commandURL:(NSString*)commandURL;
//- (void)webOperationEndForVideo;
@end

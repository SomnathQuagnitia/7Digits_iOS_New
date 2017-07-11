//
//  ChatMeassageVC.h
//  7EvenDigits
//
//  Created by NikhilD on 11/14/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonNotification.h"
#import "JSMessagesViewController.h"
#import "Parameters.h"
#import "ConnectionManager.h"

@interface ChatMeassageVC : JSMessagesViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSString *userText;
    UIButton *deleteHistoryButton;
     UIImagePickerController *pickerObj;
    NSString *insertMediaType;
    NSString *mediaType;
    NSString *msgId;
    NSData *chosevideo;
    NSTimer *videoTimer;
    BOOL videoFlag;
    BOOL cameraFlag;
    int totalSeconds;
    ConnectionManager *ConnectionManagerObj;
    NSString *fileName;
    NSString *type;
    NSData *jsonData;
}

@property(nonatomic,strong)NSString *chatUserID;
@property(nonatomic,strong)NSString *userStatus;
@property(nonatomic,strong)NSString *titleName;


@property(nonatomic,strong)NSURL *chatUserImageURL;
@property(nonatomic,strong)NSURL *chatMessageImageURL;

@property(nonatomic,strong)NSURL *chatUserVideoURL;
@property(nonatomic,strong)NSData *chatIncomingUserImageUrl;
@property(nonatomic,assign)BOOL cameraBtnTag1;
@property BOOL StopWevservice;

- (void)reloadTable;
//- (void)finishSend:(BOOL)isMedia;
-(void)callChatHistoryWebService;


@end

//
//  AppDelegate.h
//  TextEditor
//
//  Created by NikhilD on 9/29/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "SplashViewController.h"
#import "Constant.h"
#import "CommonNotification.h"
#import "JSMessagesViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>



@class ChatMeassageVC;
@class LoginViewController;
@class ComposeViewController;
@class SplashViewController;
@class MenuViewController;
@class ChatContactsViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,HarpyDelegate>
{
    Reachability* internetReachable;
    Reachability* hostReachable;
    NetworkStatus internetStatus;
    ServerIntegration *serviceIntegration;
    
    NSBundle *mainBundle;
    NSString *filePath;
    NSData *fileData;
    BOOL falgForChat;
    BOOL isAcceptAlertShow;
    BOOL userIsDirctlyLogging;
    UIBackgroundTaskIdentifier  bgTask ;

}
@property (strong, nonatomic)NSMutableDictionary *userInfoDictionary;
@property (strong, nonatomic) ChatContactsViewController *chatContVC;
@property (strong, nonatomic) ChatMeassageVC *chatMessage;
@property (strong, nonatomic) MenuViewController *menuVcObj;

@property (strong, nonatomic) SplashViewController *splashViewController;
@property (strong, nonatomic) LoginViewController *loginViewController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (readonly) NetworkStatus internetStatus;
@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) ComposeViewController *obj;


@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic, strong) NSTimer *timer;

@property (strong, nonatomic) NSString *iOSDeviceToken;


// global instance of the delegate
//------------------------------------------------------------------------------
extern AppDelegate* objAppDelegate;
@end

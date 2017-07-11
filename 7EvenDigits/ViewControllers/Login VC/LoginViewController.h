//
//  LoginViewController.h
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parameters.h"
#import "InboxMessageViewController.h"
#import "ServerIntegration.h"
#import "ForgotUserNameViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"
@class SplashViewController;

@interface LoginViewController : BaseViewController<UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    UITextField *currentTextFeild;
    ServerIntegration *serviceIntegration;
    AppDelegate *appDeleagated;
    NSTimer *timer;
    
    UIScrollView *scrollWebView;
    IBOutlet UIPageControl *pageControl;
    NSArray *vidIDArr;
    UISwipeGestureRecognizer *swipe;
    CGFloat scrollAndVideoheight;
   }


 @property (strong, nonatomic) IBOutlet UIWebView *webViewForVideo22;
@property (strong, nonatomic) IBOutlet UIWebView *webViewForVideo21;
@property (strong, nonatomic) IBOutlet UIWebView *webViewForVideo12;
@property (strong, nonatomic)IBOutlet UIWebView *webViewForVideo11;

@property (strong, nonatomic)IBOutlet UITextField *textFieldForUserName;
@property (strong, nonatomic)IBOutlet UITextField *textFieldForPassword;
@property(strong,nonatomic)SplashViewController *splashViewController;

-(IBAction)handleJoinNow:(id)sender;
-(IBAction)handleSignIn:(id)sender;
-(IBAction)handleForgotUsername:(id)sender;
-(IBAction)handleForgotPassword:(id)sender;
- (IBAction)handlePinterestLink:(id)sender;
- (IBAction)handleTwitterLink:(id)sender;
- (IBAction)handleFacebookLink:(id)sender;


//-(IBAction)handleVideo11:(id)sender;
//-(IBAction)handleVideo12:(id)sender;
//-(IBAction)handleVideo21:(id)sender;
//-(IBAction)handleVideo22:(id)sender;

//-(void)firstimagetouch;
//-(void)setupScrollView:(UIScrollView*)scrMain;
//-(void)onSwipe:(UISwipeGestureRecognizer *)gesture;

@end

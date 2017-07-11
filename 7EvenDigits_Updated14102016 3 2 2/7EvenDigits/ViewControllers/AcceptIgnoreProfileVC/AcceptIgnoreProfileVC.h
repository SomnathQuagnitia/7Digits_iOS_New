//
//  AcceptIgnoreProfileVC.h
//  7EvenDigits
//
//  Created by Neha_Mac on 30/06/15.
//  Copyright (c) 2015 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerIntegration.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "UIImageView+Haneke.h"

@interface AcceptIgnoreProfileVC : UIViewController<UIScrollViewDelegate,UIWebViewDelegate>
{
    ServerIntegration *serviceIntegration;
    AppDelegate *appDeleagated;
    NSString *isContactProfileExist;
    NSString *currentUserProfileId;
     IBOutlet UIScrollView *profileDataScrollView;
    IBOutlet UIImageView *videoImage;
    
    IBOutlet UIImageView *buttonPlayImage;
    NSData *PlayVideoData;
    MPMoviePlayerController *Player;
    NSString *videoPlayFromAcceptPersonal;
    AVPlayer *player;
    AVPlayerItem * playerItem;
    NSURL *MyVideoUrl;
    BOOL success;
}

@property(strong,nonatomic)MenuViewController *menuVc;
@property (strong, nonatomic) IBOutlet UIButton *acceptBtn;
@property (strong, nonatomic) IBOutlet UIButton *ignoreBtn;

@property(strong,nonatomic)NSMutableArray *profileDataArray;
@property(strong,nonatomic)IBOutlet UILabel *userIdLabel;
@property(strong,nonatomic)IBOutlet UILabel *firstNameLabel;
@property(strong,nonatomic)IBOutlet UIWebView *notesDetailWebView;
@property(strong,nonatomic)IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UIButton *digitsButton;

//Play video functionality
@property (strong, nonatomic) IBOutlet UIButton *ButtonPlay;
@property (strong,nonatomic) NSString *playVideoURL;


@end

//
//  AcceptIgnoreProfProfileVC.h
//  7EvenDigits
//
//  Created by Neha_Mac on 30/06/15.
//  Copyright (c) 2015 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerIntegration.h"
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "UIImageView+Haneke.h"

@interface AcceptIgnoreProfProfileVC : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UIWebViewDelegate>
{
    AVPlayer *player;
    AVPlayerItem * playerItem;
    IBOutlet UIScrollView *profileScrollView;
    AppDelegate *appDeleagated;
    ServerIntegration *serviceIntegration;
      NSString *isContactProfileExist;
    NSString *currentUserProfileId;
     IBOutlet UIScrollView *profileDataScrollView;
    NSMutableString *addressString;
      IBOutlet UIImageView *videoImage;
    BOOL success;
    IBOutlet UIImageView *playBtnImage;
    NSData *VideoData;
    MPMoviePlayerController *videoPlayer;
    NSString *videoPlayforAccept;
     NSURL *MyVideoUrl; 
}
@property(strong,nonatomic)NSMutableArray *professionalProfileArray;
@property (strong, nonatomic) IBOutlet UIButton *acceptBtn;
@property (strong, nonatomic) IBOutlet UIButton *ignoreBtn;

@property(strong,nonatomic)IBOutlet UILabel *userIdLabel;
@property(strong,nonatomic)IBOutlet UILabel *fullNameLabel;
@property(strong,nonatomic)IBOutlet UIWebView *notesDetailWebView;
@property(strong,nonatomic)IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *companyLabel;
@property (strong, nonatomic) IBOutlet UITextView *addressTextView;
@property (strong, nonatomic) IBOutlet UIButton *digitsButton;
@property (strong, nonatomic) IBOutlet UIButton *workButton;
@property (strong, nonatomic) IBOutlet UIButton *mobileButton;

//Play video functionality
@property (strong, nonatomic) IBOutlet UIButton *playBtn;
@property (strong,nonatomic) NSString *playVideoUrl;

@end

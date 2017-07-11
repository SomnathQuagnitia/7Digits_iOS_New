//
//  actualProfessionalVC.h
//  7EvenDigits
//
//  Created by nikhil on 11/21/16.
//  Copyright © 2016 Quagnitia Systems. All rights reserved.
//

#import "BaseViewController.h"
#import "Parameters.h"
#import "Constant.h"
#import "HomeViewController.h"
#import "EditProfessionalProfile.h"
#import "ServerIntegration.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "UIImageView+Haneke.h"

@interface actualProfessionalVC : BaseViewController<UIScrollViewDelegate,UITextFieldDelegate,UIWebViewDelegate>
{
    IBOutlet UIScrollView *profileScrollView;
    AppDelegate *appDeleagated;
    ServerIntegration *serviceIntegration;
    IBOutlet UIView *checkUserExistPopUpView;
    IBOutlet UIView *popUpBackgroundView;
    IBOutlet UILabel *userNameExistLabel;
    NSString *sendProfilePressed;
    IBOutlet UITextField *usernameTextField;
    NSString *searchUserName;
    AVPlayer *player;
    BOOL success;
  AVPlayerItem * playerItem;
    EditProfessionalProfile *editProfessionalProfile;
    IBOutlet UIScrollView *profileNotesScrollView;
    NSMutableString *addressString;
    MPMoviePlayerController *moviePlayer;
    IBOutlet UIImageView *playImage;
    NSData *playVideoData;
    NSString *videoPlayFromFile;
    NSURL *MyVideoUrl;
}
@property(strong,nonatomic)NSMutableArray *professionalProfileArray;
@property (strong, nonatomic) IBOutlet UIView *viewForProfileData;

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
@property (strong, nonatomic) IBOutlet UITextView *titleTextView;
@property (strong, nonatomic) IBOutlet UITextView *companyTextView;

@property(strong,nonatomic) IBOutlet UIImageView *placeholderImageForVideo;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong,nonatomic) NSString *videoUrl;
@property (strong, nonatomic) IBOutlet UIButton *publicStatusBtn;
@property (strong, nonatomic) IBOutlet UIButton *privateStatusBtn;

@end

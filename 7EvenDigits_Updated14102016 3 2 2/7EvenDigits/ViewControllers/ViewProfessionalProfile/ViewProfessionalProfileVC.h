//
//  ViewProfessionalProfileVC.h
//  7EvenDigits
//
//  Created by Neha_Mac on 19/06/15.
//  Copyright (c) 2015 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
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

@interface ViewProfessionalProfileVC : BaseViewController<UIScrollViewDelegate,UITextFieldDelegate,UIWebViewDelegate>
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
   // AVPlayer *player;
   // AVPlayerItem * playerItem;
    EditProfessionalProfile *editProfessionalProfile;
    IBOutlet UIScrollView *profileNotesScrollView;
    NSMutableString *addressString;
   // MPMoviePlayerController *moviePlayer;
    IBOutlet UIImageView *playImage;
    NSData *playVideoData;
    NSString *videoPlayFromFile;
    NSURL *MyVideoUrl;
    BOOL success;
    UIBarButtonItem *rightBarBtn;
}
@property (strong, nonatomic) IBOutlet UILabel *locationTxtLbl;
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

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;;
@property (strong, nonatomic) AVPlayerItem * playerItem;;

@property(strong,nonatomic) IBOutlet UIImageView *placeholderImageForVideo;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong,nonatomic) NSString *videoUrl;
@property (strong, nonatomic) IBOutlet UIButton *publicStatusBtn;
@property (strong, nonatomic) IBOutlet UIButton *privateStatusBtn;

- (IBAction)publicStatus:(id)sender;
- (IBAction)privateStatus:(id)sender;

@end

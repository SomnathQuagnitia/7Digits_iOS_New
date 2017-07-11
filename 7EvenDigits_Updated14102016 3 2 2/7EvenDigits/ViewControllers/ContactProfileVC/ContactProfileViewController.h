//
//  ContactProfileViewController.h
//  7EvenDigits
//
//  Created by Krishna on 01/10/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerIntegration.h"
#import "UIImageView+Haneke.h"
#import "Parameters.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@class ContactViewController;
@class AddContactViewController;
@interface ContactProfileViewController : UIViewController<UITextFieldDelegate,UIWebViewDelegate>
{
    ServerIntegration *serviceIntegration;
     AppDelegate *appDeleagated;
    IBOutlet UIView *checkUserExistPopUpView;
    IBOutlet UIView * popUpBackgroundView;
    IBOutlet UILabel *userNameExistLabel;
    NSString *sendProfilePressed;
    NSString *searchUserName;
    
    IBOutlet UITextField *usernameTextField;
    
    AddContactViewController *addc;
    
    IBOutlet UIScrollView *profileDataScrollView;
   // AVPlayer *player;
   // AVPlayerItem * playerItem;

   // MPMoviePlayerController *moviePlayer;
    NSData *playVideoData;
    NSString *videoPlayFromAcceptContact;
    NSURL *MyVideoUrl;
    BOOL success;
}
@property(strong,nonatomic)AddContactViewController *addc;
@property(strong,nonatomic)MenuViewController *menuVc;

@property (strong, nonatomic) IBOutlet UIView *viewForSendBtn;
@property(strong,nonatomic)AddContactViewController *addContVc;
@property(strong,nonatomic)NSMutableArray *contactArray;
@property(strong,nonatomic)ContactViewController *objContactVC;
@property (strong, nonatomic) IBOutlet UIImageView *statusImage;
@property(strong,nonatomic)IBOutlet UILabel *userIdLabel;
@property(strong,nonatomic)IBOutlet UILabel *firstNameLabel;
@property(strong,nonatomic)IBOutlet UILabel *lastNameLabel;
@property(strong,nonatomic)IBOutlet UIWebView *notesDetailWebView;
@property(strong,nonatomic)IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UIButton *digitsButton;

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;;
@property (strong, nonatomic) AVPlayerItem * playerItem;

@property(strong,nonatomic) IBOutlet UIImageView *placeholderImageForVideo;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong,nonatomic) NSString *videoPersonalUrl;
@property(strong,nonatomic)IBOutlet UIImageView *playImage;
@property (strong, nonatomic) IBOutlet UIButton *publicStatusBtn;
@property (strong, nonatomic) IBOutlet UIButton *privateStatusBtn;

//- (IBAction)publicStatusAction:(id)sender;
//- (IBAction)privateStatusAction:(id)sender;

@end

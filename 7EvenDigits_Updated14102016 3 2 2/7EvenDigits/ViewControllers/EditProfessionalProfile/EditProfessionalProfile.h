//
//  EditProfessionalProfile.h
//  7EvenDigits
//
//  Created by Neha_Mac on 19/06/15.
//  Copyright (c) 2015 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSSRichTextEditor.h"
#import "ServerIntegration.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SearchViewController.h"
#import "UIImageView+Haneke.h"

typedef enum pickerType{
    video,
    image,
    videoImage
}mediaPicker;

@interface EditProfessionalProfile : ZSSRichTextEditor<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate,UITextViewDelegate>
{
    
    ServerIntegration *serviceIntegration;
    AppDelegate *appDeleagated;
    NSString *htmlMessageText;
    IBOutlet UILabel *noFileChoosen;
    IBOutlet UILabel *noFileChoosenVideo;
    NSString *isVideoImage;
    NSString *myStr;
    BOOL cancelButtonClick;
    NSString *profileId;
    SearchViewController *searchVC;
    NSString *defaultText;
    NSMutableString *addressText;
    NSMutableString *locationText;
    BOOL success;
    mediaPicker pickerTypes;
    NSURL *videoUrl;
    MPMoviePlayerController *moviePlayer;
    NSData *videoData;
    BOOL isVideoDeleted;
    BOOL isVideoChanged;
    NSString *isImageChanged;
    IBOutlet UIImageView *rotateImageView;
    IBOutlet UIView *rotateView;
    UIImage *selectedImageToRotate;
    NSInteger selectedImageTag;
    NSString *isImageSelctedFOrVideo;
    NSString *isProfileDataSet;
    int status;
    NSString *OccupationString;
    
}

@property(strong,nonatomic)NSString *isEditingMyProfile;

@property(strong,nonatomic)IBOutlet UIImageView *imageViewForImage;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForUserName;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForFirstName;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForLastName;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForTitle;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForCompany;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForEmail;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForDigits;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForMobile;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForWorkNumber;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForOccupation;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForAddress1;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForAddress2;
@property (strong, nonatomic) IBOutlet UITextField *textFieldForState;
@property (strong, nonatomic) IBOutlet UITextField *textFieldForCity;
@property (strong, nonatomic) IBOutlet UITextField *textFieldForZipCode;

@property(strong,nonatomic)IBOutlet UITextView *addressTextView;
@property(strong,nonatomic)NSMutableArray *editProfessionalProfileArray;
@property(strong,nonatomic)IBOutlet UIImageView *placeholderImageVdo;

@property(strong,nonatomic)UIImage *videoImageFromBack;
@property(strong,nonatomic)UIImage *userImage;
@property (strong,nonatomic) NSString *videoStringPath;

@property (strong, nonatomic) IBOutlet UIButton *publicStatusBtn;
@property (strong, nonatomic) IBOutlet UIButton *privateStatusBtn;

@property(strong,nonatomic)NSString *stateId;
@property(strong,nonatomic)NSString *cityId;
@property(strong,nonatomic)NSString *zipCodeId;

@property (strong, nonatomic) IBOutlet UIButton *cancelCityBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelStateBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelZipCodeBtn;

- (IBAction)publicStatusAction:(id)sender;
- (IBAction)privateStatusAction:(id)sender;


- (IBAction)handleStateBtn:(UIButton *)sender;
- (IBAction)handleCityBtn:(UIButton *)sender;
- (IBAction)handleZipBtn:(UIButton *)sender;
- (IBAction)handleCancelBtnForSCZ:(UIButton *)sender;




@end

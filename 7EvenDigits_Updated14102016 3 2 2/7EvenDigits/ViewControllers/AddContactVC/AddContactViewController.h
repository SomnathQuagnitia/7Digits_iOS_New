//
//  AddContactViewController.h
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.

//  ZSSDemoViewController.h
//  TextEditor
//
//  Created by NikhilD on 9/29/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSSRichTextEditor.h"
#import "ServerIntegration.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "UIImageView+Haneke.h"

@class ContactProfileViewController;

typedef enum personalProfilePickerType{
    pickVideo,
    pickImage,
    videoimage
}sourcePicker;

@interface AddContactViewController : ZSSRichTextEditor<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    
    ServerIntegration *serviceIntegration;
    AppDelegate *appDeleagated;
    NSString *htmlMessageText;
    id addContactVCId;
    IBOutlet UILabel *noFileChoosen;
    
    BOOL cancelButtonClick;
    NSString *myStr;
    
    NSString *profileId;
//     BOOL isImagePicked;
//     BOOL isImageDeleted;
    
    NSURL *videourl;
    sourcePicker media;
    MPMoviePlayerController *moviePlayer;
    IBOutlet UILabel *noFileChoosenVideo;
    NSData *uploadVideoData;
    BOOL isVideoDeletedFromServer;
    NSString *isVideoIMage;
    IBOutlet UIImageView *rotateImageView;
    IBOutlet UIView *rotateView;
    UIImage *selectedImageToRotate;
    NSInteger selectedImageTag;
    NSString *isImageSelctedFOrVideo;
    NSString *isProfileDataSet;
    NSString *contactIdToAdd;
    BOOL isVideoChanged;
    NSString *isImageChanged;
    NSURL *MyVideoUrl;
    int status;
    NSMutableString *innerText;
}
-(IBAction)handelBrowseImage:(id)sender;
-(IBAction)handelSave:(UIButton *)sender;
-(IBAction)handelCancel:(id)sender;
-(IBAction)handleDeleteBtn:(id)sender;
- (IBAction)publicBtnAction:(id)sender;
- (IBAction)privateBtnAction:(id)sender;

@property(strong,nonatomic)IBOutlet UIImageView *imageViewForImage;
@property(strong,nonatomic)NSString *isEditingMyProfile;
@property(strong,nonatomic)id addContactVCId;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForUserName;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForFirstName;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForLastName;
@property (strong, nonatomic) IBOutlet UITextField *textfieldForEmail;
@property (strong, nonatomic) IBOutlet UITextField *textfieldForDigits;
@property (strong, nonatomic) IBOutlet UITextField *textFieldForOccupation;


@property (weak, nonatomic) IBOutlet UIImageView *imgObj;
@property(strong,nonatomic)ContactProfileViewController *contactProfilVc;
@property(strong,nonatomic)NSMutableArray *dataForEditContactArray;

@property(strong,nonatomic)IBOutlet UIView *videoView;
@property(strong,nonatomic)IBOutlet UIImageView *placeholderImageVdo;
@property (strong,nonatomic) NSString *videoStringPath;

@property(strong,nonatomic)UIImage *videoImageFromBack;
@property(strong,nonatomic)UIImage *userImage;
@property (strong, nonatomic) IBOutlet UIButton *publicStatusBtn;
@property (strong, nonatomic) IBOutlet UIButton *privateStatusBtn;



@end



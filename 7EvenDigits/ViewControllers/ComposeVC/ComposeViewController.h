//
//  ZSSDemoViewController.h
//  TextEditor
//
//  Created by NikhilD on 9/29/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSSRichTextEditor.h"
#import "ServerIntegration.h"
#import "SearchViewController.h"
#import "Constant.h"
#import "NSString+Encode.h"

@class PreviewPostViewController;
@class DraftViewController;


@interface ComposeViewController : ZSSRichTextEditor<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
    {
        IBOutlet UIButton *radioBtnLessThanCompose;
        IBOutlet UIButton *radioBtnMoreThanCompose;
        SearchViewController *searchVC;
        ServerIntegration *serviceIntegration;
        NSString *htmlMessageText;
        AppDelegate *appDeleagated;
        IBOutlet UILabel *noFileChoosen;
        BOOL flagForHandelHome;
        BOOL flagForHandelCancel;
        
        NSString *strForButtonPrevoiusState;
        NSString *strForButtonCurrentState;
        
        NSString *RadioButtonPrevoiusState;
        NSString *RadioButtonCurrentState;
        
        BOOL isImagePickedInCompose;
    }
    @property (strong, nonatomic)IBOutlet UIImageView *img;
    @property (strong, nonatomic)NSString *htmlMessageText;
    @property (strong, nonatomic)NSString *messageIdForUpdateDraft;
    @property (strong, nonatomic)NSString *messagePlianText;
    @property (strong, nonatomic) DraftViewController *objDraftVc;
    @property (strong, nonatomic) PreviewPostViewController *prevPost;
    @property (strong, nonatomic) NSMutableArray *objDraftArray;
    @property (strong, nonatomic) IBOutlet UIButton *everyOneBtn;
    @property (strong, nonatomic) IBOutlet UIButton *w2mBtn;
    @property (strong, nonatomic) IBOutlet UIButton *w2wBtn;
    @property (strong, nonatomic) IBOutlet UIButton *m2mBtn;
    @property (strong, nonatomic) IBOutlet UIButton *m2wBtn;
    @property (strong, nonatomic) IBOutlet UIButton *radioBtnLessThanCompose;

    @property (strong, nonatomic) IBOutlet UIButton *CancelDataButton;
    
-(IBAction)handelRadioButtonLessThanCompose:(UIButton *)sender;
-(IBAction)handelRadioButtonMoreThanCompose:(UIButton *)sender;
-(IBAction)handelSave:(UIButton *)sender;
    
-(IBAction)handelStateName;
-(IBAction)handelCityName;
-(IBAction)handelZipCode;
    
    @property(strong,nonatomic)NSString *stateId;
    @property(strong,nonatomic)NSString *cityId;
    @property(strong,nonatomic)NSString *zipCodeId;
- (IBAction)handleCancel:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cancelStateBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelCityBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelZipBtn;
- (IBAction)handelCancelButton:(id)sender;

-(void)clearComposeData;
@end



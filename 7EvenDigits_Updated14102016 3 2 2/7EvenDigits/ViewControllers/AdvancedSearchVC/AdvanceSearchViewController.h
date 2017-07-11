//
//  AdvanceSearchViewController.h
//  7EvenDigits
//
//  Created by Krishna on 01/10/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerIntegration.h"
#import "Parameters.h"
#import "SearchViewController.h"
#import "AppDelegate.h"
@class QuickSearchViewController;
@class PostedMessageViewController;

@interface AdvanceSearchViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate>
{
    BOOL radioBtnFlag;
    ServerIntegration *serviceIntegration;
    SearchViewController *searchVC;
    PostedMessageViewController *postedmsgVC;
    AppDelegate *appDeleagated;
    UITextField *currentTxtFld;
    NSString* lessThan30String;
}
- (IBAction)handelCancelButton:(id)sender;
@property(strong,nonatomic)IBOutlet UIScrollView *scrollViewObj;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForTitle;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForState;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForCity;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForZip;
@property (strong, nonatomic) IBOutlet UIButton *radioBtnLessThan;
@property (strong, nonatomic) IBOutlet UIButton *radioButtonMoreThan;
@property (strong, nonatomic) IBOutlet UIButton *everyOneBtn;
@property (strong, nonatomic) IBOutlet UIButton *w2mBtn;
@property (strong, nonatomic) IBOutlet UIButton *w2wBtn;
@property (strong, nonatomic) IBOutlet UIButton *m2mBtn;
@property (strong, nonatomic) IBOutlet UIButton *m2wBtn;

@property(strong, nonatomic)PostedMessageViewController *postedmsgVC;
@property(strong, nonatomic)QuickSearchViewController *quickSearchVC;
@property(strong, nonatomic)NSMutableArray *postedMessagesFormAdvanceSearch;
-(IBAction)handelRadioButtonLessThanSearch:(UIButton *)sender;
-(IBAction)handelAdvancedSearchGo:(id)sender;
-(IBAction)handelCheckBoxM2M:(UIButton *)sender;

-(IBAction)handelStateList:(UIButton *)sender;
-(IBAction)handelCityList:(UIButton *)sender;
-(IBAction)handelZipList:(UIButton *)sender;



@property(strong,nonatomic)NSString *stateId;
@property(strong,nonatomic)NSString *cityId;
@property(strong,nonatomic)NSString *zipCodeId;


- (IBAction)handleCancel:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cancelStateBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelCityBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelZipBtn;


@end

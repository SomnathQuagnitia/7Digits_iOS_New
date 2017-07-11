//
//  InboxMessageViewController.h
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InboxMessageCustomCell.h"
#import "AcceptIgnoreProfileVC.h"
#import "AcceptIgnoreProfProfileVC.h"
@class MenuViewController;
@class AppDelegate;
@class ServerIntegration;


@interface InboxMessageViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UITextViewDelegate>
{
    BOOL chekBoxBtnBool;
    NSMutableArray *inboxMessageArray;
    AppDelegate *objAppDelegate;
    MenuViewController *objMenuViewController;
    UITextView *currentTxtView;
    BOOL searching;
    NSMutableString *firstName;
    int profileType;
    NSString *isContactProfileExist;
    NSString *currentUserProfileId;
    NSMutableArray *inboxSelectedItemArray;
    NSMutableArray *inboxSelectedItemUserIdArray;
    NSArray *inboxListArray;
    NSInteger indexTag;
    NSInteger index;
    UIButton *btnAll;
    BOOL allBtnClk;
    IBOutlet UILabel *noRecordFoundLabel;
    ServerIntegration *serviceIntegration;
    UIButton *btnDelete;
    NSIndexPath *indexpath;
    AppDelegate *appDeleagated;
    NSString *profileUserID;
    IBOutlet UISearchBar *searchBarforInbox;
    NSMutableDictionary *selectedMessageDict;
    NSMutableArray *displayProfileArray;
}
@property (strong, nonatomic) IBOutlet UILabel *PopUpTitle;
@property (strong, nonatomic) IBOutlet UIButton *PopUpAcceptBtn;
@property (strong, nonatomic) IBOutlet UIButton *PopUpIgnoreBtn;
@property (strong, nonatomic) IBOutlet UILabel *PopUpName;
@property (strong, nonatomic) IBOutlet UILabel *PopUpUserID;
@property (strong, nonatomic) IBOutlet UIImageView *PopUpImgView;
@property (strong, nonatomic) IBOutlet UIView *PopUpView;
@property (strong, nonatomic) IBOutlet UITextView *MsgTxtView;
@property(strong,nonatomic)NSMutableArray *inboxMessageArray;
@property(strong,nonatomic)NSMutableArray *inboxSelectedItemArray;
@property(strong,nonatomic)NSMutableArray *inboxSelectedItemUserIdArray;
@property(strong,nonatomic)NSMutableArray *inboxDataAfterSearch;
@property(strong,nonatomic)IBOutlet UISearchBar *searchBarforInbox;
@property(strong,nonatomic)IBOutlet UITableView *tableViewInboxMesssage;
@property(strong,nonatomic)IBOutlet InboxMessageCustomCell *customCell;
@property(strong,nonatomic)MenuViewController *objMenuViewController;

@property(strong,nonatomic)UIButton *checkBoxButton;
@property(strong,nonatomic)UIButton *allCheckButton;
@property(strong,nonatomic)UIImageView *statusImage;
@property(strong,nonatomic)UILabel *userNameLabel;
@property(strong,nonatomic)UILabel *messageCountLabel;
@property(strong,nonatomic)UILabel *detailLabel;
@property(strong,nonatomic)UILabel *replayDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *profileTypeRequest;


- (void)slideViewWithAnimation;
- (IBAction)PopUpAcceptBtn:(id)sender;
- (IBAction)PopUpIgnoreBtn:(id)sender;

@end



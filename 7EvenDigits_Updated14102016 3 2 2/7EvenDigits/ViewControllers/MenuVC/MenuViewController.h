//
//  MenuViewController.h
//  7EvenDigits
//
//  Created by Krishna on 01/10/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InboxMessageViewController.h"
#import "PostingMessageViewController.h"
#import "ComposeViewController.h"
#import "DraftViewController.h"
#import "ContactViewController.h"
#import "AboutUsViewController.h"
#import "ChangePasswordViewController.h"
#import "ContactUsViewController.h"
#import "QuickSearchViewController.h"
#import "ChatViewController.h"
#import "LoginViewController.h"
#import "ServerIntegration.h"
#import "ChatMeassageVC.h"
#import "ChatContactsViewController.h"
#import "ViewProfessionalProfileVC.h"
#import "AddContactViewController.h"
#import "actualProfessionalVC.h"
#import "actualPersonalVC.h"

@class AppDelegate;

@interface MenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *tableViewObj;
    UINavigationBar *navigationBar;
    id perentClass;
    UIView *perentView;
    
    ServerIntegration *serviceIntegration;
    
    InboxMessageViewController *inboxMessageViewController;
    PostingMessageViewController *postingMessageViewController;
    ComposeViewController *composeViewController;
    DraftViewController *draftViewController;
    ContactViewController *contactViewController;
    AboutUsViewController *aboutUsViewController;
    ChangePasswordViewController *changePasswordViewController;
    ContactUsViewController *contactUsViewController;
    QuickSearchViewController *quickSearchViewController;
    ChatViewController *chatViewController;
    LoginViewController *loginViewController;
    ChatContactsViewController *chatContactsViewController;
    
    AppDelegate *objAppDelegate;
    AppDelegate *appDeleagated;
    
    NSString *draftCount;
    NSString *postingCount;
    NSString *inboxCount;
    NSString *chatBoxCount;
    NSString *profileType;
    BOOL isMenuOpen;
   
}
@property(strong ,nonatomic) UINavigationBar *navigationBar;
@property(strong,nonatomic) IBOutlet UITableView *tableViewObj;
@property(assign)BOOL isMenuOpen;
@property (strong, nonatomic) IBOutlet UIView *logoView;
@property (strong, nonatomic) IBOutlet UIImageView *EvenDigitLogo;

@property(nonatomic ,retain) UIView *perentView;
@property(nonatomic ,retain) id perentClass;
- (void)reArrangeView;
-(void)callChatBoxCountWebService;
-(void)fillInboxMessageData;

@end

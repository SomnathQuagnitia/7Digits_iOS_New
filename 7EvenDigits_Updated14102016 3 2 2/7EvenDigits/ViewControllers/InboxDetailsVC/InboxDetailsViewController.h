//
//  InboxDetailsViewController.h
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewCustomCell.h"
#import "ServerIntegration.h"
@class PostedMessageViewController;
@class InboxMessageViewController;

@interface InboxDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    NSMutableArray *inboxDetailsArrayFromInbox;
    NSMutableDictionary *inboxDetailsArray;

    IBOutlet UIView *tableFooter;
    NSMutableArray *tempEditorArray;
    NSMutableArray *tempEditorHeightArray;
    IBOutlet UITableView *inboxDetailTable;
    UIWebView *webViewForCell;
    IBOutlet UIWebView *webViewForMain;
    ServerIntegration *serviceIntegration;
    AppDelegate *appDeleagated;
    
    UILabel *repliedByStaticLabel;
    UILabel *repliedByNameLabel;
    NSTimer *timer;
    
    NSMutableArray *webviewHeights;
    
    UIActivityIndicatorView *indicator;
    
    
}
@property (strong, nonatomic) NSURL *opendImageURL;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewFOrLargeImage;
@property (strong, nonatomic) IBOutlet UIView *ViewforLargeImage;
-(IBAction)handelReplyScreen:(id)sender;
//@property(strong,nonatomic)IBOutlet UITableView *tableViewInboxDtls;
@property(strong,nonatomic)IBOutlet UILabel *labelForTitle;
@property(strong,nonatomic)IBOutlet UIImageView *userImage;

@property(strong,nonatomic)IBOutlet UILabel *labelForDate;
@property(strong,nonatomic)IBOutlet UILabel *labelForMessage;
@property(strong,nonatomic)IBOutlet UILabel *labelForPostedBy;
@property(strong,nonatomic)InboxMessageViewController *inboxMesgVC;
@property(strong,nonatomic)DetailViewCustomCell *customCellDetailView;
@property(strong,nonatomic)NSMutableArray *inboxDetailsArrayFromInbox;
@property(strong,nonatomic)NSMutableDictionary *inboxDetailsArray;
@property(strong,nonatomic)UILabel *messageLabel;
@property(strong,nonatomic)UILabel *replyByLabel;
@property(strong,nonatomic)UILabel *repliedNameLabel;
@end

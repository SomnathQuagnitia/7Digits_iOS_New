//
//  PostedMessageDetailViewController.h
//  7EvenDigits
//
//  Created by Krishna on 09/10/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostedMsgDetailCustomCell.h"
#import "ServerIntegration.h"
 
#import "AppDelegate.h"
@class PostedMessageViewController;
@class ReplyViewController;

@interface PostedMessageDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    PostedMsgDetailCustomCell *custonCellObj;
    IBOutlet UITableView *tableViewObj;
    IBOutlet UIView *tableFooter;
    ServerIntegration *serviceIntegration;
    AppDelegate *appDeleagated;
}
@property (strong, nonatomic) IBOutlet UIImageView *imageViewFOrLargeImage;
@property (strong, nonatomic) IBOutlet UIView *ViewforLargeImage;
@property (strong, nonatomic) UIWebView *postedDetailMainWebView;
@property (strong, nonatomic)ReplyViewController *replyVC;
@property (strong, nonatomic)UIWebView *postedDetailWebView;
@property (strong, nonatomic)IBOutlet UITableView *postedDetailTable;
@property (strong, nonatomic) IBOutlet UILabel *postedByLabel;
@property (strong, nonatomic) IBOutlet UILabel *staticPostedByLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) IBOutlet UILabel *titleMessageLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfile;
@property(strong,nonatomic)NSString *messageId;
@property(strong,nonatomic)NSString *postedById;
@property(strong,nonatomic)PostedMessageViewController *postedMsgVc;
@property(strong,nonatomic)NSMutableDictionary *postedDetailDict;
- (IBAction)handelReply:(id)sender;

@end

//
//  ChatContactsViewController.h
//  7EvenDigits
//
//  Created by Neha_Mac on 14/11/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerIntegration.h"
#import "ChatViewController.h"
#import "ContactCustomCell.h"
#import "CustomBadge.h"
#import "UIImageView+Haneke.h"

@class MenuViewController;
@class ChatMeassageVC;

@interface ChatContactsViewController : BaseViewController<UISearchBarDelegate>
{
    ChatMeassageVC *objchat;
    ServerIntegration *serviceIntegration;
    NSIndexPath *selectedIndexpath;
    AppDelegate *appDeleagated;
    IBOutlet UILabel *noRecFound;
    BOOL searching;
    ChatViewController *chatViewController;
    NSString *chatTitle ;
    NSString *contactId;
    NSString *contactUserId;
    NSInteger j;
}

-(void)CallChatContactListWebService;
@property(strong,nonatomic)NSMutableArray *contactDataAfterSearch;
@property(strong,nonatomic)IBOutlet UISearchBar *searchBarforContact;
@property(strong,nonatomic)NSMutableArray *chatContactArray;
@property(strong,nonatomic)IBOutlet UITableView *tableViewContacts;
@property(strong,nonatomic)ContactCustomCell *customCellForContact;
@property(strong,nonatomic)UIButton *deleteButton;
@property(strong,nonatomic)UIImageView *statusImage;
@property(strong,nonatomic)UILabel *firstLastNameLabel;
@property(strong,nonatomic)UILabel *userNameLabel;
@property (strong,nonnull)NSString *checkStatus;


@end

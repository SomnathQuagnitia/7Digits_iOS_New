//
//  ContactViewController.h
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactCustomCell.h"
#import "ServerIntegration.h"
#import "ContactProfileViewController.h"
#import "actualPersonalVC.h"
#import "actualProfessionalVC.h"
#import "CommonNotification.h"
#import "UIImageView+Haneke.h"

@class MenuViewController;
@class SearchContactViewController;

@interface ContactViewController : BaseViewController<UISearchBarDelegate>
{
    NSMutableArray *contactArray;
    ServerIntegration *serviceIntegration;
    NSIndexPath *selectedIndexpath;
    AppDelegate *appDeleagated;
    IBOutlet UILabel *noRecFound;
    BOOL searching;
    IBOutlet UIView *popUpView;
    IBOutlet UIButton *addContactManuallyBtn;
    IBOutlet UIButton *addContactBySearchBtn;
    int profileType;
    int profileCircleType;
    UIView *view;
}
- (IBAction)addContactManually:(id)sender;
- (IBAction)addContactWithSearch:(id)sender;
- (IBAction)cancelPopUp:(id)sender;
@property(strong,nonatomic)NSMutableArray *contactDataAfterSearch;
@property(strong,nonatomic)IBOutlet UISearchBar *searchBarforContact;

@property(strong,nonatomic)IBOutlet UITableView *tableViewContacts;
@property(strong,nonatomic)ContactCustomCell *customCellForContact;
//@property(strong,nonatomic)ContactProfileViewController *contpfvc;
@property(strong,nonatomic)actualPersonalVC *personalVC;
@property(strong,nonatomic)actualProfessionalVC *professionalVC;

@property(strong,nonatomic)UIButton *deleteButton;
@property(strong,nonatomic)UIImageView *statusImage;
@property(strong,nonatomic)UILabel *firstLastNameLabel;
@property(strong,nonatomic)UILabel *userNameLabel;
@property(strong,nonatomic)SearchContactViewController *searchContactVC;

@end

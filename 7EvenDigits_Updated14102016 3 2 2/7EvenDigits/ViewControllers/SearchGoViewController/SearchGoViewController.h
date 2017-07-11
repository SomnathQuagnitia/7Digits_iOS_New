//
//  SearchGoViewController.h
//  7EvenDigits
//
//  Created by nikhil on 9/15/16.
//  Copyright © 2016 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchContactViewController.h"
#import "ServerIntegration.h"
#import "AppDelegate.h"
#import "UIImageView+Haneke.h"

@class SearchGoTableViewCell;

@interface SearchGoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    IBOutlet UITableView *tableview;
    SearchContactViewController *searchContactVC;
    AppDelegate *appDeleagated;
    ServerIntegration *serviceIntegration;
    UITextView *currentTxtView;
    int profileTypeID;
    AppDelegate *objAppDelegate;
    NSString *defaultText;
   
}
@property (strong, nonatomic) IBOutlet UIButton *sendBtnClick;
@property (strong, nonatomic) IBOutlet UIView *PopView;
@property (strong, nonatomic) IBOutlet UILabel *UserIdLbl;
@property (strong, nonatomic) IBOutlet UILabel *NameLbl;
@property (strong, nonatomic) IBOutlet UITextView *MsgTxtView;
@property (strong, nonatomic) IBOutlet UIImageView *PopUpImgView;
@property (strong, nonatomic) NSMutableArray *searchDataArray;
@property (strong, nonatomic) NSMutableArray *profileDataArray;
@property (strong, nonatomic) NSString *imgUrlStr;
@property (strong, nonatomic) NSString *typeOfRequest;
@property (strong, nonatomic) IBOutlet UILabel *profileTypeRequest;
@property (strong, nonatomic) NSURL *checkImgUrl;
@property (strong, nonatomic) IBOutlet UILabel *countLbl;


- (IBAction)sendBtnClick:(UIButton *)sender;

- (IBAction)CancelPopUp:(id)sender;


@end

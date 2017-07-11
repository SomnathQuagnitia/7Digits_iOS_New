//
//  PostedMessageViewController.h
//  7EvenDigits
//
//  Created by Krishna on 09/10/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostedMessageCustomCell.h"
#import "Parameters.h"
#import "ServerIntegration.h"
 
#import "QuickSearchViewController.h"
#import "AppDelegate.h"
@class PostedMessageDetailViewController;
@class AdvanceSearchViewController;

@interface PostedMessageViewController : UIViewController
{
    NSMutableArray *postedMessageArray;
    ServerIntegration *serviceIntegration;
    NSInteger selctedIndex;
    IBOutlet UILabel *noRecordFoundLabel;
    AppDelegate *appDeleagated;
    NSIndexPath *indexpath;
    NSIndexPath *selectedIndexpath;
    NSTimer* myTimer;
    NSString* lessThan30String;
    BOOL isContactNotAdded;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageViewForLargeImage;
@property (strong, nonatomic) IBOutlet UIView *ViewforLargeImage;
@property (strong, nonatomic) NSIndexPath *cellIndexPath;
@property (strong, nonatomic)PostedMessageDetailViewController *postedMsgDtlVc;
@property (strong, nonatomic)NSMutableArray *postedMessageArray;
@property (strong, nonatomic) IBOutlet UITableView *postedTableView;
@property(strong, nonatomic)PostedMessageCustomCell *postedMsgCustomCell;
@property(strong, nonatomic)QuickSearchViewController *quickSearchVC;
@property(strong, nonatomic)AdvanceSearchViewController *advanceSearchViewController;
@property(strong, nonatomic)NSString *keywordForSearch;

@end

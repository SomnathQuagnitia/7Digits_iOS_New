//
//  DraftViewController.h
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraftCustomCell.h"
#import "ServerIntegration.h"
 
#import "ComposeViewController.h"
#import "AppDelegate.h"

@interface DraftViewController : BaseViewController<UISearchBarDelegate>
{
    
    BOOL searching;
    ServerIntegration *serviceIntegration;
    IBOutlet UILabel *noRecordFoundLabel;
    AppDelegate *appDeleagated;
    NSIndexPath *indexpath;
    
    UIButton *btnAll;
    UIButton *btnDelete;
    BOOL allBtnClk;
    
    
}

@property(strong,nonatomic)NSMutableArray *draftArray;
@property(strong,nonatomic)NSMutableArray *draftSelectedItemArray;
@property(strong,nonatomic)IBOutlet UITableView *tableViewDraft;
@property(strong,nonatomic)DraftCustomCell *customCellForDraft;
@property(strong,nonatomic)IBOutlet UISearchBar *searchBarforDraft;

@property(strong,nonatomic)UIImageView *statusImage;
@property(strong,nonatomic)UILabel *userNameLabel;
@property(strong,nonatomic)UILabel *messageLabel;
@property(strong,nonatomic)UILabel *replayDateLabel;
@property(strong,nonatomic)NSMutableArray *draftDataAfterSearch;
@property(strong,nonatomic)NSMutableArray *draftDataArray;
@property(strong,nonatomic)IBOutlet UILabel *noRecordFoundLabel;
@end
//
//  PostingMessageViewController.h
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostingMessageCustomCell.h"
#import "ServerIntegration.h"
 
#import "AppDelegate.h"

@interface PostingMessageViewController : BaseViewController<UISearchBarDelegate>
{
    
    BOOL searching;
    NSMutableArray *postingDataAfterSearch;
    ServerIntegration *serviceIntegration;
    IBOutlet UILabel *noRecordFoundLabel;
    
    AppDelegate *appDeleagated;
}

@property(strong,nonatomic)NSMutableArray *postingDataArray;
@property(strong,nonatomic)IBOutlet UITableView *tableViewPostingMesssage;
@property(strong,nonatomic)PostingMessageCustomCell *customCellForPostingMsg;

@property (strong, nonatomic) IBOutlet UISearchBar *postingMsgSearchBar;


@property(strong,nonatomic)UIImageView *statusImage;
@property(strong,nonatomic)UILabel *messageLabel;
@property(strong,nonatomic)UILabel *dateLabel;
//@property(strong,nonatomic)NSMutableArray *postingDataArray;
@property(strong,nonatomic)NSMutableArray *postingDataAfterSearch;

@end





//
//  SearchViewController.h
//  7EvenDigits
//
//  Created by Krishna on 29/10/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerIntegration.h"
#import "AppDelegate.h"

@class AdvanceSearchViewController;
@class ComposeViewController;
@class SearchContactViewController;
@class EditProfessionalProfile;

@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSMutableArray *dataArray;
    NSMutableArray *dataAfterSearchArray;
    UITableView *stateNameTableView;
    ServerIntegration *serviceIntegration;
    NSString *searchText;
    NSIndexPath *selectedIndexpath;
    AppDelegate *appDeleagated;
    UIBarButtonItem *selectBtn;
}
@property BOOL searching;
@property (strong, nonatomic) ComposeViewController *composeVC;
@property (strong, nonatomic) AdvanceSearchViewController *advanvedSearchVC;
@property (strong, nonatomic) IBOutlet UISearchBar *objSearchBar;
@property (strong, nonatomic) IBOutlet UITableView *serachTableView;
@property (strong, nonatomic)NSMutableArray *dataArray;
@property (strong, nonatomic)NSMutableArray *dataAfterSearchArray;

@property  BOOL CheckStateStatus;
@property BOOL CheckCityStatus;

@property (strong, nonatomic)NSMutableArray *selectedRowDataArray;
@property (strong, nonatomic) SearchContactViewController *searchContactVC;
@property (strong, nonatomic) EditProfessionalProfile *editProfessionalVC;


@end

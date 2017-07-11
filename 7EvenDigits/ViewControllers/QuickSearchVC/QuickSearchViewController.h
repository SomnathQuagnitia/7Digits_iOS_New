//
//  QuickSearchViewController.h
//  7EvenDigits
//
//  Created by Krishna on 01/10/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerIntegration.h"
 
#import "AppDelegate.h"

@class AdvanceSearchViewController;
@class PostedMessageViewController;


@interface QuickSearchViewController : BaseViewController
{
    ServerIntegration *serviceIntegration;
    AppDelegate *appDeleagated;
}
-(IBAction)handelAdvanceSearch:(id)sender;
-(IBAction)handelGoQuickSearch:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *textFieldForSearch;
@property (strong, nonatomic)AdvanceSearchViewController *advncedSearch;
@property (strong, nonatomic)PostedMessageViewController *postedmsgVC;

-(void)callQuickSearchWebService;

@end

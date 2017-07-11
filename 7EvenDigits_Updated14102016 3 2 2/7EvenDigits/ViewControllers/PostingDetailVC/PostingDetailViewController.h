//
//  PostingDetailViewController.h
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerIntegration.h"
 
#import "AppDelegate.h"
@class PostingMessageViewController;

@interface PostingDetailViewController : UIViewController
{
    ServerIntegration *serviceIntegration;
    AppDelegate *appDeleagated;
}

@property (strong, nonatomic) IBOutlet UILabel *labelForTitle;
@property (strong, nonatomic) IBOutlet UITextView *labelForMessage;
@property (strong, nonatomic) IBOutlet UILabel *labelForId;
@property (strong, nonatomic) IBOutlet UILabel *staticlabelPostedBy;
@property (strong, nonatomic) IBOutlet UILabel *staticlabelPostedDate;
@property (strong, nonatomic) IBOutlet UIButton *repostButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

@property (strong, nonatomic) IBOutlet UILabel *labelForDate;
@property (strong, nonatomic) IBOutlet UILabel *labelForStatus;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;

@property (strong, nonatomic)NSMutableArray *postingDetailArray;
@property (strong, nonatomic)PostingMessageViewController *postingMessageVC;
- (IBAction)handelDelete:(id)sender;
- (IBAction)handelRepost:(id)sender;

@end

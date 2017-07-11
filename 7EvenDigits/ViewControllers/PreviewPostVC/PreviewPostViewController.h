//
//  PreviewPostViewController.h
//  7EvenDigits
//
//  Created by Krishna on 04/10/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewController.h"
#import "ServerIntegration.h"
#import "DraftViewController.h"

@interface PreviewPostViewController : BaseViewController<UITextViewDelegate>
{
    UITextView *textViewForPrevPost;
    UIButton *postButton;
    UIButton *editButton;
    UIButton *saveButton;
    ServerIntegration *serviceIntegration;
    AppDelegate *appDeleagated;
    DraftViewController *draftVC;
    
    BOOL isMsgFromDraft;
}
@property (strong, nonatomic) IBOutlet UIImageView *imageInPreviePosting;

@property (strong, nonatomic) NSString *fromPrevPost;

@property (strong, nonatomic) NSString *messageIdForEdit;
@property (strong, nonatomic) IBOutlet UIWebView *webViewForPreviewPost;
@property (strong, nonatomic) IBOutlet UILabel *labelForTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelForDate;
@property (strong, nonatomic) IBOutlet UITextView *textViewForPreviw;
@property (strong, nonatomic) ComposeViewController *composeVC;

//- (IBAction)handlePost:(id)sender;
//- (IBAction)handleEdit:(id)sender;
//- (IBAction)handleSave:(id)sender;

@end


//
//  ZSSDemoViewController.h
//  TextEditor
//
//  Created by NikhilD on 9/29/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSSRichTextEditor.h"
#import "ServerIntegration.h"
 
#import "Constant.h"
@class PostedMessageDetailViewController;
@class InboxDetailsViewController;
@interface ReplyViewController : ZSSRichTextEditor<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    ServerIntegration *serviceIntegration;
    NSString *htmlMessageText;
    NSString *messagePlianText;
       BOOL isImagePickedInReply;
}

@property(nonatomic, retain)  IBOutlet UILabel *noFileChoosenInReply;
@property (strong, nonatomic)NSString *messagePlianTextReply;
@property (strong, nonatomic)NSString *htmlMessageTextinReply;
@property (strong, nonatomic)IBOutlet UIButton *handelDeleteInReply;
@property (strong, nonatomic)IBOutlet UIImageView *imageViewInReply;
@property (strong, nonatomic)NSMutableDictionary *dictionaryForReply;
@property (strong, nonatomic)PostedMessageDetailViewController *postedDtlVC;
@property (strong, nonatomic)InboxDetailsViewController *inboxDtlVC;
@property (strong, nonatomic) IBOutlet UIButton *sendCopyBtn;
@property (strong, nonatomic)NSString *messageIdForReply;
@property (strong, nonatomic)NSString *toUser;

-(IBAction)handelSubmit:(id)sender;
-(IBAction)handelTrashBtn:(id)sender;
-(IBAction)handelChooseFileInReply:(id)sender;
-(IBAction)handelSendCopy:(id)sender;

@end



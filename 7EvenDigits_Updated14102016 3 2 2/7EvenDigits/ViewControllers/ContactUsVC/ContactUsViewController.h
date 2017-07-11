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
 
#import "AppDelegate.h"
@interface ContactUsViewController : ZSSRichTextEditor<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    //UITextField *currentTextField;
    ServerIntegration *serviceIntegration;
    AppDelegate *appDeleagated;
    NSString *htmlMessageText;

    BOOL cancelButtonClick;

}
@property(strong , nonatomic)IBOutlet UIScrollView *scrollViewObj;
@property(strong , nonatomic)IBOutlet UITextField *textFieldForName;
@property(strong , nonatomic)IBOutlet UITextField *textFieldForEmailAddress;
@property(strong , nonatomic)IBOutlet UITextField *textFieldForPhoneNo;
-(IBAction)handelSendMail:(UIButton *)sender;
-(IBAction)handelcancel:(id)sender;

@end



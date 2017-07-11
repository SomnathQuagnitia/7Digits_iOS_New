//
//  ChangePasswordViewController.h
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerIntegration.h"
 
#import "AppDelegate.h"

@interface ChangePasswordViewController : BaseViewController<UITextFieldDelegate>
{
    UITextField *currentTextField;
    ServerIntegration *serviceIntegration;
    AppDelegate *appDeleagated;
    BOOL cancelBtn;
    BOOL successsfulFlag;

}
@property(strong,nonatomic)IBOutlet UITextField *textfldForCurrentPassword;
@property(strong,nonatomic)IBOutlet UITextField *textfldForNewPassword;
@property(strong,nonatomic)IBOutlet UITextField *textfldForConfirmPassword;
- (IBAction)handelChangePassword:(UIButton *)sender;
- (IBAction)handelCancel:(id)sender;



@end


//
//  ForgetPasswordVC.h
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerIntegration.h"
 
#import "AppDelegate.h"
@interface ForgetPasswordVC : UIViewController<UITextFieldDelegate>
{
    ServerIntegration *serviceIntegration;
    UITextField *currentTextField;
    AppDelegate *appDeleagated;

}
@property(strong,nonatomic)IBOutlet UITextField *textFieldForEmailForget;
@property(strong,nonatomic)IBOutlet UITextField *textFieldForUsernameForget;
-(IBAction)handelSubmit:(id)sender;
-(IBAction)handelCancel:(id)sender;

@end

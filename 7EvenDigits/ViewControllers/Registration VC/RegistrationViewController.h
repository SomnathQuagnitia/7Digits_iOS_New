//
//  RegistrationViewController.h
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerIntegration.h"
 
#import "AppDelegate.h"

@interface RegistrationViewController : UIViewController
{
   
    ServerIntegration *serviceIntegration;
    UITextField *currentTextField;
    BOOL chekBoxClk;
    IBOutlet UIButton *chekBoxBtn;
    AppDelegate *appDeleagated;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewRegistration;
@property(strong, nonatomic)IBOutlet UITextField *textfieldForUserName;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForPassword;
@property(strong, nonatomic)IBOutlet UITextField *textfieldForRePassword;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForEmail;

-(IBAction)handelCreateMyAccount:(id)sender;
-(IBAction)handelCancel:(id)sender;
-(IBAction)handelPrivacyPolicy:(id)sender;
-(IBAction)handelTermsOfService:(id)sender;
-(IBAction)handelCheckBox:(UIButton *)sender;

@end

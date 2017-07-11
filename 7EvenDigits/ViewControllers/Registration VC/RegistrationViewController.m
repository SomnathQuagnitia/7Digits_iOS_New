//
//  RegistrationViewController.m
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import "RegistrationViewController.h"
#import "Parameters.h"
#import "TermsOfServiceViewController.h"
#import "PrivacyPolicyViewController.h"
#import "InboxMessageViewController.h"
#import "HomeViewController.h"
@interface RegistrationViewController ()

@end

@implementation RegistrationViewController
@synthesize textfieldForEmail,textfieldForPassword,textfieldForRePassword,textfieldForUserName,scrollViewRegistration;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"Registraion";
    
    self.navigationController.navigationBarHidden=YES;
    
    
    [chekBoxBtn setSelected:YES];
    
    [scrollViewRegistration setScrollEnabled:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShownInReg)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiddenInReg)
                                                 name:UIKeyboardWillHideNotification object:self.view.window];
    
    
    [Parameters addPaddingView:textfieldForUserName];
    [Parameters addPaddingView:textfieldForPassword];
    [Parameters addPaddingView:textfieldForRePassword];
    [Parameters addPaddingView:textfieldForEmail];
}

-(void)keyboardWasShownInReg
{
     [scrollViewRegistration setScrollEnabled:YES];
    [scrollViewRegistration setContentSize:CGSizeMake(0, 800)];

}
-(void)keyboardWillBeHiddenInReg
{
    [scrollViewRegistration setScrollEnabled:NO];
    [scrollViewRegistration setContentSize:CGSizeMake(0,0)];
}

-(IBAction)handelCheckBox:(UIButton *)sender
{
       sender.selected = !sender.isSelected;
}

-(void)viewWillAppear:(BOOL)animated
{
     self.navigationController.navigationBarHidden=YES;
}
-(IBAction)handelCreateMyAccount:(id)sender
{
    [currentTextField resignFirstResponder];
    if([self checkTextfield])
    {
        if([self validateEmailPassword])
        {
            if([self acceptTermsAndPrivacyPolicy])
            {
                appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
                
                if (appDeleagated.internetStatus==0)
                {
                      [SVProgressHUD showErrorWithStatus:@"Internet connection not available" maskType:SVProgressHUDMaskTypeBlack];
                }
                else
                {
                     [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
                    
                    if (serviceIntegration != nil)
                    {
                        serviceIntegration = nil;
                    }
                    serviceIntegration = [[ServerIntegration alloc]init];
                    
                    if(appDeleagated.iOSDeviceToken.length>0 )
                    {
                        [serviceIntegration RegistrationWebService:self UserName:textfieldForUserName.text Password:textfieldForPassword.text  ConfirmPassword:textfieldForRePassword.text Email:textfieldForEmail.text DeviceId:appDeleagated.iOSDeviceToken RegisterFrom:1 :@selector(receivedResponseData:)];
                    }
                    else
                    {
                        [serviceIntegration RegistrationWebService:self UserName:textfieldForUserName.text Password:textfieldForPassword.text  ConfirmPassword:textfieldForRePassword.text Email:textfieldForEmail.text DeviceId:@"" RegisterFrom:1 :@selector(receivedResponseData:)];
                    }
                    

                }
            
            }
        }
    
    }
    
}

-(IBAction)handelCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)handelPrivacyPolicy:(id)sender
{
    PrivacyPolicyViewController *privcyPolicy=[[PrivacyPolicyViewController alloc]initWithNibName:@"PrivacyPolicyViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:privcyPolicy animated:YES];
}
-(IBAction)handelTermsOfService:(id)sender
{
    TermsOfServiceViewController *termOfServiceVC=[[TermsOfServiceViewController alloc]initWithNibName:@"TermsOfServiceViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:termOfServiceVC animated:YES];
}
#pragma mark==Validate TextFields And Email
-(BOOL)checkTextfield
{
       NSRange rang;
    NSRange rangUsnnm;
    
    NSString *pwd =textfieldForPassword.text;
    NSString *usrnm =textfieldForUserName.text;
    
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
//    rangUsnnm = [usrnm rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    rangUsnnm = [usrnm rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    if ((textfieldForUserName.text.length==0) & (textfieldForPassword.text.length==0) & (textfieldForRePassword.text.length==0) & (textfieldForEmail.text.length==0))
    {
        [SVProgressHUD showErrorWithStatus:sEnterAllFields maskType:SVProgressHUDMaskTypeBlack];

        return NO;
    }
    else if(textfieldForUserName.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"Username is required" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    
//    else if ( !rangUsnnm.length )
//    {
//        return NO;  // no letter
//    }
    else if ( !rangUsnnm.length )
    {
        [SVProgressHUD showErrorWithStatus:@"Username must contain at least one number" maskType:SVProgressHUDMaskTypeBlack];
        return NO;  // no number;
    }
    
    else if( textfieldForUserName.text.length<6 || textfieldForUserName.text.length>100)
    {
        [SVProgressHUD showErrorWithStatus:@"The UserName must be at least 6 characters long" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    
    else if(textfieldForPassword.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"User Password is required" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    
//    else if ( !rang.length )
//    {
//        return NO;  // no letter
//    }
    else if ( !rang.length )
    {
        [SVProgressHUD showErrorWithStatus:@"Password must contain at least one number" maskType:SVProgressHUDMaskTypeBlack];
        return NO;  // no number;
    }
    
    else if ( textfieldForPassword.text.length<6 || textfieldForPassword.text.length>100)
    {
        [SVProgressHUD showErrorWithStatus:@"The Password must be at least 6 characters long" maskType:SVProgressHUDMaskTypeBlack];
        return NO;  // too long or too short
    }
    
    else if(textfieldForRePassword.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"Re-enter Password" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    
    else if([textfieldForPassword.text isEqualToString:textfieldForRePassword.text]==NO)
    {
        [SVProgressHUD showErrorWithStatus:sEnterReEnterSamePassword maskType:SVProgressHUDMaskTypeBlack];

        return NO;
    }
    else if(textfieldForEmail.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"E-mail address is required" maskType:SVProgressHUDMaskTypeBlack];

        return NO;
    }
    
  
    return YES;
}

-(BOOL)validateEmailPassword
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL checkEmailFormatFlag = [emailTest evaluateWithObject:textfieldForEmail.text];
   
    
    if (checkEmailFormatFlag==NO)
    {
        [SVProgressHUD showErrorWithStatus:sEnterValidEmail maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    return YES;
    
}
-(BOOL)acceptTermsAndPrivacyPolicy
{
    if(!chekBoxBtn.selected)
    {
         [SVProgressHUD showErrorWithStatus:@"Please accept Terms of Service and Privacy Policy" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    
    return YES;
}



#pragma mark==Animation and text field delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentTextField=textField;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Service IntegrationDelegate

- (void)receivedResponseData:(NSDictionary *)responseDict
{
   // NSLog(@"%@",responseDict);
   

    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        [SVProgressHUD showSuccessWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
//        InboxMessageViewController *inboxmgs=[[InboxMessageViewController alloc]initWithNibName:@"InboxMessageViewController" bundle:[NSBundle mainBundle]];
        
        NSString *string =[responseDict valueForKey:@"Message"];
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        [self performSelector:@selector(moveToHome) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
        
        CURRENT_USER_ID = [[NSString alloc] initWithFormat:@"%@",[responseDict valueForKey:@"UserId"]];
        CURRENT_USER_NAME= [[NSString alloc] initWithFormat:@"%@",[responseDict valueForKey:@"UserName"]];
       //        [self.navigationController pushViewController:inboxmgs animated:YES];
        
//        NSUserDefaults *UserDefaultsForLogin=[NSUserDefaults standardUserDefaults];
//        [UserDefaultsForLogin setObject:textFieldForUserName.text forKey:@"UserName"];
//        [UserDefaultsForLogin setObject:textFieldForPassword.text forKey:@"Password"];
//        [UserDefaultsForLogin synchronize];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];

    }
}
-(void)moveToHome
{
    HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
    [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];

}
@end

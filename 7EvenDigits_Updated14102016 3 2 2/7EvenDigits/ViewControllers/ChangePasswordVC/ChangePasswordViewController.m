//
//  ChangePasswordViewController.m
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "Parameters.h"
#import "Constant.h"
#import "HomeViewController.h"
@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController
@synthesize textfldForConfirmPassword,textfldForNewPassword,textfldForCurrentPassword;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Change Password";
    self.navigationController.navigationBarHidden=NO;

    UIBarButtonItem *menuBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"home_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelHome)];
    self.navigationItem.leftBarButtonItem=menuBarBtn;
     [Parameters addPaddingView:textfldForCurrentPassword];
     [Parameters addPaddingView:textfldForNewPassword];
     [Parameters addPaddingView:textfldForConfirmPassword];
   
}

- (IBAction)handelCancel:(id)sender
{
    textfldForConfirmPassword.text=@"";
    textfldForCurrentPassword.text=@"";
    textfldForNewPassword.text=@"";
    /*
    cancelBtn=YES;
    if([textfldForConfirmPassword.text isEqualToString:@""]&&[textfldForCurrentPassword.text isEqualToString:@""]&&[textfldForNewPassword.text isEqualToString:@""])
    {
        //[self slideViewWithAnimation];
        HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
        [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Do you want to save changes?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alert show];
    }
     */
    
}
#pragma mark==Navigate to home view
-(void)handelHome
{
    [currentTextField resignFirstResponder];
    if([textfldForConfirmPassword.text isEqualToString:@""]&&[textfldForCurrentPassword.text isEqualToString:@""]&&[textfldForNewPassword.text isEqualToString:@""])
    {
        //[self slideViewWithAnimation];
        HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
        [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
    }
    else
    {
        if (IS_IOS8)
        {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kAlertTitle message:@"Do you want to save changes?" preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"Yes"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                           [self handleYesAction];
                                       }];
            [alertVC addAction:okAction];
            
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"No"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               [self dismissViewControllerAnimated:YES completion:nil];
                                               [self handleNoAction];
                                           }];
            
            [alertVC addAction:cancelAction];
            
            
            
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        else
        {
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Do you want to save changes?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
//            [alert show];
        }
    }
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    /*
//    if (buttonIndex==0)
//    {
//        if(cancelBtn)
//        {
//            cancelBtn=NO;
//            self.textfldForConfirmPassword.text=@"";
//            self.textfldForCurrentPassword.text=@"";
//            self.textfldForNewPassword.text=@"";
//            [currentTextField resignFirstResponder];
//            //[self slideViewWithAnimation];
//            HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
//            [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
//        }
//        else if (successsfulFlag)
//        {
//            successsfulFlag=NO;
//            //[self slideViewWithAnimation];
//            HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
//            [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
//        }
//        else
//        {
//            UIButton *btn;
//            [self handelChangePassword:btn];
//        }
//    }
//    cancelBtn=NO;
//    successsfulFlag=NO;
//     */
//    
//    if (successsfulFlag)
//    {
//        successsfulFlag=NO;
//        //[self slideViewWithAnimation];
//        HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
//        [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
//    }
//    else
//    {
//        if (buttonIndex==0)
//        {
//            [self handleYesAction];
//        }
//        else if (buttonIndex==1)
//        {
//            [self handleNoAction];
//        }
//    }
//    successsfulFlag=NO;
//    
//}
-(void)handleYesAction
{
    if (successsfulFlag)
    {
        successsfulFlag=NO;
        //[self slideViewWithAnimation];
        HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
        [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
    }
    else
    {
        UIButton *btn;
        [self handelChangePassword:btn];
    }
    successsfulFlag=NO;
}
-(void)handleNoAction
{
    HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
    [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
    successsfulFlag=NO;
}
- (IBAction)handelChangePassword:(UIButton *)sender
{
    [currentTextField resignFirstResponder];
    if([self passwordValidate])
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
            
            [serviceIntegration ChangePasswordWebService:self UserId:CURRENT_USER_ID Password:textfldForCurrentPassword.text NewPassword:textfldForNewPassword.text ConfirmPassword:textfldForConfirmPassword.text :@selector(receivedResponseDataChangePassword:)];
            
            //        [Parameters showalrt:sPasswordChangedSuccessfuly aDelegate:self];
        }
    
    }
}
-(BOOL)passwordValidate
{
    
    NSRange rang;
    
    
    NSString *pwd =textfldForNewPassword.text;
    
    
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    if((textfldForCurrentPassword.text.length==0)&(textfldForNewPassword.text.length==0)&(textfldForConfirmPassword.text.length==0))
    {
        [SVProgressHUD showErrorWithStatus:sEnterAllFields maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    else if(textfldForCurrentPassword.text.length==0)
    {
         [SVProgressHUD showErrorWithStatus:@"Current password is required" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    else if(textfldForNewPassword.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"New password is required" maskType:SVProgressHUDMaskTypeBlack];

        return NO;
    }
    else if ( !rang.length )
    {
        [SVProgressHUD showErrorWithStatus:@"New password must contain at least one number" maskType:SVProgressHUDMaskTypeBlack];

        return NO;  // no number;
    }
    else if( textfldForNewPassword.text.length<6 || textfldForNewPassword.text.length>100)
    {
        [SVProgressHUD showErrorWithStatus:@"The Password must be at least 6 characters long" maskType:SVProgressHUDMaskTypeBlack];

        return NO;
    }
    
    else if(textfldForConfirmPassword.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"Confirm password is required" maskType:SVProgressHUDMaskTypeBlack];

        return NO;
    }
    else if([textfldForNewPassword.text isEqualToString:textfldForConfirmPassword.text]==NO)
    {
        [SVProgressHUD showErrorWithStatus:@"Confirm password is not matched with new password." maskType:SVProgressHUDMaskTypeBlack];

        return NO;
    }
    
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentTextField=textField;
    return YES;
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


- (void)receivedResponseDataChangePassword:(NSDictionary *)responseDict
{
    //NSLog(@"%@",responseDict);
    
     
    
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        
       // CURRENT_USER_ID = [[NSString alloc] initWithFormat:@"%@",[responseDict valueForKey:@"UserId"]];
        
       // InboxMessageViewController *inbobxMessageVC=[[InboxMessageViewController alloc]initWithNibName:@"InboxMessageViewController" bundle:[NSBundle mainBundle]];
        self.textfldForConfirmPassword.text=@"";
        self.textfldForCurrentPassword.text=@"";
        self.textfldForNewPassword.text=@"";
        successsfulFlag = YES;

        [SVProgressHUD showSuccessWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
        
       // [Parameters pushFromView:self toView:inbobxMessageVC withTransition:UIViewAnimationTransitionNone];
        
        
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

@end

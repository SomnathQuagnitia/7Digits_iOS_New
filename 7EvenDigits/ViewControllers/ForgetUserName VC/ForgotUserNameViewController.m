//
//  ForgotUserNameViewController.m
//  7EvenDigits
//
//  Created by Krishna on 29/10/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import "ForgotUserNameViewController.h"
#import "Parameters.h"

@interface ForgotUserNameViewController ()

@end

@implementation ForgotUserNameViewController
@synthesize textFieldForEmailForget;
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
    self.title=@"Forgot Username";
    
    self.navigationController.navigationBarHidden=NO;
    
    [Parameters addPaddingView:textFieldForEmailForget];
    
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelBackButton)];
    self.navigationItem.leftBarButtonItem=rightBarBtn;
}
-(void)handelBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)handelSubmit:(id)sender
{
    [currentTextField resignFirstResponder];
    if([self validateEmail])
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
            
            [serviceIntegration ForgotUserNameWebService:self Email:textFieldForEmailForget.text :@selector(receivedResponseDataForgotUserName:)];
            
        }
        
    }
    
}
-(IBAction)handelCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL)validateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL checkEmailFormatFlag = [emailTest evaluateWithObject:textFieldForEmailForget.text];
    
    if (textFieldForEmailForget.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:sEnterEmail maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    else if (checkEmailFormatFlag==NO)
    {
          [SVProgressHUD showErrorWithStatus:sEnterValidEmail maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    return YES;
    
}


- (void)receivedResponseDataForgotUserName:(NSDictionary *)responseDict
{
   // NSLog(@"%@",responseDict);
    [currentTextField resignFirstResponder];
    
    
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        NSString *string =[responseDict valueForKey:@"Message"];
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        [self performSelector:@selector(moveToBack) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
    }
    else
    {
         [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
}
-(void)moveToBack
{
     [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark==Text Field

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentTextField=textField;
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}
@end

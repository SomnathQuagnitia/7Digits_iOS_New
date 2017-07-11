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
    self.title=@"Forget Username";
    
    self.navigationController.navigationBarHidden=NO;
    
    [self addPaddingView];
    
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelBackButton)];
    self.navigationItem.leftBarButtonItem=rightBarBtn;
}

-(void)addPaddingView
{
    UIView *paddingViewEmail = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 34)];
    textFieldForEmailForget.leftView = paddingViewEmail;
    textFieldForEmailForget.leftViewMode = UITextFieldViewModeAlways;
    
    
}
-(void)handelBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)handelSubmit:(id)sender
{
    if([self validateEmail])
    {
        if (serviceIntegration != nil)
        {
            serviceIntegration = nil;
        }
        serviceIntegration = [[ServerIntegration alloc]init];
        
        [serviceIntegration ForgotUserNameWebService:self Email:textFieldForEmailForget.text :@selector(receivedResponseDataForgotUserName:)];
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
        [Parameters showalrt:sEnterEmail aDelegate:self];
        return NO;
    }
    else if (checkEmailFormatFlag==NO)
    {
        [Parameters showalrt:sEnterValidEmail aDelegate:self];
        return NO;
    }
    return YES;
    
}


- (void)receivedResponseDataForgotUserName:(NSDictionary *)responseDict
{
    NSLog(@"%@",responseDict);
    
    //[ActivityIndicatorUtility finishedWaiting];
    
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        [Parameters showAlrtForSingleBtn:[responseDict valueForKey:@"Message"]];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else
    {
        [Parameters showAlrtForSingleBtn:[responseDict valueForKey:@"Message"]];
    }
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

@end

//
//  QuickSearchViewController.m
//  7EvenDigits
//
//  Created by Krishna on 01/10/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import "QuickSearchViewController.h"
#import "AdvanceSearchViewController.h"
#import "PostedMessageViewController.h"
#import "HomeViewController.h"
@interface QuickSearchViewController ()

@end

@implementation QuickSearchViewController

@synthesize advncedSearch,postedmsgVC,textFieldForSearch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=NO;

    
    postedmsgVC=[[PostedMessageViewController alloc]initWithNibName:@"PostedMessageViewController" bundle:[NSBundle mainBundle]];
    postedmsgVC.quickSearchVC=self;
    
    self.title=@"Quick Search";
    
    
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"home_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelHome)];
    self.navigationItem.leftBarButtonItem=rightBarBtn;
    [Parameters addPaddingView:textFieldForSearch];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.textFieldForSearch.text=@"";
}
-(IBAction)handelAdvanceSearch:(id)sender
{
    advncedSearch=[[AdvanceSearchViewController alloc]initWithNibName:@"AdvanceSearchViewController" bundle:[NSBundle mainBundle]];
    advncedSearch.quickSearchVC=self;
    
    [self.navigationController pushViewController:advncedSearch animated:YES];
}
-(IBAction)handelGoQuickSearch:(id)sender
{
    [self.textFieldForSearch resignFirstResponder];
    [self callQuickSearchWebService];
    
    //    if (self.textFieldForSearch.text.length>0)
    //    {
    //        postedmsgVC.keywordForSearch=self.textFieldForSearch.text;
    //    }
    //    else
    //    {
    //        postedmsgVC.keywordForSearch=@"";
    //    }
}

#pragma mark==Navigate to home view
-(void)handelHome
{
    [self.textFieldForSearch resignFirstResponder];
    //[self slideViewWithAnimation];
    HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
    [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
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
-(void)callQuickSearchWebService
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
        
        [serviceIntegration SearchPostedMessage:self UserId:CURRENT_USER_ID KeyWord:self.textFieldForSearch.text :@selector(receivedResponseDataForPostedMessageList:)];
    }
    
}
#pragma mark== Receive Response

- (void)receivedResponseDataForPostedMessageList:(NSMutableArray *)responseArray
{
    
   // NSLog(@"Respons%@",responseArray);
    
    if (responseArray.count>0)
    {
         [SVProgressHUD dismiss];
        self.postedmsgVC.postedMessageArray=[[NSMutableArray alloc]initWithArray:responseArray];
        [self.navigationController pushViewController:self.postedmsgVC animated:YES];
        
    }
    else if(responseArray.count== 0)
    {
        [SVProgressHUD showErrorWithStatus:@"No record found" maskType:SVProgressHUDMaskTypeBlack];
    }
}
@end

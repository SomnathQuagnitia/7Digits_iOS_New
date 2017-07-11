//
//  InboxMessageViewController.m
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import "InboxMessageViewController.h"
#import "InboxDetailsViewController.h"
#import "Constant.h"
#import "MenuViewController.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import <UIKit/UIKit.h>
#define heightKeyboard 30;

@interface InboxMessageViewController ()

@end

@implementation InboxMessageViewController
@synthesize checkBoxButton,statusImage,userNameLabel,detailLabel,replayDateLabel,allCheckButton,inboxMessageArray,inboxSelectedItemArray,MsgTxtView,PopUpView,PopUpImgView,PopUpName,PopUpUserID,PopUpAcceptBtn,PopUpIgnoreBtn, PopUpTitle;
@synthesize tableViewInboxMesssage,searchBarforInbox,inboxDataAfterSearch,objMenuViewController,profileTypeRequest;
@synthesize customCell,inboxSelectedItemUserIdArray;
@synthesize messageCountLabel;

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
    objAppDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    selectedMessageDict = [[NSMutableDictionary alloc]init];
    [super viewDidLoad];
    searching=NO;
    if(IS_IOS7)
    {
        searchBarforInbox.barTintColor=[UIColor colorWithRed:235.0f/255.0f green:110.0f/255.0f blue:30.0f/255.0f alpha:1 ];
    }
    
    self.title=@"Inbox";
    
    [self tableFooterAdjustment];
    
    [self setNavigationBarButtons];
    
    self.navigationController.navigationBarHidden=NO;
    
    inboxSelectedItemArray=[[NSMutableArray alloc]init];
    inboxSelectedItemUserIdArray=[[NSMutableArray alloc]init];
    
    inboxListArray=[[NSArray alloc]init];
    
    
    chekBoxBtnBool=NO;
    [self.tableViewInboxMesssage reloadData];
    
    MsgTxtView.text = @"Message";
    MsgTxtView.textColor = [UIColor blackColor];

    [Parameters addBorderToView:PopUpView];
    [Parameters addBorderToView:PopUpAcceptBtn];
    [Parameters addBorderToView:PopUpIgnoreBtn];
    
}
-(void)callViewProfileWS
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
        [serviceIntegration ViewInboxOtherUserProfile:self profileId:currentUserProfileId :@selector(receivedResponseViewProfileProfWS:)];
        
    }
}
-(void)setProfileData
{
   // NSString *FisrtNameLastName = [NSString stringWithFormat:@"%@ %@",[[[displayProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"FirstName"],[[[displayProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"LastName"]];
    
    if([[[[displayProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"FirstName"] isEqualToString:@""] && [[[[displayProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"LastName"] isEqualToString:@""])
    {
        PopUpName.text = @"Unnamed";
    }
    else
    {
        NSString *FisrtNameLastName = [NSString stringWithFormat:@"%@ %@",[[[displayProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"FirstName"],[[[displayProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"LastName"]];
        PopUpName.text = FisrtNameLastName;
    }
    PopUpUserID.text = [[[displayProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"UserName"];
        
        if([MsgTxtView.text isEqual:[NSNull null]])
        {
           MsgTxtView.text = @"";
        }
        else
        {
            MsgTxtView.text = [[[displayProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"Message"];
        }
    
     NSURL *urlDef = [NSURL URLWithString:[[[[displayProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"ProfileImageName"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    
    NSString *str;
    if([[NSString stringWithFormat:@"%@",urlDef] isEqualToString:@"http://www.7evenDigits.com/content/Profile/"])
    {
        
        str = [NSString stringWithFormat:@"%@noimage.png",[NSString stringWithFormat:@"%@",urlDef]];
    }
    
    if ([[NSString stringWithFormat:@"%@",urlDef] hasSuffix:@"default_Contact.png"] || [[NSString stringWithFormat:@"%@",urlDef] hasSuffix:@"noimage.png"] || [[NSString stringWithFormat:@"%@",urlDef] isEqualToString:@""] || [str hasSuffix:@"noimage.png"])
    {
        PopUpImgView.image = [UIImage imageNamed:@"icon_with_oborder.png"];
    }
    else
    {
        [PopUpImgView setImageWithURL:urlDef];
    }
    
    if([[[[displayProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"IsRequest"] boolValue] == 1)
    {
        [PopUpTitle setText:@"Profile request from:"];
    }
    else
    {
        [PopUpTitle setText:@"Profile sent from:"];
    }
}

- (void)receivedResponseViewProfileProfWS:(NSArray *)responseDict
{
    [SVProgressHUD dismiss];
    NSLog(@"Profile : %@",responseDict);
    displayProfileArray = [[NSMutableArray alloc] init];
    if([[responseDict valueForKey:@"success"]isEqualToString:@"true"])
    {
        [displayProfileArray addObject:responseDict];
        NSLog(@"Display : %@",displayProfileArray);
        [self setProfileData];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    inboxSelectedItemArray=[[NSMutableArray alloc]init];
    inboxSelectedItemUserIdArray=[[NSMutableArray alloc]init];
    searching=FALSE;
    self.searchBarforInbox.text=@"";
    [self.searchBarforInbox resignFirstResponder];
    [self fillInboxMessageData];
}

//Navigation bar buttons
-(void)setNavigationBarButtons
{
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 75.0f, 30.0f)];
    
    btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDelete setFrame:CGRectMake(-20.0f, 0.0f, 60.0f, 30.0f)];
    [btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
    [btnDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDelete addTarget:self action:@selector(handelDelete) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:btnDelete];
    
    btnAll = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAll setTitle:@"All" forState:UIControlStateNormal];
    [btnAll setTitle:@"None" forState:UIControlStateSelected];
    [btnAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnAll setFrame:CGRectMake(34.0f, 0.0f, 60.0f, 30.0f)];
    [btnAll addTarget:self action:@selector(handelAllBtnClkInbox:) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:btnAll];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:customView];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    
    UIBarButtonItem *menuBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"home_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(handelHome)];
    self.navigationItem.leftBarButtonItem=menuBarBtn;
}
-(void)handelAllBtnClkInbox: (id) sender
{
    
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if(button.selected)
    {
        allBtnClk=TRUE;
        //  [inboxSelectedItemArray removeAllObjects];
        //  [inboxSelectedItemUserIdArray removeAllObjects];
        [selectedMessageDict removeAllObjects];
        /*
         if(searching)
         {
         for (int i = 0; i < [inboxDataAfterSearch count]; i++)
         {
         [inboxSelectedItemArray addObject:[NSString stringWithFormat:@"%ld",(long)[[[inboxDataAfterSearch objectAtIndex:i]valueForKey:@"MessageId"] integerValue]]];
         [inboxSelectedItemUserIdArray addObject:[NSString stringWithFormat:@"%ld",(long)[[[inboxDataAfterSearch objectAtIndex:i]valueForKey:@"FromUserId"] integerValue]]];
         //NSLog(@"draftSelectedItemArray%@",inboxSelectedItemArray);
         }
         [self.tableViewInboxMesssage reloadData];
         }
         else
         {
         for (int i = 0; i < [inboxMessageArray count]; i++)
         {
         [inboxSelectedItemArray addObject:[NSString stringWithFormat:@"%ld",(long)[[[inboxMessageArray objectAtIndex:i]valueForKey:@"MessageId"] integerValue]]];
         [inboxSelectedItemUserIdArray addObject:[NSString stringWithFormat:@"%ld",(long)[[[inboxMessageArray objectAtIndex:i]valueForKey:@"FromUserId"] integerValue]]];
         
         }
         [self.tableViewInboxMesssage reloadData];
         }
         */
        
        
        NSMutableArray *tempArray;
        
        NSString *dictKey;
        // NSArray *allKeys = [[NSArray alloc]initWithArray:[selectedMessageDict allKeys]];
        
        
        if(searching)
        {
            for (int i = 0; i < [inboxDataAfterSearch count]; i++)
            {
                tempArray= [[NSMutableArray alloc]init];
                dictKey = [NSString stringWithFormat:@"%@-%@-%@",[NSString stringWithFormat:@"%ld",(long)[[[inboxDataAfterSearch objectAtIndex:i]valueForKey:@"FromUserId"] integerValue]],[NSString stringWithFormat:@"%ld",(long)[[[inboxDataAfterSearch objectAtIndex:i]valueForKey:@"MessageId"] integerValue]],[NSString stringWithFormat:@"%ld",(long)[[[inboxDataAfterSearch objectAtIndex:i]valueForKey:@"ProfileId"] integerValue]]];
                [tempArray addObject:[NSString stringWithFormat:@"%ld",(long)[[[inboxDataAfterSearch objectAtIndex:i]valueForKey:@"FromUserId"] integerValue]]];
                [tempArray addObject:[NSString stringWithFormat:@"%ld",(long)[[[inboxDataAfterSearch objectAtIndex:i]valueForKey:@"MessageId"] integerValue]]];
                [tempArray addObject:[NSString stringWithFormat:@"%ld",(long)[[[inboxDataAfterSearch objectAtIndex:i]valueForKey:@"ProfileId"] integerValue]]];
                
                [selectedMessageDict setObject:tempArray  forKey:dictKey];
                
            }
            [self.tableViewInboxMesssage reloadData];
        }
        else
        {
            for (int i = 0; i < [inboxMessageArray count]; i++)
            {
                tempArray= [[NSMutableArray alloc]init];
                dictKey = [NSString stringWithFormat:@"%@-%@-%@",[NSString stringWithFormat:@"%ld",(long)[[[inboxMessageArray objectAtIndex:i]valueForKey:@"FromUserId"] integerValue]],[NSString stringWithFormat:@"%ld",(long)[[[inboxMessageArray objectAtIndex:i]valueForKey:@"MessageId"] integerValue]],[NSString stringWithFormat:@"%ld",(long)[[[inboxMessageArray objectAtIndex:i]valueForKey:@"ProfileId"] integerValue]]];
                [tempArray addObject:[NSString stringWithFormat:@"%ld",(long)[[[inboxMessageArray objectAtIndex:i]valueForKey:@"FromUserId"] integerValue]]];
                [tempArray addObject:[NSString stringWithFormat:@"%ld",(long)[[[inboxMessageArray objectAtIndex:i]valueForKey:@"MessageId"] integerValue]]];
                [tempArray addObject:[NSString stringWithFormat:@"%ld",(long)[[[inboxMessageArray objectAtIndex:i]valueForKey:@"ProfileId"] integerValue]]];
                
                [selectedMessageDict setObject:tempArray  forKey:dictKey];
            }
            [self.tableViewInboxMesssage reloadData];
        }
        
        [self.tableViewInboxMesssage reloadData];
    }
    else
    {
        //[inboxSelectedItemArray removeAllObjects];
        // [inboxSelectedItemUserIdArray removeAllObjects];
        [selectedMessageDict removeAllObjects];
        [self.tableViewInboxMesssage reloadData];
    }
    
    
}

-(void)fillInboxMessageData
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
        
        [serviceIntegration InboxMessagesList:self UserId:CURRENT_USER_ID :@selector(receivedInboxListResponseDataInb:)];
    }
}
-(void)handelDelete
{
    [self.searchBarforInbox resignFirstResponder];
  
    if([selectedMessageDict count] == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"Select atleast one message to delete" maskType:SVProgressHUDMaskTypeBlack];
        
    }
    else
    {
        if (IS_IOS8)
        {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kAlertTitle message:@"Are you sure you want to delete this message(s)?" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                           [self handleOKAction];
                                       }];
            [alertVC addAction:okAction];
            
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"Cancel"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               [self dismissViewControllerAnimated:YES completion:nil];
                                           }];
            
            [alertVC addAction:cancelAction];
            
            
            
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        else
        {
            
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you want to delete this message(s)?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//            alert.tag = 22;
//            [alert show];
        }
    }
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(alertView.tag == 1)
//    {
//        if (buttonIndex == 0)
//        {
//            [self callAcceptProfileWs];
//        }
//        else
//        {
//            [self PopUpIgnoreBtn:nil];
//        }
//    }
//    else
//    {
//        if (buttonIndex == 0)
//        {
//            [self callAcceptProfileWs];
//        }
//        else
//        {
//           
//            
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        
//    }
//    if(alertView.tag == 22)
//    {
//        if (buttonIndex == 0)
//        {
//            [self handleOKAction];
//        }
//    }
//}


-(void)handleOKAction
{
    if(inboxSelectedItemArray.count == 0)
        appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (appDeleagated.internetStatus==0)
    {
        [SVProgressHUD showErrorWithStatus:@"Internet connection not available" maskType:SVProgressHUDMaskTypeBlack];
        
    }        else
    {
        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
        
        if (serviceIntegration != nil)
        {
            serviceIntegration = nil;
        }
        serviceIntegration = [[ServerIntegration alloc]init];
        
        
        
        NSMutableString *strForId=[[NSMutableString alloc]init];
        NSMutableString *strForUserId=[[NSMutableString alloc]init];
        NSMutableString *strForProfileId=[[NSMutableString alloc]init];
        
        //            if (inboxSelectedItemArray.count <= 1)
        //            {
        //                for (int i=0; i< inboxSelectedItemArray.count;i++)
        //                {
        //            if (inboxSelectedItemUserIdArray.count <= 1)
        //            {
        /*
         for (int i=0; i< inboxSelectedItemUserIdArray.count;i++)
         {
         [strForId appendFormat:@"%@,", [inboxSelectedItemArray objectAtIndex:i]];
         [strForUserId appendFormat:@"%@,", [inboxSelectedItemUserIdArray objectAtIndex:i]];
         
         //                    [strForId appendFormat:@"%@", [inboxSelectedItemArray objectAtIndex:i]];
         //                    [strForUserId appendFormat:@"%@", [inboxSelectedItemUserIdArray objectAtIndex:i]];
         }
         [serviceIntegration DeleteInboxMessage:self ReplyMessageId:strForId UserId:strForUserId :@selector(receivedResponseDataInboxMessageDelete:)];
         */
        NSArray *allKeys = [[NSArray alloc]initWithArray:[selectedMessageDict allKeys]];
        
        for (int i=0; i< selectedMessageDict.count;i++)
        {
            NSString *dictKey = [NSString stringWithFormat:@"%@",[allKeys objectAtIndex:i]];
            [strForId appendFormat:@"%@,", [[selectedMessageDict valueForKey:dictKey] objectAtIndex:1]];
            [strForUserId appendFormat:@"%@,", [[selectedMessageDict valueForKey:dictKey] objectAtIndex:0]];
            if (i == selectedMessageDict.count-1) {
                [strForProfileId appendFormat:@"%@", [[selectedMessageDict valueForKey:dictKey] objectAtIndex:2]];
            }
            else{
                [strForProfileId appendFormat:@"%@,", [[selectedMessageDict valueForKey:dictKey] objectAtIndex:2]];
            }
            //                    [strForId appendFormat:@"%@", [inboxSelectedItemArray objectAtIndex:i]];
            //                    [strForUserId appendFormat:@"%@", [inboxSelectedItemUserIdArray objectAtIndex:i]];
        }
        [serviceIntegration DeleteInboxMessage:self ReplyMessageId:strForId UserId:strForUserId ProfileIds:strForProfileId :@selector(receivedResponseDataInboxMessageDelete:)];
        //  [inboxSelectedItemArray removeAllObjects];
        //  [inboxSelectedItemUserIdArray removeAllObjects];
        [selectedMessageDict removeAllObjects];
        
    }
}
- (void)receivedResponseDataInboxMessageDelete:(NSDictionary *)responseDict
{
    //NSLog(@"%@",responseDict);
    
    
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        [SVProgressHUD showSuccessWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
        searching=FALSE;
        [self fillInboxMessageData];
        [self.tableViewInboxMesssage reloadData];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
}

//-(void)handelAllBtnClk
//{
//    [inboxSelectedItemArray removeAllObjects];
//    for (int i = 0; i < [inboxMessageArray count]; i++)
//    {
//        [inboxSelectedItemArray addObject:[NSString stringWithFormat:@"%d",i]];
//    }
//    [self.tableViewInboxMesssage reloadData];
//}

#pragma mark==Navigate to home view
-(void)handelHome
{
    HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
    [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
}

- (void)slideViewWithAnimation
{
    if (objMenuViewController==Nil)
    {
        objMenuViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:[NSBundle mainBundle]];
    }
    objMenuViewController.perentClass = self;
    objMenuViewController.perentView = self.view;
    objMenuViewController.navigationBar = self.navigationController.navigationBar;
    UINavigationBar *navigationBar = (UINavigationBar *)self.navigationController.navigationBar;
    if (self.view.frame.origin.x == 0)
    {
        self.view.userInteractionEnabled = FALSE;
        [objMenuViewController.view setFrame:CGRectMake(-objMenuViewController.view.frame.size.width,0,objMenuViewController.view.frame.size.width,700)];
        [navigationBar setFrame:CGRectMake(0, 20, navigationBar.frame.size.width, navigationBar.frame.size.height)];
        [self.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:objMenuViewController.view cache:YES];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
        [self.view setFrame:CGRectMake(objMenuViewController.view.frame.size.width, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [navigationBar setFrame:CGRectMake(objMenuViewController.view.frame.size.width, 20, navigationBar.frame.size.width, navigationBar.frame.size.height)];
        [objMenuViewController.view setFrame:CGRectMake(0,0,objMenuViewController.view.frame.size.width,SCREEN_HEIGHT)];
        if ([objMenuViewController.view isDescendantOfView:objAppDelegate.window])
        {
            [objMenuViewController.view removeFromSuperview];
        }
        [objAppDelegate.window addSubview:objMenuViewController.view];
        [UIView commitAnimations];
    }
    else
    {
        self.view.userInteractionEnabled = TRUE;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:objMenuViewController.view cache:YES];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
        [objMenuViewController.view setFrame:CGRectMake(-objMenuViewController.view.frame.size.width,0,objMenuViewController.view.frame.size.width,SCREEN_HEIGHT)];
        [self.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [navigationBar setFrame:CGRectMake(0, 20, navigationBar.frame.size.width, navigationBar.frame.size.height)];
        [UIView commitAnimations];
    }
}

- (IBAction)PopUpAcceptBtn:(id)sender
{
    [self callCheckContactAddedForAcceptProfileWs];

}
-(void)callCheckContactAddedForAcceptProfileWs
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
        [serviceIntegration CheckContactAddedForAcceptProfile:self userId:CURRENT_USER_ID profileId:currentUserProfileId :@selector(receivedResponseCHeckContactExistAcceptProfileWS:)];
    }
}
- (void)receivedResponseCHeckContactExistAcceptProfileWS:(NSArray *)responseDict
{
    
    if([[responseDict valueForKey:@"success"]isEqualToString:@"true"])
    {
        if ([[responseDict valueForKey:@"exist"]isEqualToString:@"true"])
        {
            [SVProgressHUD dismiss];
            isContactProfileExist = @"true";
            [self showOverwriteAlert];
        }
        else
        {
            NSString *string = @"Profile has been added to your Contact list and Chat Box";
            [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
            [self performSelector:@selector(moveToTheView) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
            HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
            [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
        }
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}
-(void)showOverwriteAlert
{
    if (IS_IOS8)
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kAlertTitle message:@"Sending this profile will override any existing profile for this user. Do you still want to proceed?" preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Send"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                       HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
                                       [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
                                       [self callAcceptProfileWs];
                                   }];
        [alertVC addAction:okAction];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Ignore"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                           [self PopUpIgnoreBtn:nil];
                                       }];
        
        [alertVC addAction:cancelAction];
        
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    else
    {
//        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"" message:@"Sending this profile will override any existing profile for this user. Do you still want to proceed?" delegate:self cancelButtonTitle:@"Send" otherButtonTitles:@"Ignore", nil];
//        alrt.tag = 1;
//        [alrt show];
    }
}
-(void)callAcceptProfileWs
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
        [serviceIntegration AcceptUserProfile:self userId:CURRENT_USER_ID isOverrride:isContactProfileExist profileId:currentUserProfileId :@selector(receivedResponseAcceptProfileProfWS:)];
    }
}
- (void)receivedResponseAcceptProfileProfWS:(NSArray *)responseDict
{
    if([[responseDict valueForKey:@"success"]isEqualToString:@"true"])
    {
        NSString *string = @"Profile has been updated to your Contact list and Chat Box";
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        [self performSelector:@selector(moveToTheView) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}

#pragma mark == IgnorButton Clicked

- (IBAction)PopUpIgnoreBtn:(id)sender
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
        [serviceIntegration IgnoreUserProfile:self profileId:currentUserProfileId :@selector(receivedResponseIgnoreProfProfileWS:)];
    }

}
- (void)receivedResponseIgnoreProfProfileWS:(NSArray *)responseDict
{
    if([[responseDict valueForKey:@"success"]isEqualToString:@"true"])
    {
        NSString *string = @"Profile will not be added to your contact list";
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        [self performSelector:@selector(moveToTheView) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}
-(void)moveToTheView
{
    PopUpView.center = self.view.center;
    [PopUpView setAlpha:0.0];
    [UIView beginAnimations:nil context:nil];
    [PopUpView setAlpha:1.0];
    [PopUpView removeFromSuperview];
    [UIView commitAnimations];
}

#pragma mark==Table View Datasource And Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searching)
    {
        return [inboxDataAfterSearch count];
    }
    else
    {
        return [inboxMessageArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    customCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //   customCell = nil;
    if(customCell==nil)
    {
        customCell=[[[NSBundle mainBundle]loadNibNamed:@"InboxMessageCustomCell" owner:self options:nil]objectAtIndex:0];
        customCell.showsReorderControl=YES;
    }
    customCell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    userNameLabel=[[UILabel alloc]init];
    userNameLabel.font=[UIFont fontWithName:@"" size:14];
    
    messageCountLabel=[[UILabel alloc]init];
    messageCountLabel.font=[UIFont fontWithName:@"" size:14];
    
    statusImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"status.png"]];
    NSString *chatStatus;
    NSString *isRead;
    NSString *selectedItem;
    NSString *dictKey;
    
    
    if(searching)
    {
        if ([[NSString stringWithFormat:@"%@",[[inboxDataAfterSearch objectAtIndex:indexPath.row] valueForKey:@"ProfileType"]] isEqualToString:@"1"])
        {
            userNameLabel.text=[[inboxDataAfterSearch objectAtIndex:indexPath.row] valueForKey:@"ProfileSenderName"];
            isRead=[NSString stringWithFormat:@"%ld",(long)[[[inboxDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"IsProfileRead"] integerValue]];
            if([[[inboxMessageArray objectAtIndex:indexPath.row] valueForKey:@"IsRequest"] boolValue] == 1)
            {
                customCell.messageLabel.text = @"Please send me your personal profile";
            }
            else
            {
                customCell.messageLabel.text = @"Please accept my personal profile";
            }

            [customCell.isAttachment setHidden:true];
            
            
        }
        else if ( [[NSString stringWithFormat:@"%@",[[inboxDataAfterSearch objectAtIndex:indexPath.row] valueForKey:@"ProfileType"]] isEqualToString:@"2"])
        {
            userNameLabel.text=[[inboxDataAfterSearch objectAtIndex:indexPath.row] valueForKey:@"ProfileSenderName"];
            isRead=[NSString stringWithFormat:@"%ld",(long)[[[inboxDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"IsProfileRead"] integerValue]];
            if([[[inboxMessageArray objectAtIndex:indexPath.row] valueForKey:@"IsRequest"] boolValue] == 1)
            {
                customCell.messageLabel.text = @"Please send me your professional profile";
            }
            else
            {
                customCell.messageLabel.text = @"Please accept my professional profile";
            }
            [customCell.isAttachment setHidden:true];
            
            
        }
        else
        {
            userNameLabel.text=[[inboxDataAfterSearch objectAtIndex:indexPath.row] valueForKey:@"FromUser"];
            messageCountLabel.text=[NSString stringWithFormat:@"(%@)",[[inboxDataAfterSearch objectAtIndex:indexPath.row] valueForKey:@"Count"]];
            customCell.dateLabel.text=[[inboxDataAfterSearch objectAtIndex:indexPath.row] valueForKey:@"InboxDate"];
            customCell.messageLabel.text=[[inboxDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"PlainText"];
            if ([[NSString stringWithFormat:@"%@",[[inboxDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"IsAttachment"]] isEqualToString:@"0"])
            {
                [customCell.isAttachment setHidden:true];
            }
            else
            {
                [customCell.isAttachment setHidden:false];
            }
            
            chatStatus=[[inboxDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"ChatStatus"];
            
            //        selectedItem=[NSString stringWithFormat:@"%ld",(long)[[[inboxDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"MessageId"] integerValue]];
            
            selectedItem=[NSString stringWithFormat:@"%ld",(long)[[[inboxDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"FromUserId"] integerValue]];
            
            isRead=[NSString stringWithFormat:@"%ld",(long)[[[inboxDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"IsRead"] integerValue]];
            
        }
        dictKey = [NSString stringWithFormat:@"%@-%@-%@",[NSString stringWithFormat:@"%ld",(long)[[[inboxDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"FromUserId"] integerValue]],[NSString stringWithFormat:@"%ld",(long)[[[inboxDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"MessageId"] integerValue]],[NSString stringWithFormat:@"%ld",(long)[[[inboxDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"ProfileId"] integerValue]]];
    }
    else
    {
        NSLog(@"%@", inboxMessageArray);
        if ([[NSString stringWithFormat:@"%@",[[inboxMessageArray objectAtIndex:indexPath.row] valueForKey:@"ProfileType"]] isEqualToString:@"1"])
        {
            userNameLabel.text=[[inboxMessageArray objectAtIndex:indexPath.row] valueForKey:@"ProfileSenderName"];
            if([[[inboxMessageArray objectAtIndex:indexPath.row] valueForKey:@"IsRequest"] boolValue] == 1)
            {
               customCell.messageLabel.text = @"Please send me your personal profile";
            }
            else
            {
               customCell.messageLabel.text = @"Please accept my personal profile";
            }
            [customCell.isAttachment setHidden:true];
            isRead=[NSString stringWithFormat:@"%ld",(long)[[[inboxMessageArray objectAtIndex:indexPath.row]valueForKey:@"IsProfileRead"] integerValue]];
        }
        else if ([[NSString stringWithFormat:@"%@",[[inboxMessageArray objectAtIndex:indexPath.row] valueForKey:@"ProfileType"]] isEqualToString:@"2"])
        {
            userNameLabel.text=[[inboxMessageArray objectAtIndex:indexPath.row] valueForKey:@"ProfileSenderName"];
            if([[[inboxMessageArray objectAtIndex:indexPath.row] valueForKey:@"IsRequest"] boolValue] == 1)
            {
                customCell.messageLabel.text = @"Please send me your professional profile";
            }
            else
            {
                customCell.messageLabel.text = @"Please accept my professional profile";
            }
            [customCell.isAttachment setHidden:true];
            isRead=[NSString stringWithFormat:@"%ld",(long)[[[inboxMessageArray objectAtIndex:indexPath.row]valueForKey:@"IsProfileRead"] integerValue]];
        }
        else
        {
            
            userNameLabel.text=[[inboxMessageArray objectAtIndex:indexPath.row] valueForKey:@"FromUser"];
            
            messageCountLabel.text=[NSString stringWithFormat:@"(%@)",[[inboxMessageArray objectAtIndex:indexPath.row] valueForKey:@"Count"]];
            
            customCell.dateLabel.text=[[inboxMessageArray objectAtIndex:indexPath.row] valueForKey:@"InboxDate"];
            
            customCell.messageLabel.text=[[inboxMessageArray objectAtIndex:indexPath.row]valueForKey:@"PlainText"];
            
            chatStatus=[[inboxMessageArray objectAtIndex:indexPath.row]valueForKey:@"ChatStatus"];
            
            //        selectedItem=[NSString stringWithFormat:@"%ld",(long)[[[inboxMessageArray objectAtIndex:indexPath.row]valueForKey:@"MessageId"] integerValue]];
            
            selectedItem=[NSString stringWithFormat:@"%ld",(long)[[[inboxMessageArray objectAtIndex:indexPath.row]valueForKey:@"FromUserId"] integerValue]];
            
            isRead=[NSString stringWithFormat:@"%ld",(long)[[[inboxMessageArray objectAtIndex:indexPath.row]valueForKey:@"IsRead"] integerValue]];
            
            //        dictKey = [NSString stringWithFormat:@"%@-%@",[NSString stringWithFormat:@"%ld",(long)[[[inboxMessageArray objectAtIndex:indexPath.row]valueForKey:@"FromUserId"] integerValue]],[NSString stringWithFormat:@"%ld",(long)[[[inboxMessageArray objectAtIndex:indexPath.row]valueForKey:@"MessageId"] integerValue]]];
            
            if ([[NSString stringWithFormat:@"%@",[[inboxMessageArray objectAtIndex:indexPath.row]valueForKey:@"IsAttachment"]] isEqualToString:@"0"])
            {
                [customCell.isAttachment setHidden:true];
            }
            else
            {
                [customCell.isAttachment setHidden:false];
            }
            
            //Is read
        }
        dictKey = [NSString stringWithFormat:@"%@-%@-%@",[NSString stringWithFormat:@"%ld",(long)[[[inboxMessageArray objectAtIndex:indexPath.row]valueForKey:@"FromUserId"] integerValue]],[NSString stringWithFormat:@"%ld",(long)[[[inboxMessageArray objectAtIndex:indexPath.row]valueForKey:@"MessageId"] integerValue]],[NSString stringWithFormat:@"%ld",(long)[[[inboxMessageArray objectAtIndex:indexPath.row]valueForKey:@"ProfileId"] integerValue]]];
    }
    
    //Is read
    if ([isRead isEqualToString:@"0"])
    {
        customCell.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:202.0f/255.0f blue:152.0f/255.0f alpha:0.60 ];
    }
    //Get Width
    float widthIs =
    [userNameLabel.text boundingRectWithSize:userNameLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:userNameLabel.font } context:nil].size.width;
    
    float countWidthIs =
    [messageCountLabel.text boundingRectWithSize:messageCountLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:messageCountLabel.font } context:nil].size.width;
    
    
    //Add userNameLabel frame
    userNameLabel.frame=CGRectMake(customCell.frame.origin.x+51, customCell.frame.origin.y+5, widthIs, 21);
    [customCell.contentView addSubview:userNameLabel];
    
    //Add Message Count Label frame
    messageCountLabel.frame=CGRectMake(userNameLabel.frame.origin.x+widthIs+8, customCell.frame.origin.y+3, 30, 22);
    [customCell.contentView addSubview:messageCountLabel];
    
    //Add statusImage frame
    statusImage.frame=CGRectMake(messageCountLabel.frame.origin.x+countWidthIs+8, customCell.frame.origin.y+10, 9, 9);
    [customCell.contentView addSubview:statusImage];
    
    
    //addTarget
    [customCell.checkBoxButton addTarget:self action:@selector(handelCheckBoxButtonClkInb:event:) forControlEvents:UIControlEventTouchUpInside];
    
    customCell.checkBoxButton.tag=indexPath.row;
    
    //Set chat status
    if([chatStatus isEqualToString:@"Online"])
    {
        statusImage.image=[UIImage imageNamed:@"online.png"];
    }
    else
    {
        statusImage.image=[UIImage imageNamed:@"offline.png"];
    }
    
    //    //Set selected Items
    //    if([inboxSelectedItemArray containsObject:selectedItem])
    //    {
    //        [customCell.checkBoxButton setImage:[UIImage imageNamed:@"select_checkbox.png"] forState:UIControlStateNormal];
    //    }
    //    else
    //    {
    //        [customCell.checkBoxButton setImage:[UIImage imageNamed:@"unselect_checkbox.png"] forState:UIControlStateNormal];
    //    }
    //Set selected Items
    
    NSArray *allKeys = [[NSArray alloc]initWithArray:[selectedMessageDict allKeys]];
    
    if([allKeys containsObject:dictKey])
    {
        [customCell.checkBoxButton setImage:[UIImage imageNamed:@"select_checkbox.png"] forState:UIControlStateNormal];
    }
    else
    {
        [customCell.checkBoxButton setImage:[UIImage imageNamed:@"unselect_checkbox.png"] forState:UIControlStateNormal];
    }
    return customCell;
}


-(void)handelCheckBoxButtonClkInb: (UIButton *)sender event:(UIEvent *)event
{
    sender.selected = !sender.isSelected;
    //    NSLog(@"sender.tag =%d",sender.tag);
    
    indexpath=[self.tableViewInboxMesssage indexPathForRowAtPoint:[[[event touchesForView:sender] anyObject] locationInView:self.tableViewInboxMesssage]];
    
    NSString *selectedMsgCellId;
    NSString *selectedMsgCellUserId;
    NSString *selectedMsgCellProfileId;
    
    if(searching)
    {
        selectedMsgCellId = [NSString stringWithFormat:@"%ld",(long)[[[inboxDataAfterSearch objectAtIndex:indexpath.row]valueForKey:@"MessageId"] integerValue]];
        selectedMsgCellUserId = [NSString stringWithFormat:@"%ld",(long)[[[inboxDataAfterSearch objectAtIndex:indexpath.row]valueForKey:@"FromUserId"] integerValue]];
        selectedMsgCellProfileId= [NSString stringWithFormat:@"%ld",(long)[[[inboxDataAfterSearch objectAtIndex:indexpath.row]valueForKey:@"ProfileId"] integerValue]];
    }
    else
    {
        selectedMsgCellId = [NSString stringWithFormat:@"%ld",(long)[[[inboxMessageArray objectAtIndex:indexpath.row]valueForKey:@"MessageId"] integerValue]];
        selectedMsgCellUserId  = [NSString stringWithFormat:@"%ld",(long)[[[inboxMessageArray objectAtIndex:indexpath.row]valueForKey:@"FromUserId"] integerValue]];
        selectedMsgCellProfileId= [NSString stringWithFormat:@"%ld",(long)[[[inboxMessageArray objectAtIndex:indexpath.row]valueForKey:@"ProfileId"] integerValue]];
    }
    
    //    if(![inboxSelectedItemArray containsObject:selectedMsgCellId])
    //    {
    //        [sender setImage:[UIImage imageNamed:@"select_checkbox.png"] forState:UIControlStateNormal];
    //        [inboxSelectedItemArray addObject:selectedMsgCellId];
    //        [inboxSelectedItemUserIdArray addObject:selectedMsgCellUserId];
    //    }
    //    else
    //    {
    //        [sender setImage:[UIImage imageNamed:@"unselect_checkbox.png"] forState:UIControlStateNormal];
    //        [inboxSelectedItemArray removeObject:selectedMsgCellId];
    //        [inboxSelectedItemUserIdArray removeObject:selectedMsgCellUserId];
    //    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    NSString *dictKey = [NSString stringWithFormat:@"%@-%@-%@",selectedMsgCellUserId,selectedMsgCellId,selectedMsgCellProfileId];
    NSArray *allKeys = [[NSArray alloc]initWithArray:[selectedMessageDict allKeys]];
    //    if(![inboxSelectedItemUserIdArray containsObject:selectedMsgCellUserId])
    //    {
    if(![allKeys containsObject:dictKey])
    {
        
        [sender setImage:[UIImage imageNamed:@"select_checkbox.png"] forState:UIControlStateNormal];
        //        [inboxSelectedItemArray addObject:selectedMsgCellId];
        //        [inboxSelectedItemUserIdArray addObject:selectedMsgCellUserId];
        [tempArray addObject:selectedMsgCellUserId];
        [tempArray addObject:selectedMsgCellId];
        [tempArray addObject:selectedMsgCellProfileId];
        [selectedMessageDict setValue:tempArray forKey:dictKey];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"unselect_checkbox.png"] forState:UIControlStateNormal];
        //        [inboxSelectedItemArray removeObject:selectedMsgCellId];
        //        [inboxSelectedItemUserIdArray removeObject:selectedMsgCellUserId];
        [selectedMessageDict removeObjectForKey:dictKey];
    }
    
    //    if([inboxSelectedItemArray count]>0)
    //    {
    //        [btnAll setTitle:@"All" forState:UIControlStateNormal];
    //        btnAll.tintAdjustmentMode=YES;
    //    }
    //
    //    if(allBtnClk)
    //    {
    //        allBtnClk=FALSE;
    //        if(inboxSelectedItemArray.count != inboxMessageArray.count)
    //        {
    //            [btnAll setTitle:@"All" forState:UIControlStateNormal];
    //            btnAll.tintAdjustmentMode=YES;
    //        }
    //    }
    //    if(!allBtnClk)
    //    {
    //        if(inboxSelectedItemArray.count == inboxMessageArray.count)
    //        {
    //            allBtnClk=TRUE;
    //            [btnAll setTitle:@"None" forState:UIControlStateNormal];
    //            btnAll.tintAdjustmentMode=YES;
    //        }
    //    }
    if([inboxSelectedItemUserIdArray count]>0)
    {
        [btnAll setTitle:@"All" forState:UIControlStateNormal];
        btnAll.tintAdjustmentMode=YES;
    }
    
    if(allBtnClk)
    {
        allBtnClk=FALSE;
        if(inboxSelectedItemUserIdArray.count != inboxMessageArray.count)
        {
            [btnAll setTitle:@"All" forState:UIControlStateNormal];
            btnAll.tintAdjustmentMode=YES;
        }
    }
    if(!allBtnClk)
    {
        if(inboxSelectedItemUserIdArray.count == inboxMessageArray.count)
        {
            allBtnClk=TRUE;
            [btnAll setTitle:@"None" forState:UIControlStateNormal];
            btnAll.tintAdjustmentMode=YES;
        }
    }
    
    
}
-(void)showRequestPopUp
{
    if(![PopUpView isDescendantOfView:self.view])
    {
        
        PopUpView.center = self.view.center;
        [PopUpView setAlpha:0.0];
        [self.view addSubview:PopUpView];
        [UIView beginAnimations:nil context:nil];
        [PopUpView setAlpha:1.0];
        [UIView commitAnimations];
        
    }
    

}
//-(void)selectAllBtnClicked:(UIButton *)sender
//{
//    for(int i=0;i<inboxMessageArray.count;i++)
//    {
//        [inboxSelectedItemArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:sender.isSelected]];
//        [sender setSelected:!sender.isSelected];
//    }
//    [tableViewInboxMesssage reloadData];
//}


//Did select row at index path
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InboxDetailsViewController *inbxDtlsVC;
    AcceptIgnoreProfileVC *acceptIgnoreProfileVC;
    AcceptIgnoreProfProfileVC *acceptIgnoreProfProfileVC;
    
    if(searching)
    {
        
        if ([[NSString stringWithFormat:@"%@",[[inboxDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"ProfileType"]] isEqualToString:[NSString stringWithFormat:@"1"]] )
        {
                      // personal Profile
            profileTypeRequest.text = @" < Personal";
            acceptIgnoreProfileVC = [[AcceptIgnoreProfileVC alloc]initWithNibName:@"AcceptIgnoreProfileVC" bundle:[NSBundle mainBundle]];
            acceptIgnoreProfileVC.profileDataArray=[[NSMutableArray alloc]init];
            [acceptIgnoreProfileVC.profileDataArray addObject:[inboxDataAfterSearch objectAtIndex:indexPath.row]];
            currentUserProfileId = [[inboxDataAfterSearch objectAtIndex:indexPath.row] valueForKey:@"ProfileId"];
            NSLog(@" currentUserProfileId  %@",currentUserProfileId);
            
            if([[[inboxMessageArray objectAtIndex:indexPath.row] valueForKey:@"IsRequest"] boolValue] == 1)
            {
                [self callViewProfileWS];
                [self showRequestPopUp];            }
            else
            {
                 [self.navigationController pushViewController:acceptIgnoreProfileVC animated:YES];
            }

           
           
        }
        else if ([[NSString stringWithFormat:@"%@",[[inboxDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"ProfileType"]] isEqualToString:[NSString stringWithFormat:@"2"]] )
        {
            //professional Profile
            profileTypeRequest.text = @" < Professioanl";

            acceptIgnoreProfProfileVC=[[AcceptIgnoreProfProfileVC alloc]initWithNibName:@"AcceptIgnoreProfProfileVC" bundle:[NSBundle mainBundle]];
            acceptIgnoreProfProfileVC.professionalProfileArray=[[NSMutableArray alloc]init];
            [acceptIgnoreProfProfileVC.professionalProfileArray addObject:[inboxDataAfterSearch objectAtIndex:indexPath.row]];
            currentUserProfileId = [[inboxDataAfterSearch objectAtIndex:indexPath.row] valueForKey:@"ProfileId"];
            NSLog(@" currentUserProfileId  %@",currentUserProfileId);
            if([[[inboxMessageArray objectAtIndex:indexPath.row] valueForKey:@"IsRequest"] boolValue] == 1)
            {
                [self callViewProfileWS];
                [self showRequestPopUp];
            }
            else
            {
                 [self.navigationController pushViewController:acceptIgnoreProfProfileVC animated:YES];
            }
            

        }
        else
        {
            //inbox detail
            inbxDtlsVC=[[InboxDetailsViewController alloc]initWithNibName:@"InboxDetailsViewController" bundle:[NSBundle mainBundle]];
            inbxDtlsVC.inboxMesgVC=self;
            inbxDtlsVC.inboxDetailsArrayFromInbox=[[NSMutableArray alloc]init];
            [inbxDtlsVC.inboxDetailsArrayFromInbox addObject:[inboxDataAfterSearch objectAtIndex:indexPath.row]];
            [self.navigationController pushViewController:inbxDtlsVC animated:YES];
        }
    }
    else
    {
        if ([[NSString stringWithFormat:@"%@",[[inboxMessageArray objectAtIndex:indexPath.row]valueForKey:@"ProfileType"]] isEqualToString:[NSString stringWithFormat:@"1"]] )
        {
            //personal Profile
            profileTypeRequest.text = @" < Personal";

            acceptIgnoreProfileVC=[[AcceptIgnoreProfileVC alloc]initWithNibName:@"AcceptIgnoreProfileVC" bundle:[NSBundle mainBundle]];
            acceptIgnoreProfileVC.profileDataArray=[[NSMutableArray alloc]init];
            [acceptIgnoreProfileVC.profileDataArray addObject:[inboxMessageArray objectAtIndex:indexPath.row]];
            currentUserProfileId = [[inboxMessageArray objectAtIndex:indexPath.row] valueForKey:@"ProfileId"];
            NSLog(@" currentUserProfileId  %@",currentUserProfileId);

            if([[[inboxMessageArray objectAtIndex:indexPath.row] valueForKey:@"IsRequest"] boolValue] == 1)
            {
                [self callViewProfileWS];
                [self showRequestPopUp];
            }
            else
            {
                [self.navigationController pushViewController:acceptIgnoreProfileVC animated:YES];

            }
        }
        else if ([[NSString stringWithFormat:@"%@",[[inboxMessageArray objectAtIndex:indexPath.row]valueForKey:@"ProfileType"]] isEqualToString:[NSString stringWithFormat:@"2"]] )
        {
            //professional Profile
            profileTypeRequest.text = @" < Professional";

            acceptIgnoreProfProfileVC=[[AcceptIgnoreProfProfileVC alloc]initWithNibName:@"AcceptIgnoreProfProfileVC" bundle:[NSBundle mainBundle]];
            acceptIgnoreProfProfileVC.professionalProfileArray=[[NSMutableArray alloc]init];
            [acceptIgnoreProfProfileVC.professionalProfileArray addObject:[inboxMessageArray objectAtIndex:indexPath.row]];
            currentUserProfileId = [[inboxMessageArray objectAtIndex:indexPath.row] valueForKey:@"ProfileId"];
            NSLog(@"currentUserProfileId %@",currentUserProfileId);
            if([[[inboxMessageArray objectAtIndex:indexPath.row] valueForKey:@"IsRequest"] boolValue] == 1)
            {
                [self callViewProfileWS];
                [self showRequestPopUp];
            }
            else
            {
                 [self.navigationController pushViewController:acceptIgnoreProfProfileVC animated:YES];
            }
        }
        else
        {
            inbxDtlsVC=[[InboxDetailsViewController alloc]initWithNibName:@"InboxDetailsViewController" bundle:[NSBundle mainBundle]];
            inbxDtlsVC.inboxMesgVC=self;
            inbxDtlsVC.inboxDetailsArrayFromInbox=[[NSMutableArray alloc]init];
            [inbxDtlsVC.inboxDetailsArrayFromInbox addObject:[inboxMessageArray objectAtIndex:indexPath.row]];
            [self.navigationController pushViewController:inbxDtlsVC animated:YES];
        }
    }
    
    searching=FALSE;
    self.searchBarforInbox.text=@"";
    [self.searchBarforInbox resignFirstResponder];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}
-(void)tableFooterAdjustment
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.tableViewInboxMesssage.tableFooterView = view;
}

#pragma mark== Content View Data
/*
 //Check Box Button
 checkBoxButton=[UIButton buttonWithType:UIButtonTypeCustom];
 checkBoxButton.frame=CGRectMake(cell.frame.origin.x+10, cell.frame.origin.y+10, 25, 25);
 [checkBoxButton setImage:[UIImage imageNamed:@"uncheck.jpeg"] forState:UIControlStateNormal];
 //[checkBoxButton addTarget:self action:@selector(chkBoxBtnClk) forControlEvents:UIControlEventTouchUpInside];
 checkBoxButton.tag=indexPath.row;
 [cell.contentView addSubview:checkBoxButton];
 
 
 //main Label
 userNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(cell.frame.origin.x+45, cell.frame.origin.y+8, 150, 20)];
 userNameLabel.font=[UIFont fontWithName:@"Helvetica" size:15];
 userNameLabel.text=@"Krishna";
 [cell.contentView addSubview:userNameLabel];
 
 //Detail Label
 detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(cell.frame.origin.x+45, cell.frame.origin.y+29, 255, 55)];
 detailLabel.text=@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
 detailLabel.font=[UIFont fontWithName:@"Helvetica" size:13];
 detailLabel.numberOfLines=3;
 [cell.contentView addSubview:detailLabel];
 
 //Status Image
 statusImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"status.png"]];
 statusImage.frame=CGRectMake(cell.frame.origin.x+150, cell.frame.origin.y+9, 15, 15);
 [cell.contentView addSubview:statusImage];
 
 
 //Rplay Date  Label
 replayDateLabel=[[UILabel alloc]initWithFrame:CGRectMake(cell.frame.origin.x+220, cell.frame.origin.y+8, 150, 15)];
 replayDateLabel.text=@"28/10/2014";
 replayDateLabel.textColor=[UIColor colorWithRed:180.0f/255.f green:180.0f/255.f blue:180.0f/255.f alpha:0.9];
 replayDateLabel.font=[UIFont fontWithName:@"Helvetica" size:15];
 
 [cell.contentView addSubview:replayDateLabel];
 */





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)receivedInboxListResponseDataInb:(NSMutableArray *)responseArray
{
     NSLog(@"responseArray : %@",responseArray);
    [SVProgressHUD dismiss];
    if ([responseArray count]==0)
    {
        noRecordFoundLabel.hidden=NO;
        btnAll.userInteractionEnabled=NO;
        btnDelete.userInteractionEnabled=NO;
        [inboxMessageArray removeAllObjects];
        [tableViewInboxMesssage reloadData];
    }
    else
    {
        noRecordFoundLabel.hidden=YES;
        inboxMessageArray=[[NSMutableArray alloc]initWithArray:responseArray];
        btnAll.userInteractionEnabled=YES;
        btnDelete.userInteractionEnabled=YES;
        [tableViewInboxMesssage reloadData];
    }
}

#pragma mark - Search Bar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    searchBarforInbox.autocapitalizationType= UITextAutocapitalizationTypeNone;
    searchBarforInbox.autocorrectionType= UITextAutocorrectionTypeNo;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    searchBar.showsCancelButton = NO;
    searchBarforInbox.text=@"";
    searching=FALSE;
    [self fillInboxMessageData];
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar*)searchBar1 textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        searching = FALSE;
    }
    else
    {
        NSString *searchText = searchBar1.text;
        inboxDataAfterSearch  = [[NSMutableArray alloc] init];
        for (NSMutableArray *item1 in inboxMessageArray)
        {
            NSString *string =[item1 valueForKey:@"PlainText"];
            NSRange range = [string rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound)
            {
                [self.inboxDataAfterSearch addObject:item1];
            }
        }
        searching = true;
    }
    [self.tableViewInboxMesssage reloadData];
}
- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    searchBarforInbox.text=[NSString stringWithFormat:@"%@",[theSearchBar text]];
    [searchBarforInbox resignFirstResponder];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [searchBarforInbox resignFirstResponder];
}

#pragma mark - TextView Delegate

//- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
//{
//    currentTxtView = textView;
//    MsgTxtView.text = @"";
//    MsgTxtView.textColor = [UIColor blackColor];
//    return YES;
//}
//
//-(void) textViewDidChange:(UITextView *)textView
//{
//    currentTxtView = textView;
//    if(MsgTxtView.text.length == 0)
//    {
//        MsgTxtView.textColor = [UIColor blackColor];
//        MsgTxtView.text = @"Message";
//        [MsgTxtView resignFirstResponder];
//    }
//}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    currentTxtView = textView;
//    NSArray* components = [textView.text componentsSeparatedByString:@"\n"];
//    if ([components count] > 0) {
//        NSString *commandText = [components lastObject];
//        NSLog(@"%@",commandText);
//        textView.text = @"";
//        [textView resignFirstResponder];
//    }
//
//    if(textView.text.length == 250)
//    {
//        return NO;
//        NSLog(@"Character range is 250");
//    }
//    else
//    {
//        return YES;
//
//    }
//}
//- (void)textViewDidBeginEditing:(UITextView *)textView;
//{
//    currentTxtView = textView;
//    [Parameters moveTextViewUpForView:PopUpView forTextView:textView forSubView:PopUpView];
//}
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    textView.returnKeyType = UIReturnKeyDone;
//    
//}

@end

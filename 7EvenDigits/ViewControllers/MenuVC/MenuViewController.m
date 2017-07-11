

//
//  MenuViewController.m
//  7EvenDigits
//
//  Created by Krishna on 01/10/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import "MenuViewController.h"
#import "Parameters.h"
#import "Constant.h"
#import "AppDelegate.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize navigationBar,tableViewObj,perentView,perentClass,isMenuOpen;
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
    self.title=@"Menu";
    [self tableFooterAdjustment];
    self.logoView.frame=CGRectMake(tableViewObj.frame.size.width,0,SCREEN_WIDTH-tableViewObj.frame.size.width,tableViewObj.frame.size.height);
    profileType = @"0";
    self.EvenDigitLogo.frame=CGRectMake(self.logoView.frame.size.width/2-self.EvenDigitLogo.frame.size.width/2, tableViewObj.frame.size.height-self.EvenDigitLogo.frame.size.height,self.EvenDigitLogo.frame.size.width, self.EvenDigitLogo.frame.size.height);
    [self.logoView addSubview:self.EvenDigitLogo];
}

-(void)viewWillAppear:(BOOL)animated
{
    isMenuOpen = YES;
    [self fillInboxMessageData];
    [self callDraftCountWebService];
    [self callPostingCountWebService];
    [self callChatBoxCountWebService];
}

-(void)callChatBoxCountWebService
{
    appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (appDeleagated.internetStatus==0)
    {
       // [SVProgressHUD showErrorWithStatus:@"Internet connection not available"];
    }
    else
    {
        //   [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
        
        if (serviceIntegration != nil)
        {
            serviceIntegration = nil;
        }
        serviceIntegration = [[ServerIntegration alloc]init];
        
        [serviceIntegration GetContactsBadge:self userId:CURRENT_USER_ID :@selector(receivedResponseContactCountInMenu:)];
    }
}
-(void)callDraftCountWebService
{
    appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (appDeleagated.internetStatus==0)
    {
    }
    else
    {
        ///  [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
        
        if (serviceIntegration != nil)
        {
            serviceIntegration = nil;
        }
        serviceIntegration = [[ServerIntegration alloc]init];
        
        [serviceIntegration GetDraftMessageListWebService:self UserId:CURRENT_USER_ID :@selector(receivedResponseDraftListInMenu:)];
    }
}
- (void)receivedResponseContactCountInMenu:(NSArray *)responseDict
{
     [SVProgressHUD dismiss];
    NSLog(@"cont Resp%@",responseDict);
    if(responseDict.count > 0){
    chatBoxCount=[[NSString alloc]init];
    int count=0;
    for (int i=0; i<[responseDict count]; i++)
    {
        if (![[NSString stringWithFormat:@"%@",[[responseDict objectAtIndex:i]valueForKey:@"Badge" ]] isEqualToString:@"0"])
        {
            count++;
        }
    }
    chatBoxCount = [NSString stringWithFormat:@"Chat Box (%d)",count];
    [self.tableViewObj reloadData];
    }
    
}
- (void)receivedResponseDraftListInMenu:(NSArray *)responseDict
{
     [SVProgressHUD dismiss];
     if (responseDict.count > 0)
     {
    draftCount=[[NSString alloc]init];
    draftCount=[NSString stringWithFormat:@"%lu",(unsigned long)[responseDict count]];
         [self.tableViewObj reloadData];
     }
    
}

-(void)callPostingCountWebService
{
    appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (appDeleagated.internetStatus==0)
    {
        //  [SVProgressHUD showErrorWithStatus:@"Internet connection not available"];
    }
    else
    {
        //  [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
        
        if (serviceIntegration != nil)
        {
            serviceIntegration = nil;
        }
        serviceIntegration = [[ServerIntegration alloc]init];
        
        [serviceIntegration PostingMessageListWebService:self UserId:CURRENT_USER_ID :@selector(receivedResponsePostingListInMenu:)];
    }
}
-(void)fillInboxMessageData
{
    
    appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (appDeleagated.internetStatus==0)
    {
    }
    else
    {
        //  [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
        
        if (serviceIntegration != nil)
        {
            serviceIntegration = nil;
        }
        serviceIntegration = [[ServerIntegration alloc]init];
        
        [serviceIntegration InboxMessagesList:self UserId:CURRENT_USER_ID :@selector(receivedInboxListResponseDataMenu:)];
    }
}
- (void)receivedInboxListResponseDataMenu:(NSArray *)responseDict
{
     [SVProgressHUD dismiss];
    NSLog(@"responseDict%@",responseDict);
    if (responseDict.count > 0) {
      
    inboxCount=[[NSString alloc]init];
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    for(int i=0;i<[responseDict count];i++)
    {
        if ([[NSString stringWithFormat:@"%@",[[responseDict objectAtIndex:i] valueForKey:@"ProfileType"]] isEqualToString:@"1"] || [[NSString stringWithFormat:@"%@",[[responseDict objectAtIndex:i] valueForKey:@"ProfileType"]] isEqualToString:@"2"])
        {
            if([[[responseDict objectAtIndex:i]valueForKey:@"IsProfileRead"] isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                [arr addObject:[[responseDict objectAtIndex:i]valueForKey:@"IsProfileRead"]];
            }
        }
        else{
            if([[[responseDict objectAtIndex:i]valueForKey:@"IsRead"] isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                [arr addObject:[[responseDict objectAtIndex:i]valueForKey:@"IsRead"]];
            }
        }
    }
    inboxCount=[NSString stringWithFormat:@"%lu",(unsigned long)[arr count]];
    [self.tableViewObj reloadData];
    }
    
}
- (void)receivedResponsePostingListInMenu:(NSArray *)responseDict
{
     [SVProgressHUD dismiss];
    if(responseDict.count > 0){
    postingCount=[[NSString alloc]init];
    postingCount=[NSString stringWithFormat:@"%lu",(unsigned long)[responseDict count]];
        [self.tableViewObj reloadData];
    }
    
}
-(void)tableFooterAdjustment
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.tableViewObj.tableFooterView = view;
}


#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.frame.origin.x, cell.contentView.frame.origin.y,265, 55)];
        
        [backgroundView setBackgroundColor:[UIColor colorWithRed:209.0f/255.0f green:88.0f/255.0f blue:12.0f/255.0f alpha:1]];
        [tableViewObj setBackgroundColor:[UIColor colorWithRed:209.0f/255.0f green:88.0f/255.0f blue:12.0f/255.0f alpha:1]];
        
        [cell.contentView addSubview:backgroundView];
        UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 25)];
        cellLabel.backgroundColor = [UIColor clearColor];
        cellLabel.textColor = [UIColor colorWithRed:254/255.f green:254/255.f blue:254/255.f alpha:0.9];
        [cellLabel setFont:[UIFont fontWithName:@"Helvetica" size:17.0]];
        cellLabel.tag = 777;
        [cell.contentView addSubview:cellLabel];
        
       
    }
    UILabel *cellLbl = (UILabel *)[cell.contentView viewWithTag:777];
    switch (indexPath.row)
    {
            
        case 0:
        {
            cellLbl.text = CURRENT_USER_NAME;
        }
            break;
            
        case 1:
        {
            
            cellLbl.text = @"Profiles";
        }
            break;
            
        case 2:
        {
            NSMutableString *inboxText=[[NSMutableString alloc]init];
            if(inboxCount == nil)
            {
                cellLbl.text = @"Inbox (0)";
            }
            else
            {
                [inboxText appendFormat:@"Inbox (%@)",inboxCount];
                cellLbl.text = inboxText;
            }
            
        }
            break;
        case 3:
        {
            cellLbl.text = @"Contacts";

        }
            break;
        case 4:
        {
            if(chatBoxCount == nil)
            {
                cellLbl.text = @"Chat Box (0)";
            }
            else
            {
                //                [postingText appendFormat:@"%@",chatBoxCount];
                cellLbl.text = chatBoxCount;
            }

        }
            break;
        case 5:
        {
            cellLbl.text = @"Change Password";
            //cellLbl.text = @"Search Messages";
        }
            break;
        case 6:
        {
            cellLbl.text = @"About Us";

//            NSMutableString *postingText=[[NSMutableString alloc]init];
//            
//            if(postingCount == nil)
//            {
//                cellLbl.text = @"Posting (0)";
//            }
//            else
//            {
//                [postingText appendFormat:@"Posting (%@)",postingCount];
//                cellLbl.text = postingText;
//            }
        }
            break;
        case 7:
        {
            cellLbl.text = @"Contact Us";

           //cellLbl.text = @"Compose";
        }
            break;
        case 8:
        {
            cellLbl.text = @"Logout";

//            NSMutableString *postingText;
//            NSMutableString *draftText=[[NSMutableString alloc]init];
//            if(draftCount == nil)
//            {
//                 cellLbl.text=@"Draft (0)";
//            }
//            else
//            {
//                [draftText appendFormat:@"Draft (%@)",draftCount];
//                cellLbl.text = draftText;
//            }
//             postingText = [[NSMutableString alloc]init];
        }
            break;
//        case 9:
//        {
//            cellLbl.text = @"";
//
//            //cellLbl.text = @"Change Password";
//        }
            break;
//        case 10:
//        {
//            cellLbl.text = @"About Us";
//        }
//            break;
//        case 11:
//        {
//            cellLbl.text = @"Contact Us";
//        }
//            break;
//        case 12:
//        {
//            cellLbl.text = @"Logout";
//        }
//            break;
//        case 13:
//        {
//            cellLbl.text = @"";
//        }
//            
            
        default:
            break;
    }
    
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 39;
     return 55;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewObj = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 200)];
    [viewObj setBackgroundColor: [UIColor colorWithRed:209.0f/255.0f green:88.0f/255.0f blue:12.0f/255.0f alpha:1]];
    return viewObj;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewObj = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 200)];
    [viewObj setBackgroundColor:[UIColor colorWithRed:209.0f/255.0f green:88.0f/255.0f blue:12.0f/255.0f alpha:1]];
    UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menuFooter@2x.png"]];
    [image.layer setBorderWidth:1];
    [image.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [viewObj addSubview:image];
    return viewObj;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            break;
        }
        case 1:
        {
            
            [self profileAlertView];
            break;
        }
        case 2:
        {
            
            inboxMessageViewController=[[InboxMessageViewController alloc]initWithNibName:@"InboxMessageViewController" bundle:[NSBundle mainBundle]];
            [Parameters pushFromView:perentClass toView:inboxMessageViewController withTransition:UIViewAnimationTransitionNone];
            [self reArrangeView];
            break;
        }
        case 3:
        {
            contactViewController =[[ContactViewController alloc]initWithNibName:@"ContactViewController" bundle:[NSBundle mainBundle]];
            [Parameters pushFromView:perentClass toView:contactViewController withTransition:UIViewAnimationTransitionNone];
            [self reArrangeView];
            break;
        }
        case 4:
        {
            chatContactsViewController =[[ChatContactsViewController alloc]initWithNibName:@"ChatContactsViewController" bundle:[NSBundle mainBundle]];
            [Parameters pushFromView:perentClass toView:chatContactsViewController withTransition:UIViewAnimationTransitionNone];
            [self reArrangeView];


            break;
        }
        case 5:
        {
            changePasswordViewController=[[ChangePasswordViewController alloc]initWithNibName:@"ChangePasswordViewController" bundle:[NSBundle mainBundle]];
            [Parameters pushFromView:perentClass toView:changePasswordViewController withTransition:UIViewAnimationTransitionNone];
            [self reArrangeView];

//            quickSearchViewController =[[QuickSearchViewController alloc]initWithNibName:@"QuickSearchViewController" bundle:[NSBundle mainBundle]];
//            [Parameters pushFromView:perentClass toView:quickSearchViewController withTransition:UIViewAnimationTransitionNone];
//            [self reArrangeView];
            break;
        }
        case 6:
        {
            aboutUsViewController=[[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController" bundle:[NSBundle mainBundle]];
            [Parameters pushFromView:perentClass toView:aboutUsViewController withTransition:UIViewAnimationTransitionNone];
            [self reArrangeView];
            
//            postingMessageViewController=[[PostingMessageViewController alloc]initWithNibName:@"PostingMessageViewController" bundle:[NSBundle mainBundle]];
//            [Parameters pushFromView:perentClass toView:postingMessageViewController withTransition:UIViewAnimationTransitionNone];
//            [self reArrangeView];
            break;
        }
        case 7:
        {
            contactUsViewController=[[ContactUsViewController alloc]initWithNibName:@"ContactUsViewController" bundle:[NSBundle mainBundle]];
            
            stringForTitle=@"Contact Us";
            
            [Parameters pushFromView:perentClass toView:contactUsViewController withTransition:UIViewAnimationTransitionNone];
            [self reArrangeView];
            
//            composeViewController=[[ComposeViewController alloc]initWithNibName:@"ComposeViewController" bundle:[NSBundle mainBundle]];
//            if (stringForTitle!=nil)
//            {
//                stringForTitle=nil;
//            }
//            stringForTitle=@"Compose";
//            
//            [Parameters pushFromView:perentClass toView:composeViewController withTransition:UIViewAnimationTransitionNone];
//            [self reArrangeView];
            break;
        }
        case 8:
        {
            [self logoutAlertView];
//            draftViewController =[[DraftViewController alloc]initWithNibName:@"DraftViewController" bundle:[NSBundle mainBundle]];
//            [Parameters pushFromView:perentClass toView:draftViewController withTransition:UIViewAnimationTransitionNone];
//            [self reArrangeView];
            break;
        }
//        case 9:
//        {
//            changePasswordViewController=[[ChangePasswordViewController alloc]initWithNibName:@"ChangePasswordViewController" bundle:[NSBundle mainBundle]];
//            [Parameters pushFromView:perentClass toView:changePasswordViewController withTransition:UIViewAnimationTransitionNone];
//            [self reArrangeView];
//            break;
//        }
//        case 10:
//        {
//            aboutUsViewController=[[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController" bundle:[NSBundle mainBundle]];
//            [Parameters pushFromView:perentClass toView:aboutUsViewController withTransition:UIViewAnimationTransitionNone];
//            [self reArrangeView];
//            break;
//        }
//        case 11:
//        {
//            //contactUsViewControllerFlag=YES;
//            contactUsViewController=[[ContactUsViewController alloc]initWithNibName:@"ContactUsViewController" bundle:[NSBundle mainBundle]];
//            
//            stringForTitle=@"Contact Us";
//            
//            [Parameters pushFromView:perentClass toView:contactUsViewController withTransition:UIViewAnimationTransitionNone];
//            [self reArrangeView];
//            break;
//        }
//        case 12:
//        {
//            [self logoutAlertView];
//            break;
//        }
            
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 11) //Profile Alert
    {
        if(buttonIndex ==1)
        {
            [self handlePersonalProfileAction];
        }
        if(buttonIndex ==2)
        {
            [self handleProfessionalProfileAction];
        }
        
    }
    else  if(alertView.tag == 33) //Logout Alert
    {
        if(buttonIndex ==0)
        {
            [self handleLogoutOkAction];
        }
    }
}

-(void)profileAlertView
{
    if (IS_IOS8)
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kAlertTitle message:@"Which Profile do you want to go to?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *personalAction = [UIAlertAction
                                   actionWithTitle:@"Personal"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                       [self handlePersonalProfileAction];
                                       
                                   }];
        [alertVC addAction:personalAction];
        
        UIAlertAction *professionalAction = [UIAlertAction
                                       actionWithTitle:@"Professional"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                           [self handleProfessionalProfileAction];
                                       }];
        
        [alertVC addAction:professionalAction];
        
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
        UIAlertView *alertvc=[[UIAlertView alloc]initWithTitle:@"" message:@"Which Profile do you want to go to?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Personal",@"Professional", nil];
        alertvc.tag = 11;
        [alertvc show];
    }
}

-(void)logoutAlertView
{
    if (IS_IOS8)
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kAlertTitle message:@"Do you want to Logout?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction *action)
                                         {
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                             [self handleLogoutOkAction];
                                             
                                         }];
        [alertVC addAction:OKAction];
        
        
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
        UIAlertView *alertvc=[[UIAlertView alloc]initWithTitle:@"" message:@"Do you want to Logout?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        alertvc.tag = 33;
        [alertvc show];
    }
    
}
-(void)handleLogoutOkAction
{
    objAppDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (objAppDelegate.internetStatus==0)
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
        
        [serviceIntegration LogoutWebService:self UserId:CURRENT_USER_ID IsBackground:@"False" :@selector(receivedResponseLogout:)];
    }
}
-(void)handlePersonalProfileAction
{
    profileType = @"1";  //personal
    [self callViewLogInUserProfileWsWithType];
   
}
-(void)handleProfessionalProfileAction
{
    profileType = @"2";  //professional
    [self callViewLogInUserProfileWsWithType];
}
#pragma mark - Custom Setting Methods
- (void)reArrangeView
{
    isMenuOpen = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4f];
    [self.view setFrame:CGRectMake(-SCREEN_WIDTH,0,self.view.frame.size.width,SCREEN_HEIGHT)];
    [perentView setUserInteractionEnabled:YES];
    [perentView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [navigationBar setFrame:CGRectMake(0, 20, navigationBar.frame.size.width, navigationBar.frame.size.height)];
    
    objAppDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    UIView *overlappingView = [objAppDelegate.window  viewWithTag:999];
    if (overlappingView) {
        [overlappingView removeFromSuperview];
    }
    
    [UIView commitAnimations];
    
}

- (void)receivedResponseLogout:(NSArray *)responseDict
{
    //NSLog(@"cont Resp%@",responseDict);
    if([[responseDict valueForKey:@"success"]isEqualToString:@"true"])
    {
        //clear native cache after logout
        [CommonNotification resetMessagesAfterLogoutForAll];
        
        NSUserDefaults *applicationUserDefault;
        
        applicationUserDefault = [NSUserDefaults standardUserDefaults];
        [applicationUserDefault setValue:nil forKey:@"CURRENT_USER_NAME"];
        [applicationUserDefault setValue:nil forKey:@"CURRENT_USER_PASSWORD"];
        [applicationUserDefault setValue:nil forKey:@"CURRENT_USER_ID"];
        [applicationUserDefault setValue:nil forKey:@"CURRENT_USER_IMAGE"];
        [applicationUserDefault synchronize];

        
        
       
        loginViewController=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];

        [Parameters pushFromView:perentClass toView:loginViewController withTransition:UIViewAnimationTransitionNone];
        [self reArrangeView];
        
        [SVProgressHUD showSuccessWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
       
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];

    }
}

-(void)callViewLogInUserProfileWsWithType
{
    objAppDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (objAppDelegate.internetStatus==0)
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
        [serviceIntegration GetLogInUserProfile:self userId:CURRENT_USER_ID profileTypeId:profileType :@selector(receivedResponseLogiNuserProfile:)];
    }
}
- (void)receivedResponseLogiNuserProfile:(NSArray *)responseDict
{
    
    //NSLog(@"cont Resp%@",responseDict);
    if([[responseDict valueForKey:@"success"]isEqualToString:@"true"])
    {
        [SVProgressHUD dismiss];
        //clear native cache after logout
        if ([profileType isEqualToString:@"1"])
        {
                      actualPersonalVC *personalVC = [[actualPersonalVC alloc] initWithNibName:@"actualPersonalVC" bundle:nil];
            stringForTitle=@"Personal Profile";
            personalVC.menuVc = self;
            
            personalVC.contactArray = [[NSMutableArray alloc]init];
            [personalVC.contactArray addObject:responseDict];
            [Parameters pushFromView:perentClass toView:personalVC withTransition:UIViewAnimationTransitionNone];
        }
        else
        {
           
            actualProfessionalVC *actualProfessional = [[actualProfessionalVC alloc] initWithNibName:@"actualProfessionalVC" bundle:[NSBundle mainBundle]];
            stringForTitle=@"Professional Profile";
            actualProfessional.professionalProfileArray = [[NSMutableArray alloc]init];
            ;
            
            [actualProfessional.professionalProfileArray addObject:responseDict];
            [Parameters pushFromView:perentClass toView:actualProfessional withTransition:UIViewAnimationTransitionNone];
        }
        [self reArrangeView];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"Unalbe to Load" maskType:SVProgressHUDMaskTypeBlack];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

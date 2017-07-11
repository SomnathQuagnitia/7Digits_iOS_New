//
//  ChatContactsViewController.m
//  7EvenDigits
//
//  Created by Neha_Mac on 14/11/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import "ChatContactsViewController.h"
#import "AddContactViewController.h"
#import "MenuViewController.h"
#import "Constant.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ChatMeassageVC.h"
#import "HomeViewController.h"
@interface ChatContactsViewController ()
{
    NSUserDefaults *nsDef;
}
@end

@implementation ChatContactsViewController
@synthesize statusImage,firstLastNameLabel,userNameLabel,deleteButton,contactDataAfterSearch,
searchBarforContact,chatContactArray;
@synthesize customCellForContact;
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
    
    self.navigationController.navigationBarHidden=NO;
    nsDef = [NSUserDefaults standardUserDefaults];

    
    searching=NO;
    UIBarButtonItem *menuBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"home_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelHome)];
    self.navigationItem.leftBarButtonItem=menuBarBtn;
    searchBarforContact.barTintColor=[UIColor colorWithRed:235.0f/255.0f green:110.0f/255.0f blue:30.0f/255.0f alpha:1 ];
    [self tableFooterAdjustment];
}
-(void)viewWillAppear:(BOOL)animated
{
    searching=FALSE;
    searchBarforContact.text=@"";
    [searchBarforContact resignFirstResponder];
    [self CallChatContactListWebService];
    [self.tableViewContacts reloadData];
}

-(void)CallChatContactListWebService
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
        
        [serviceIntegration GetContactsBadge:self userId:CURRENT_USER_ID :@selector(receivedResponseContactListInChat:)];
    }
}
#pragma mark==Navigate to home view
-(void)handelHome
{
    [searchBarforContact resignFirstResponder];
    HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
    [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
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
        return [contactDataAfterSearch count];
    }
    else
    {
        return [chatContactArray count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    customCellForContact = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(customCellForContact==nil)
    {
        customCellForContact=[[[NSBundle mainBundle]loadNibNamed:@"ContactCustomCell" owner:self options:nil]objectAtIndex:0];
        customCellForContact.showsReorderControl=YES;
    }
    customCellForContact.selectionStyle=UITableViewCellSelectionStyleNone;
    
    NSString *chatStatus;
    NSString *firstName;
    NSString *badgeCount;
    NSURL *url;
    if (searching)
    {
        firstName=[[contactDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"FullName"];
        
        customCellForContact.labelForContactID.text=[NSString stringWithFormat:@"%@",[[contactDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"UserName"]];
        
        chatStatus=[[contactDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"ChatStatus"];
        
        url = [NSURL URLWithString:[[[contactDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"ContactImage"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        
        badgeCount=[NSString stringWithFormat:@"%@",[[contactDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"Badge"]];
    }
    else
    {
        firstName=[[chatContactArray objectAtIndex:indexPath.row]valueForKey:@"FullName"];
        
        customCellForContact.labelForContactID.text=[NSString stringWithFormat:@"%@",[[chatContactArray objectAtIndex:indexPath.row]valueForKey:@"UserName"]];
        
        chatStatus=[[chatContactArray objectAtIndex:indexPath.row]valueForKey:@"ChatStatus"];
        
        url = [NSURL URLWithString:[[[chatContactArray objectAtIndex:indexPath.row]valueForKey:@"ContactImage"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        
        badgeCount=[NSString stringWithFormat:@"%@",[[chatContactArray objectAtIndex:indexPath.row]valueForKey:@"Badge"]];
    }
    

    
    if ([[NSString stringWithFormat:@"%@",url] hasSuffix:@"default_Contact.png"] || [[NSString stringWithFormat:@"%@",url] hasSuffix:@"noimage.png"])
    {
        customCellForContact.imageViewForContactImage.image = [UIImage imageNamed:@"default_profile_img.png"];
    }
    else
    {
       [customCellForContact.imageViewForContactImage hnk_setImageFromURL:url];
    }
    
    [customCellForContact.deleteButton addTarget:self action:@selector(handelDeleteContact:event:) forControlEvents:UIControlEventTouchUpInside];

        customCellForContact.labelForContactName.text=firstName;

    if([chatStatus isEqualToString:@"Online"])
    {
        customCellForContact.imageViewForContactStatusImage.image=[UIImage imageNamed:@"online.png"];
    }
    else
    {
        customCellForContact.imageViewForContactStatusImage.image=[UIImage imageNamed:@"offline.png"];
    }
   
    if(![badgeCount isEqualToString:@"0"])
    {
        [CustomBadge getCustomBadgeWithY:0 gap:0 badgeValue:badgeCount onView:customCellForContact.contentView];
    }
    return customCellForContact;
}



-(void)handelDeleteContact:(UIButton *)button event:(UIEvent *)event
{
    selectedIndexpath=[self.tableViewContacts indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.tableViewContacts]];
    //NSLog(@"indexpath %ld",(long)indexpath.row);
    
        if (IS_IOS8)
        {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kAlertTitle message:@"Are you sure you want to delete this contact ?" preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                           [self handleOkAction];
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
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you want to delete this contact ?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//            [alert show];
        }
  
}


#pragma mark Alert View Delegate

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0)
//    {
//        [self handleOkAction];
//    }
//}
-(void)handleOkAction
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
        
        if(searching)
        {
            contactId=[[contactDataAfterSearch objectAtIndex:selectedIndexpath.row]valueForKey:@"ContactId"];
            contactUserId = [[contactDataAfterSearch objectAtIndex:selectedIndexpath.row]valueForKey:@"AddedUserId"];
        }
        else
        {
            contactId=[[chatContactArray objectAtIndex:selectedIndexpath.row]valueForKey:@"ContactId"];
            contactUserId = [[chatContactArray objectAtIndex:selectedIndexpath.row]valueForKey:@"AddedUserId"];
        }
        [serviceIntegration DeleteContact:self ContactId:contactId  :@selector(receivedResponseDataDeleteContactInChat:)];
        
        [searchBarforContact resignFirstResponder];
        searchBarforContact.text=@"";
        searching=FALSE;
    }
}
- (void)receivedResponseDataDeleteContactInChat:(NSDictionary *)responseDict
{
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        [SVProgressHUD showSuccessWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
        [CommonNotification resetMessagesForUser:contactUserId];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
    [self CallChatContactListWebService];
    [self.tableViewContacts reloadData];
}
//Did select row at index path
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url;
    if (objchat!=nil)
    {
        objchat=nil;
    }
    objchat=[[ChatMeassageVC alloc]initWithNibName:@"ChatMeassageVC" bundle:[NSBundle mainBundle]];
    if(searching)
    {
        objchat.chatUserID=[NSString stringWithFormat:@"%@",[[contactDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"AddedUserId"]];
        
        objchat.userStatus=[NSString stringWithFormat:@"%@",[[contactDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"ChatStatus"]] ;
        
        objchat.titleName=[[contactDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"UserName"];
        
        url = [NSURL URLWithString:[[[contactDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"ContactImage"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    }
    else
    {
        objchat.chatUserID=[NSString stringWithFormat:@"%@",[[chatContactArray objectAtIndex:indexPath.row]valueForKey:@"AddedUserId"]];
        
        objchat.userStatus=[NSString stringWithFormat:@"%@",[[chatContactArray objectAtIndex:indexPath.row]valueForKey:@"ChatStatus"]] ;
        objchat.titleName=[[chatContactArray objectAtIndex:indexPath.row]valueForKey:@"UserName"];
        
        url = [NSURL URLWithString:[[[chatContactArray objectAtIndex:indexPath.row]valueForKey:@"ContactImage"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    }
    
    NSString *urlStr =[NSString stringWithFormat:@"%@",url];
    if ([urlStr hasSuffix:@"default_Contact.png"] || [urlStr hasSuffix:@"noimage.png"] )
    {
        objchat.chatUserImageURL = nil;
    }
    else
    {
        if ([urlStr hasSuffix:@".png"] || [urlStr hasSuffix:@".jpg"]|| [urlStr hasSuffix:@".JPG"])
        {
            objchat.chatUserImageURL = url;
        }
        else
        {
            objchat.chatUserImageURL = nil;
        }
    }
    
    j = (long)indexPath.row;
  
    searchBarforContact.text=@"";
    [searchBarforContact resignFirstResponder];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *checkStatus1 = [[chatContactArray objectAtIndex:indexPath.row]valueForKey:@"ChatStatus"];
    if([checkStatus1 isEqualToString:@"Offline"])
    {
        if(![self.navigationController.viewControllers isKindOfClass:[ChatMeassageVC class]])
        {
            [userDef setObject:@"offline" forKey:@"off"];
            [self.navigationController pushViewController:objchat animated:YES];
            [userDef synchronize];
        }
    }
    else
    {
        
           [userDef setObject:@"online" forKey:@"off"];
           [self CallCheckUserLoginWebService];
           [userDef synchronize];
        
    }

}

#pragma mark == CheckLoginUserChatWebService

-(void)CallCheckUserLoginWebService
{
    int UserID = [[[chatContactArray objectAtIndex:j] valueForKey:@"AddedUserId"] intValue];
    appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (appDeleagated.internetStatus==0)
    {
        [SVProgressHUD showErrorWithStatus:@"Internet connection not available" maskType:SVProgressHUDMaskTypeBlack];
        
    }
    else
    {
        if (serviceIntegration != nil)
        {
            serviceIntegration = nil;
        }
        serviceIntegration = [[ServerIntegration alloc]init];
        
        [serviceIntegration ChkLoginDevice:self UsetID:UserID :@selector(receivedResponseForCheckLoginUser:)];
    }
}

-(void)receivedResponseForCheckLoginUser:(NSDictionary *)responseDict
{
    if([[responseDict valueForKey:@"success"] isEqualToString:@"True"])
    {
        if(![self.navigationController.viewControllers isKindOfClass:[ChatMeassageVC class]])
        {
            [nsDef setInteger:2 forKey:@"one"];
            [nsDef synchronize];
            [self.navigationController pushViewController:objchat animated:YES];
        }
    }
    else
    {
        if(![self.navigationController.viewControllers isKindOfClass:[ChatMeassageVC class]])
        {
           [SVProgressHUD dismiss];
           [nsDef setInteger:1 forKey:@"one"];
           [nsDef synchronize];
           [self.navigationController pushViewController:objchat animated:YES];
        }

    }
}
-(void)showOverwriteAlert
{
    if (IS_IOS8)
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kAlertTitle message:@"Oops...pictures or videos can only be sent between app users." preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [nsDef setInteger:1 forKey:@"one"];
                                       [nsDef synchronize];
                                       [self.navigationController pushViewController:objchat animated:YES];

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
//        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"" message:@"Oops...pictures or videos can only be sent between app users." delegate:self cancelButtonTitle:@"Accept" otherButtonTitles:@"Ignore", nil];
//        alrt.tag = 1;
//        [alrt show];
    }
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
    self.tableViewContacts.tableFooterView = view;
}

#pragma mark - Service IntegrationDelegate

- (void)receivedResponseContactListInChat:(NSArray *)responseDict
{
     [SVProgressHUD dismiss];
  NSLog(@"cont Resp%@",responseDict);
    chatContactArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[responseDict count]; i++)
    {
        {
            [chatContactArray addObject:[responseDict objectAtIndex:i]];
        }
    }
    if([chatContactArray count]==0)
    {
        [noRecFound setHidden:NO];
    }
    else
    {
        
        [noRecFound setHidden:YES];
    }
    
    [self.tableViewContacts reloadData];
    
    int count=0;
    for (int i=0; i<[responseDict count]; i++)
    {
        if (![[NSString stringWithFormat:@"%@",[[responseDict objectAtIndex:i]valueForKey:@"Badge" ]] isEqualToString:@"0"])
        {
            count++;
        }
    }
    chatTitle = [NSString stringWithFormat:@"Chat Box (%d)",count];
    self.title = chatTitle;
}

#pragma mark - Search Bar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    searchBarforContact.autocapitalizationType= UITextAutocapitalizationTypeNone;
    searchBarforContact.autocorrectionType= UITextAutocorrectionTypeNo;
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    searchBar.showsCancelButton = NO;
    searchBarforContact.text=@"";
    searching=FALSE;
    [self CallChatContactListWebService];
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar*)searchBar1 textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        searching = FALSE;
        [self.tableViewContacts reloadData];
    }
    else
    {
        NSString *searchText = searchBar1.text;
        contactDataAfterSearch  = [[NSMutableArray alloc] init];
        for (NSMutableArray *item1 in chatContactArray)
        {
            NSString *string =[item1 valueForKey:@"FirstName"];
            NSRange range = [string rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound)
            {
                [self.contactDataAfterSearch addObject:item1];
            }
        }
        searching = true;
    }
    [self.tableViewContacts reloadData];
}
- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    searchBarforContact.text=[NSString stringWithFormat:@"%@",[theSearchBar text]];
    [searchBarforContact resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

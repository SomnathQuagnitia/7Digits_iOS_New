//
//  ContactViewController.m
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import "ContactViewController.h"
#import "AddContactViewController.h"
#import "MenuViewController.h"
#import "Constant.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HomeViewController.h"
#import "SearchContactViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController
@synthesize statusImage,firstLastNameLabel,userNameLabel,deleteButton,contactDataAfterSearch,
searchBarforContact,searchContactVC,personalVC,professionalVC;
@synthesize customCellForContact;
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
    self.title=@"Contacts";
    
    searching=NO;
    
    UIBarButtonItem *menuBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"home_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelHome)];
    self.navigationItem.leftBarButtonItem=menuBarBtn;
    
    searchBarforContact.barTintColor=[UIColor colorWithRed:235.0f/255.0f green:110.0f/255.0f blue:30.0f/255.0f alpha:1 ];
    
    
    UIBarButtonItem *allBarButton=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"add_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelAdd)];
    
    self.navigationItem.rightBarButtonItem=allBarButton;
    [self tableFooterAdjustment];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    searching=FALSE;
    searchBarforContact.text=@"";
    [searchBarforContact resignFirstResponder];
    [self CallContactListWebService];
    [self.tableViewContacts reloadData];
}
-(void)CallContactListWebService
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
        
        [serviceIntegration GetContactListWebService:self UserId:CURRENT_USER_ID :@selector(receivedResponseContactList:)];
    }
}



-(void)handelAdd
{
    //addContactFlag=YES;
    [self.tableViewContacts setScrollEnabled:NO];
    [self.tableViewContacts setAlpha:0.3];
    [self.view setBackgroundColor:[UIColor blackColor]];
    if(![popUpView isDescendantOfView:self.view])
    {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:popUpView.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft |UIRectCornerTopRight) cornerRadii:CGSizeMake(10.0, 10.0)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.view.bounds;
        maskLayer.path  = maskPath.CGPath;
        popUpView.layer.mask = maskLayer;
        popUpView.center = self.view.center;
        [popUpView setAlpha:0.0];
        [self.view addSubview:popUpView];
        [UIView beginAnimations:nil context:nil];
        [popUpView setAlpha:1.0];
        [UIView commitAnimations];
    }
//    if (IS_IOS8)
//    {
//        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Add Contact" message:@"How do you want to add your new contacts?" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *ManuallyBtn = [UIAlertAction
//                                   actionWithTitle:@"Manually"
//                                   style:UIAlertActionStyleDefault
//                                   handler:^(UIAlertAction *action)
//                                   {
//                                       [self dismissViewControllerAnimated:YES completion:nil];
//                                       AddContactViewController *addc=[[AddContactViewController alloc]initWithNibName:@"AddContactViewController" bundle:[NSBundle mainBundle]];
//                                       if (stringForTitle!=nil)
//                                       {
//                                           stringForTitle=nil;
//                                       }
//                                       stringForTitle=@"Add Contact";
//                                       addc.title=stringForTitle;
//                                       addc.isEditingMyProfile =@"No";
//                                       
//                                       [self.navigationController pushViewController:addc animated:YES];                                   }];
//        [alertVC addAction:ManuallyBtn];
//        
//        UIAlertAction *searchBtn = [UIAlertAction
//                                       actionWithTitle:@"Search"
//                                       style:UIAlertActionStyleDefault
//                                       handler:^(UIAlertAction *action)
//                                       {
//                                           searchContactVC=[[SearchContactViewController alloc]initWithNibName:@"SearchContactViewController" bundle:[NSBundle mainBundle]];
//                                           [self.navigationController pushViewController:searchContactVC animated:YES];
//
//                                       }];
//        
//        [alertVC addAction:searchBtn];
//        
//        UIAlertAction *cancelBtn = [UIAlertAction
//                                    actionWithTitle:@"Cancel"
//                                    style:UIAlertActionStyleDefault
//                                    handler:^(UIAlertAction *action)
//                                    {
//                                        [self dismissViewControllerAnimated:YES completion:nil];
//                                       }];
//        [alertVC addAction:cancelBtn];
//        [self presentViewController:alertVC animated:YES completion:nil];
//    }
//    else
//    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Add Contact" message:@"How do you want to add your new contacts?" delegate:self cancelButtonTitle:@"Manually" otherButtonTitles:@"Search", nil];
//        [alert show];
//    }
    
}


#pragma mark==Navigate to home view
-(void)handelHome
{
    [searchBarforContact resignFirstResponder];
    //[self slideViewWithAnimation];
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
        return [contactArray count];
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
    
    //NSString *chatStatus;
    NSString *firstName;
    
    
    NSURL *url;
    if (searching)
    {
        firstName=[[contactDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"FullName"];
        
        NSString *profileType1 = [NSString stringWithFormat:@"%@",[[contactDataAfterSearch objectAtIndex:indexPath.row] valueForKey:@"ProfileType"]];
        if([profileType1 isEqualToString:@"<null>"])
        {
            profileType1 = @"1";
           if([profileType1 isEqualToString:@"1"])
           {
               customCellForContact.labelForContactID.text=[NSString stringWithFormat:@"%@",[[contactDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"UserName"]];
               if(customCellForContact.labelForContactID.text.length > 20)
               {
                   customCellForContact.contactIDScrollView.userInteractionEnabled = YES;
               }
               else
               {
                   customCellForContact.contactIDScrollView.userInteractionEnabled = NO;
               }

           }
           else
           {
               if([[[contactDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"CompanyName"] isEqualToString:@""])
               {
                   customCellForContact.labelForContactID.text = @"Not Mentioned";
               }
               else
               {
                   customCellForContact.labelForContactID.text = [[contactDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"CompanyName"];
                   [customCellForContact.contactIDScrollView setContentSize:CGSizeMake(customCellForContact.labelForContactID.frame.size.width, 0)];
                   if(customCellForContact.labelForContactID.text.length > 20)
                   {
                       customCellForContact.contactIDScrollView.userInteractionEnabled = YES;
                   }
                   else
                   {
                       customCellForContact.contactIDScrollView.userInteractionEnabled = NO;
                   }

                }
           }
        }
        else
        {
            if([profileType1 isEqualToString:@"1"])
            {
                customCellForContact.labelForContactID.text=[NSString stringWithFormat:@"%@",[[contactDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"UserName"]];
                if(customCellForContact.labelForContactID.text.length > 20)
                {
                    customCellForContact.contactIDScrollView.userInteractionEnabled = YES;
                }
                else
                {
                    customCellForContact.contactIDScrollView.userInteractionEnabled = NO;
                }

            }
            else
            {
                if([[[contactDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"CompanyName"] isEqualToString:@""])
                {
                    customCellForContact.labelForContactID.text = @"Not Mentioned";
                }
                else
                {
                    customCellForContact.labelForContactID.text = [[contactDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"CompanyName"];
                    [customCellForContact.contactIDScrollView setContentSize:CGSizeMake(customCellForContact.labelForContactID.frame.size.width, 0)];
                    if(customCellForContact.labelForContactID.text.length > 20)
                    {
                        customCellForContact.contactIDScrollView.userInteractionEnabled = YES;
                    }
                    else
                    {
                        customCellForContact.contactIDScrollView.userInteractionEnabled = NO;
                    }
                }
            }
        }
        
        profileCircleType = [[[contactDataAfterSearch objectAtIndex:indexPath.row] valueForKey:@"ProfileCircule"] intValue];
        // chatStatus=[[contactDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"ChatStatus"];
        url = [NSURL URLWithString:[[[contactDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"ContactImage"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        
    }
    else
    {
        firstName=[[contactArray objectAtIndex:indexPath.row]valueForKey:@"FullName"];
        
        NSString *profileType1 = [NSString stringWithFormat:@"%@",[[contactArray objectAtIndex:indexPath.row] valueForKey:@"ProfileType"]];
        if([profileType1 isEqualToString:@"<null>"])
        {
            profileType1 = @"1";
           if([profileType1 isEqualToString:@"1"])
           {
               customCellForContact.labelForContactID.text=[[contactArray objectAtIndex:indexPath.row]valueForKey:@"UserName"];
               if(customCellForContact.labelForContactID.text.length > 20)
               {
                   customCellForContact.contactIDScrollView.userInteractionEnabled = YES;
               }
               else
               {
                   customCellForContact.contactIDScrollView.userInteractionEnabled = NO;
               }

           }
           else
           {
                 if([[[contactArray objectAtIndex:indexPath.row]valueForKey:@"CompanyName"] isEqualToString:@""])
                 {
                     customCellForContact.labelForContactID.text = @"Not Mentioned";
                 }
                 else
                 {
                      customCellForContact.labelForContactID.text = [[contactArray objectAtIndex:indexPath.row]valueForKey:@"CompanyName"];
                     [customCellForContact.contactIDScrollView setContentSize:CGSizeMake(customCellForContact.labelForContactID.frame.size.width, 0)];
                     if(customCellForContact.labelForContactID.text.length > 20)
                     {
                         customCellForContact.contactIDScrollView.userInteractionEnabled = YES;
                     }
                     else
                     {
                         customCellForContact.contactIDScrollView.userInteractionEnabled = NO;
                     }
                  }
            }
        }
        else
        {
            if([profileType1 isEqualToString:@"1"])
            {
                customCellForContact.labelForContactID.text=[[contactArray objectAtIndex:indexPath.row]valueForKey:@"UserName"];
                if(customCellForContact.labelForContactID.text.length > 20)
                {
                    customCellForContact.contactIDScrollView.userInteractionEnabled = YES;
                }
                else
                {
                    customCellForContact.contactIDScrollView.userInteractionEnabled = NO;
                }
            }
            else
            {
                if([[[contactArray objectAtIndex:indexPath.row]valueForKey:@"CompanyName"] isEqualToString:@""])
                {
                    customCellForContact.labelForContactID.text = @"Not Mentioned";
                }
                
                
                else
                {
                    customCellForContact.labelForContactID.text = [[contactArray objectAtIndex:indexPath.row]valueForKey:@"CompanyName"];
                    [customCellForContact.contactIDScrollView setContentSize:CGSizeMake(customCellForContact.labelForContactID.frame.size.width, 0)];
                    if(customCellForContact.labelForContactID.text.length > 20)
                    {
                        customCellForContact.contactIDScrollView.userInteractionEnabled = YES;
                    }
                    else
                    {
                        customCellForContact.contactIDScrollView.userInteractionEnabled = NO;
                    }
                }
            }
        }
        
        profileCircleType = [[[contactArray objectAtIndex:indexPath.row] valueForKey:@"ProfileCircule"] intValue];
        url = [NSURL URLWithString:[[[contactArray objectAtIndex:indexPath.row]valueForKey:@"ContactImage"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        NSLog(@"Contact Array :  %@",contactArray);
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
    
       NSString *profileType1 = [NSString stringWithFormat:@"%@",[[contactArray objectAtIndex:indexPath.row] valueForKey:@"ProfileType"]];
       if([profileType1 isEqualToString:@"<null>"])
       {
           profileType1 = @"1";
          if([profileType1 isEqualToString:@"1"])
          {
              customCellForContact.ProfileType.text = @"Personal";
          }
          else
          {
             customCellForContact.ProfileType.text = @"Professional";
          }
       }
       else
       {
           if([profileType1 isEqualToString:@"1"])
           {
               customCellForContact.ProfileType.text = @"Personal";
           }
           else
           {
               customCellForContact.ProfileType.text = @"Professional";
           }
       }
    
         if(profileCircleType == 1)
        {
            customCellForContact.imageViewForContactStatusImage.image=[UIImage imageNamed:@"inner_circle1.png"];
        }
        else if (profileCircleType == 2)
        {
            customCellForContact.imageViewForContactStatusImage.image=[UIImage imageNamed:@"inner_circle3.png"];
        }
        else if (profileCircleType == 3)
        {
            customCellForContact.imageViewForContactStatusImage.image=[UIImage imageNamed:@"inner_circle2.png"];
        }
        return customCellForContact;
}

-(void)handelDeleteContact:(UIButton *)button event:(UIEvent *)event
{
    selectedIndexpath=[self.tableViewContacts indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.tableViewContacts]];
    
    
    if (IS_IOS8)
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kAlertTitle message:@"Are you sure you want to delete this contact ?" preferredStyle:UIAlertControllerStyleAlert];
               
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
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you want to delete this contact ?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//        [alert show];
    }
    
}


#pragma mark Alert View Delegate

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0)
//    {
//        [self handleOKAction];
//    }
//}
-(void)handleOKAction
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
        NSString *contactId;
        if(searching)
        {
            contactId=[[contactDataAfterSearch objectAtIndex:selectedIndexpath.row]valueForKey:@"ContactId"];
        }
        else
        {
            contactId=[[contactArray objectAtIndex:selectedIndexpath.row]valueForKey:@"ContactId"];
        }
        
        [serviceIntegration DeleteContact:self ContactId:contactId  :@selector(receivedResponseDataDeleteContact:)];
        
        [searchBarforContact resignFirstResponder];
        searchBarforContact.text=@"";
        searching=FALSE;
    }
}
- (void)receivedResponseDataDeleteContact:(NSDictionary *)responseDict
{
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        [SVProgressHUD showSuccessWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
    
    [self CallContactListWebService];
    [self.tableViewContacts reloadData];
}

//Did select row at index path
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(searching)
    {
        [self callViewContactProfile:[NSString stringWithFormat:@"%@",[[contactDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"ContactId"]]];
    }
    else
    {
        [self callViewContactProfile:[NSString stringWithFormat:@"%@",[[contactArray objectAtIndex:indexPath.row]valueForKey:@"ContactId"]]];
    }
}

-(void)callViewContactProfile:(NSString *)contactId
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    if (serviceIntegration != nil)
    {
        serviceIntegration = nil;
    }
    serviceIntegration = [[ServerIntegration alloc]init];
    [serviceIntegration ViewContact:self contactId:contactId :@selector(receivedResponseContactProfile:)];
}

- (void)receivedResponseContactProfile:(NSDictionary *)responseDict
{
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        [SVProgressHUD dismiss];
        if([[NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"userDTO" ] valueForKey:@"ProfileType"]]isEqualToString:@"2"])
        {
            professionalVC = [[actualProfessionalVC alloc]initWithNibName:@"actualProfessionalVC" bundle:[NSBundle mainBundle]];
            stringForTitle=@"Professional Profile";
            professionalVC.professionalProfileArray = [[NSMutableArray alloc]init];
            NSMutableDictionary *Dict = [[NSMutableDictionary alloc] initWithDictionary:responseDict];
            [Dict setValue:@"YES" forKey:@"Yes"];
            [professionalVC.professionalProfileArray addObject:Dict];
            [self.navigationController pushViewController:professionalVC animated:YES];
        }
       else
        {
            if(personalVC != nil)
            {
                personalVC = nil;
            }
            personalVC=[[actualPersonalVC alloc]initWithNibName:@"actualPersonalVC" bundle:[NSBundle mainBundle]];
            personalVC.objContactVC=self;
            personalVC.contactArray = [[NSMutableArray alloc]init];
            NSMutableDictionary *Dict = [[NSMutableDictionary alloc] initWithDictionary:responseDict];
            [Dict setValue:@"YES" forKey:@"Yes"];
            [personalVC.contactArray addObject:Dict];
            [self.navigationController pushViewController:personalVC animated:YES];
        }
        stringForTitle = @"Contact Profile";
        searchBarforContact.text=@"";
        [searchBarforContact resignFirstResponder];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
    
    [self CallContactListWebService];
    [self.tableViewContacts reloadData];
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
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
}

#pragma mark - Service IntegrationDelegate

- (void)receivedResponseContactList:(NSArray *)responseDict
{
    [SVProgressHUD dismiss];
    NSLog(@"cont Resp%@",responseDict);
    contactArray=[[NSMutableArray alloc]initWithArray:responseDict];
    if([contactArray count]==0)
    {
        [noRecFound setHidden:NO];
    }
    else
    {
        [noRecFound setHidden:YES];
    }
    
    [self.tableViewContacts reloadData];
}


#pragma mark==table View data
/*
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if(cell==nil)
 {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
 cell.showsReorderControl = YES;
 }
 
 cell.imageView.image=[UIImage imageNamed:@"no_image.png"];
 
 
 deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
 deleteButton.frame=CGRectMake(cell.frame.origin.x+240, cell.frame.origin.y+35, 20, 20);
 [deleteButton setImage:[UIImage imageNamed:@"not_ok.png"] forState:UIControlStateNormal];
 [deleteButton addTarget:self action:@selector(deleteBtnBtnClk) forControlEvents:UIControlEventTouchUpInside];
 deleteButton.tag=indexPath.row;
 [cell.contentView addSubview:deleteButton];
 
 
 
 //Status Image
 statusImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"status.png"]];
 statusImage.frame=CGRectMake(cell.frame.origin.x+275, cell.frame.origin.y+35, 15, 15);
 [cell.contentView addSubview:statusImage];
 
 //main Label
 firstLastNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(cell.frame.origin.x+85, cell.frame.origin.y+13, 150, 20)];
 firstLastNameLabel.text=@"Krishna Kumbhar";
 [cell.contentView addSubview:firstLastNameLabel];
 
 
 //Rplay ContactID  Label
 userNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(cell.frame.origin.x+85, cell.frame.origin.y+35, 150, 15)];
 userNameLabel.text=@"kk123";
 [cell.contentView addSubview:userNameLabel];
 
 */
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
    [self CallContactListWebService];
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
        for (NSMutableArray *item1 in contactArray)
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addContactManually:(id)sender
{
    [self cancelPopUp:nil];
    AddContactViewController *addc=[[AddContactViewController alloc]initWithNibName:@"AddContactViewController" bundle:[NSBundle mainBundle]];
    if (stringForTitle!=nil)
    {
        stringForTitle=nil;
    }
    stringForTitle=@"Add Contact";
    addc.title=stringForTitle;
    addc.isEditingMyProfile =@"No";
    
    [self.navigationController pushViewController:addc animated:YES];
}

- (IBAction)addContactWithSearch:(id)sender
{
    [self cancelPopUp:nil];
    searchContactVC=[[SearchContactViewController alloc]initWithNibName:@"SearchContactViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:searchContactVC animated:YES];
}

- (IBAction)cancelPopUp:(id)sender
{
    [self.tableViewContacts setScrollEnabled:YES];
    [self.tableViewContacts setAlpha:1.0];
    [popUpView setAlpha:1.0];
    [UIView beginAnimations:nil context:nil];
    [popUpView setAlpha:0.0];
    [UIView commitAnimations];
    [popUpView removeFromSuperview];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

@end

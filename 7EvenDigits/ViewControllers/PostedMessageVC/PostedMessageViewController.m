//
//  PostedMessageViewController.m
//  7EvenDigits
//
//  Created by Krishna on 09/10/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import "PostedMessageViewController.h"
#import "PostedMessageDetailViewController.h"
#import "AdvanceSearchViewController.h"
#import "ChatMeassageVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface PostedMessageViewController ()

@end

@implementation PostedMessageViewController
@synthesize postedMsgCustomCell,keywordForSearch,postedMessageArray,postedMsgDtlVc,advanceSearchViewController,cellIndexPath;
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
    self.title=@"Posted Message";
    
    [self tableFooterAdjustmentInPosted];
    
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelBackButton)];
    self.navigationItem.leftBarButtonItem=rightBarBtn;
   
    if (self.advanceSearchViewController)
    {
       myTimer = [NSTimer scheduledTimerWithTimeInterval: 30.0 target: self
                                                          selector: @selector(callPostedMessageWSForAdvanceSearch) userInfo: nil repeats: YES];
    }
    else
    {
       myTimer = [NSTimer scheduledTimerWithTimeInterval: 30.0 target: self
                                                          selector: @selector(callQuickSearchWS) userInfo: nil repeats: YES];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
     [self.ViewforLargeImage removeFromSuperview];
     [myTimer invalidate];
}

-(void)handelBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.postedTableView reloadData];
}
#pragma mark==Table View Datasource And Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [postedMessageArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    postedMsgCustomCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(postedMsgCustomCell==nil)
    {
        postedMsgCustomCell=[[[NSBundle mainBundle]loadNibNamed:@"PostedMessageCustomCell" owner:self options:nil]objectAtIndex:0];
        postedMsgCustomCell.showsReorderControl=YES;
    }
    
    
    postedMsgCustomCell.selectionStyle=UITableViewCellSelectionStyleNone;
    //postedMsgCustomCell.imageViewForProfileImage.image=[[postedMessageArray objectAtIndex:indexPath.row]objectForKey:@"UserImage"];
    postedMsgCustomCell.labelForState.text=[[postedMessageArray objectAtIndex:indexPath.row]valueForKey:@"StateName"];
    postedMsgCustomCell.labelForMessage.text=[[postedMessageArray objectAtIndex:indexPath.row]valueForKey:@"Title"];
    postedMsgCustomCell.labelForCity.text=[[postedMessageArray objectAtIndex:indexPath.row]valueForKey:@"CityName"];
    postedMsgCustomCell.labelForMessageFrom.text=[[postedMessageArray objectAtIndex:indexPath.row]valueForKey:@"MessageFrom"];
    postedMsgCustomCell.labelForPostedDate.text=[[postedMessageArray objectAtIndex:indexPath.row]valueForKey:@"PostedDate"];
    postedMsgCustomCell.labelForStartedByName.text=[[postedMessageArray objectAtIndex:indexPath.row]valueForKey:@"UserName"];
    postedMsgCustomCell.labelForeAge.text=[NSString stringWithFormat:@"%@",[[postedMessageArray objectAtIndex:indexPath.row]valueForKey:@"Age"]];
    
    postedMsgCustomCell.imageViewForProfileImage.tag = indexPath.row;
    NSURL *url = [NSURL URLWithString:[[[postedMessageArray objectAtIndex:indexPath.row]valueForKey:@"ImageName"]
                                       stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    [postedMsgCustomCell.imageViewForProfileImage setImageWithURL:url];
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunction:)];
    tapped.numberOfTapsRequired = 1;
    [postedMsgCustomCell.imageViewForProfileImage addGestureRecognizer:tapped];
    [postedMsgCustomCell.imageViewForProfileImage setUserInteractionEnabled:YES];

    
    
    if([[[postedMessageArray objectAtIndex:indexPath.row]valueForKey:@"ChatStatus"]isEqualToString:@"Online"])
    {
        //[postedMsgCustomCell.statusButton setBackgroundImage:[UIImage imageNamed:@"online.png"] forState:UIControlStateNormal];
        postedMsgCustomCell.imageViewForStatusImage.image=[UIImage imageNamed:@"online.png"] ;
    }
    else
    {
        //[postedMsgCustomCell.statusButton setBackgroundImage:[UIImage imageNamed:@"offline.png"] forState:UIControlStateNormal];
        postedMsgCustomCell.imageViewForStatusImage.image=[UIImage imageNamed:@"offline.png"] ;
    }
    NSString *contctExistCheck=[NSString stringWithFormat:@"%@",[[postedMessageArray objectAtIndex:indexPath.row]valueForKey:@"ContactExists"]];
    NSString *contctUserId=[NSString stringWithFormat:@"%@",[[postedMessageArray objectAtIndex:indexPath.row]valueForKey:@"UserId"]];
    
    if([contctExistCheck isEqualToString:@"0"])
    {
        if([CURRENT_USER_ID isEqualToString:contctUserId] )
        {
            postedMsgCustomCell.buttonForAddContact.hidden=YES;
        }
        else
        {
            postedMsgCustomCell.buttonForAddContact.hidden=NO;
        }
    }
    else
    {
        postedMsgCustomCell.buttonForAddContact.hidden=YES;
    }
    selctedIndex=indexPath.row;
    
    [postedMsgCustomCell.buttonForAddContact addTarget:self action:@selector(handelAddContact:event:) forControlEvents:UIControlEventTouchUpInside];
    [postedMsgCustomCell.startedByButton addTarget:self action:@selector(handelStartedBy:event:) forControlEvents:UIControlEventTouchUpInside];
    [postedMsgCustomCell.statusButton addTarget:self action:@selector(handelStartedBy:event:) forControlEvents:UIControlEventTouchUpInside];
    postedMsgCustomCell.buttonForAddContact.tag=indexPath.row;
    postedMsgCustomCell.startedByButton.tag=indexPath.row;
    return postedMsgCustomCell;
}
-(void)myFunction :(UITapGestureRecognizer *) sender
{
   UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    NSLog(@"Tag = %ld", (long)gesture.view.tag);
    NSURL *url = [NSURL URLWithString:[[[postedMessageArray objectAtIndex:sender.view.tag]valueForKey:@"ImageName"]
                                       stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    [self.imageViewForLargeImage setImageWithURL:url];
    
    self.ViewforLargeImage.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:self.ViewforLargeImage];
}

- (IBAction)cancelImagePreview:(id)sender
{
    [self.ViewforLargeImage removeFromSuperview];
}


-(void)handelStartedBy:(UIButton *)button event:(UIEvent *)event
{
    selectedIndexpath=[self.postedTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.postedTableView]];
//    NSLog(@"indexpath %ld",(long)selectedIndexpath.row);
    
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to delete this contact ?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//    [alert show];
    
//    if([[[postedMessageArray objectAtIndex:selectedIndexpath.row]valueForKey:@"ChatStatus"]isEqualToString:@"Online"])
//    {
    NSString *useid=[NSString stringWithFormat:@"%@",[[postedMessageArray objectAtIndex:selectedIndexpath.row]valueForKey:@"UserId"]];
    if(![useid isEqualToString:CURRENT_USER_ID])
    {
        NSString *addeUser=[NSString stringWithFormat:@"%@",[[postedMessageArray objectAtIndex:selectedIndexpath.row]valueForKey:@"ContactExists"]];
        if([addeUser isEqualToString:@"1"])
        {
                ChatMeassageVC *chatVc=[[ChatMeassageVC alloc]initWithNibName:@"ChatMeassageVC" bundle:[NSBundle mainBundle]];
                chatVc.chatUserID=[NSString stringWithFormat:@"%@",[[postedMessageArray objectAtIndex:selectedIndexpath.row]valueForKey:@"UserId"]] ;
                chatVc.titleName=[[postedMessageArray objectAtIndex:selectedIndexpath.row]valueForKey:@"UserName"];
                NSLog(@"indexpath %@",[[postedMessageArray objectAtIndex:selectedIndexpath.row]valueForKey:@"UserId"]);
                
                [self.navigationController pushViewController:chatVc animated:YES];
        }
        else
        {
            indexpath=[self.postedTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.postedTableView]];
            
            appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
            
            if (appDeleagated.internetStatus==0)
            {
                  [SVProgressHUD showErrorWithStatus:@"Internet connection not available" maskType:SVProgressHUDMaskTypeBlack];
            }
            else
            {
                // [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
                if (serviceIntegration != nil)
                {
                    serviceIntegration = nil;
                }
                serviceIntegration = [[ServerIntegration alloc]init];
                isContactNotAdded=true;
                [serviceIntegration AddContactFromPostMessageList:self UserId:CURRENT_USER_ID ContactId:[[postedMessageArray objectAtIndex:indexpath.row]valueForKey:@"UserId"] :@selector(receivedResponseAddContactInPostedMessage:)];
            }
        }
    }
}


-(void)handelAddContact:(UIButton *)button event:(UIEvent *)event
{
    
    indexpath=[self.postedTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.postedTableView]];
   // NSLog(@"indexpath %ld",(long)indexpath.row);
    [self addContactAlert];
}

-(void)addContactAlert
{
    if (IS_IOS8)
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kAlertTitle message:@"Are you sure you want to add this user to your contact list?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                       [self handleOkAddContactAction];
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
        
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you want to add this user to your contact list?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//        [alert show];
    }
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex==0)
//    {
//        [self handleOkAddContactAction];
//    }
//}
-(void)handleOkAddContactAction
{
    appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (appDeleagated.internetStatus==0)
    {
        [SVProgressHUD showErrorWithStatus:@"Internet connection not available" maskType:SVProgressHUDMaskTypeBlack];
    }
    else
    {
        // [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
        if (serviceIntegration != nil)
        {
            serviceIntegration = nil;
        }
        serviceIntegration = [[ServerIntegration alloc]init];
        [serviceIntegration AddContactFromPostMessageList:self UserId:CURRENT_USER_ID ContactId:[[postedMessageArray objectAtIndex:indexpath.row]valueForKey:@"UserId"] :@selector(receivedResponseAddContactInPostedMessage:)];
    }
    
}
- (void)receivedResponseAddContactInPostedMessage:(NSDictionary *)responseDict
{
    // [SVProgressHUD dismiss];
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        if (isContactNotAdded)
        {
            isContactNotAdded=NO;
            ChatMeassageVC *chatVc=[[ChatMeassageVC alloc]initWithNibName:@"ChatMeassageVC" bundle:[NSBundle mainBundle]];
            chatVc.chatUserID=[NSString stringWithFormat:@"%@",[[postedMessageArray objectAtIndex:selectedIndexpath.row]valueForKey:@"UserId"]] ;
            chatVc.titleName=[[postedMessageArray objectAtIndex:selectedIndexpath.row]valueForKey:@"UserName"];
           // NSLog(@"indexpath %@",[[postedMessageArray objectAtIndex:selectedIndexpath.row]valueForKey:@"UserId"]);
            [self.navigationController pushViewController:chatVc animated:YES];
            if (self.quickSearchVC)
            {
                [self callQuickSearchWS];
            }
            else
            {
                [self callPostedMessageWSForAdvanceSearch];
            }
        }
        else
        {
            if (self.quickSearchVC)
            {
                [SVProgressHUD showSuccessWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
                [self callQuickSearchWS];
            }
            else
            {
                [SVProgressHUD showSuccessWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
                [self callPostedMessageWSForAdvanceSearch];
            }
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
    isContactNotAdded=NO;
}
-(void)callQuickSearchWS
{
    
    appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (appDeleagated.internetStatus==0)
    {
          [SVProgressHUD showErrorWithStatus:@"Internet connection not available" maskType:SVProgressHUDMaskTypeBlack];
    }
    else
    {
        // [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
        if (serviceIntegration != nil)
        {
            serviceIntegration = nil;
        }
        serviceIntegration = [[ServerIntegration alloc]init];
        
        [serviceIntegration SearchPostedMessage:self UserId:CURRENT_USER_ID KeyWord:self.quickSearchVC.textFieldForSearch.text :@selector(receivedResponseDataForPostedMessageFromQuickSearch:)];
    }
}

#pragma mark== Receive Response

- (void)receivedResponseDataForPostedMessageFromQuickSearch:(NSMutableArray *)responseArray
{
     [SVProgressHUD dismiss];
   //NSLog(@"Respons%@",responseArray);
    if (responseArray.count>0)
    {
        self.postedMessageArray=[[NSMutableArray alloc]initWithArray:responseArray];
        [self.postedTableView reloadData];
    }
    else if(responseArray.count== 0)
    {
//        [SVProgressHUD showErrorWithStatus:@"No record found" maskType:SVProgressHUDMaskTypeBlack];
    }
}


//Did select row at index path
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostedMessageDetailViewController *postedMsgDetailVc=[[PostedMessageDetailViewController alloc]initWithNibName:@"PostedMessageDetailViewController" bundle:[NSBundle mainBundle]];
    
    postedMsgDetailVc.postedMsgVc=self;
    //NSLog(@"indexPath.row%ld",(long)indexPath.row);
    postedMsgDetailVc.messageId=[[postedMessageArray objectAtIndex:indexPath.row]valueForKey:@"MessageId"];
    postedMsgDetailVc.postedById=[[postedMessageArray objectAtIndex:indexPath.row]valueForKey:@"UserId"];
    [self.navigationController pushViewController:postedMsgDetailVc animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}
-(void)tableFooterAdjustmentInPosted
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.postedTableView.tableFooterView = view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)callPostedMessageWSForAdvanceSearch
{
    if (lessThan30String != nil)
    {
        lessThan30String = nil;
    }
    if ([(self.advanceSearchViewController.radioBtnLessThan.selected ? @"true": @"false" ) isEqualToString:@"true"])
    {
        lessThan30String = @"1";
    }
    else if ([(self.advanceSearchViewController.radioButtonMoreThan.selected ? @"true": @"false" ) isEqualToString:@"true"])
    {
        lessThan30String = @"2";
    }
    else
    {
        lessThan30String = @"3";
    }
    appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
    if (appDeleagated.internetStatus==0)
    {
          [SVProgressHUD showErrorWithStatus:@"Internet connection not available" maskType:SVProgressHUDMaskTypeBlack];
    }
    else
    {
        // [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
        
        if (serviceIntegration != nil)
        {
            serviceIntegration = nil;
        }
        serviceIntegration = [[ServerIntegration alloc]init];
        
        [serviceIntegration PostedMessageList:self UserId:CURRENT_USER_ID KeyWord:self.advanceSearchViewController.textfieldForTitle.text StateId:self.advanceSearchViewController.stateId CityId:self.advanceSearchViewController.cityId ZipCodeId:self.advanceSearchViewController.zipCodeId M2M:(self.advanceSearchViewController.m2mBtn.selected ? @"true": @"false") M2W:(self.advanceSearchViewController.m2wBtn.selected ? @"true": @"false") W2W:(self.advanceSearchViewController.w2wBtn.selected ? @"true": @"false") W2M:(self.advanceSearchViewController.w2mBtn.selected ? @"true": @"false") Everyone:(self.advanceSearchViewController.everyOneBtn.selected ? @"true": @"false") LessThan30Days:lessThan30String :@selector(receivedResponseDataForPostedMessageAdvanceSearch:)];
    }
}
#pragma mark== Receive Response
- (void)receivedResponseDataForPostedMessageAdvanceSearch:(NSMutableArray *)responseArray
{
     [SVProgressHUD dismiss];
    //NSLog(@"Respons%@",responseArray);
    if (responseArray.count>0)
    {
        self.postedMessageArray=[[NSMutableArray alloc]initWithArray:responseArray];
        [self.postedTableView reloadData];
    }
    else if(responseArray.count== 0)
    {
//        [SVProgressHUD showErrorWithStatus:@"No record found" maskType:SVProgressHUDMaskTypeBlack];
    }
    
}

@end

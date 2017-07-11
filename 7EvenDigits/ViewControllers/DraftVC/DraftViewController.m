//
//  DraftViewController.m
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import "DraftViewController.h"
#import "Constant.h"
#import "Parameters.h"
#import "HomeViewController.h"

@interface DraftViewController ()

@end

@implementation DraftViewController
@synthesize userNameLabel,messageLabel,replayDateLabel,statusImage;
@synthesize customCellForDraft,searchBarforDraft;
@synthesize draftDataAfterSearch,draftDataArray,draftArray,noRecordFoundLabel,draftSelectedItemArray;
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
    searching=NO;
    
    self.title=@"Draft";    
    searchBarforDraft.barTintColor=[UIColor colorWithRed:235.0f/255.0f green:110.0f/255.0f blue:30.0f/255.0f alpha:1 ];
    
    allBtnClk=FALSE;
   
    [self setNavigationBarButtons];
//    [self.tableViewDraft reloadData];
    
    
    [self tableFooterAdjustment];
}
-(void)viewWillAppear:(BOOL)animated
{
    draftSelectedItemArray=[[NSMutableArray alloc]init];
    searching=FALSE;
    searchBarforDraft.text=@"";
    [searchBarforDraft resignFirstResponder];
    
    [self callDraftMessageListWebService];
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
    [btnAll addTarget:self action:@selector(handelAllBtnClkDraft:) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:btnAll];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:customView];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    UIBarButtonItem *menuBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"home_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelHome)];
    self.navigationItem.leftBarButtonItem=menuBarBtn;
    
}
-(void)handelAllBtnClkDraft: (id) sender
{
    
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if(button.selected)
    {
        allBtnClk=TRUE;
        [draftSelectedItemArray removeAllObjects];
        if(searching)
        {
            for (int i = 0; i < [draftDataAfterSearch count]; i++)
            {
                [draftSelectedItemArray addObject:[NSString stringWithFormat:@"%ld",(long)[[[draftDataAfterSearch objectAtIndex:i]valueForKey:@"MessageId"] integerValue]]];
                //NSLog(@"draftSelectedItemArray%@",draftSelectedItemArray);
            }
            [self.tableViewDraft reloadData];
        }
        else
        {
            for (int i = 0; i < [draftArray count]; i++)
            {
                [draftSelectedItemArray addObject:[NSString stringWithFormat:@"%ld",(long)[[[draftArray objectAtIndex:i]valueForKey:@"MessageId"] integerValue]]];
                
            }
            [self.tableViewDraft reloadData];
        }
        
        [self.tableViewDraft reloadData];
    }
    else
    {
        [draftSelectedItemArray removeAllObjects];
        [self.tableViewDraft reloadData];
    }
    
}

-(void)handelDelete
{
    [self.searchBarforDraft resignFirstResponder];
    
    if([draftSelectedItemArray count] == 0)
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
                                        [self handleOkActionButton];
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
//            [alert show];
        }
    }
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0)
//    {
//        [self handleOkActionButton];
//    }
//}
-(void)handleOkActionButton
{
    if(draftSelectedItemArray.count == 0)
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
        
        NSMutableString *strForId=[[NSMutableString alloc]init];
        
        for (int i=0; i< draftSelectedItemArray.count;i++)
        {
            [strForId appendFormat:@"%@,", [draftSelectedItemArray objectAtIndex:i]];
        }
        [serviceIntegration DeletePostingMessage:self MessageId:strForId  :@selector(receivedResponseDataDraftMessageDelete:)];
    }
}
- (void)receivedResponseDataDraftMessageDelete:(NSDictionary *)responseDict
{
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        [SVProgressHUD showSuccessWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
        [self callDraftMessageListWebService];
        [self.tableViewDraft reloadData];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
}

-(void)callDraftMessageListWebService
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
        
        [serviceIntegration GetDraftMessageListWebService:self UserId:CURRENT_USER_ID :@selector(receivedResponseDraftList:)];
    }
    
}
- (void)receivedResponseDraftList:(NSArray *)responseDict
{
     [SVProgressHUD dismiss];
    //NSLog(@"draft Resp%@",responseDict);
    draftArray=[[NSMutableArray alloc]initWithArray:responseDict];
    if([draftArray count]==0)
    {
        noRecordFoundLabel.hidden=NO;
        btnAll.userInteractionEnabled=NO;
        btnDelete.userInteractionEnabled=NO;
    }
    else
    {
        noRecordFoundLabel.hidden=YES;
        btnAll.userInteractionEnabled=YES;
        btnDelete.userInteractionEnabled=YES;
    }
    [self.tableViewDraft reloadData];
}

#pragma mark==Navigate to home view
-(void)handelHome
{
    [searchBarforDraft resignFirstResponder];
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
        return [draftDataAfterSearch count];
    }
    else
    {
         return [draftArray count];
    }
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    
    customCellForDraft = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(customCellForDraft==nil)
    {
        customCellForDraft=[[[NSBundle mainBundle]loadNibNamed:@"DraftCustomCell" owner:self options:nil]objectAtIndex:0];
        customCellForDraft.showsReorderControl=YES;
    }
    customCellForDraft.selectionStyle=UITableViewCellSelectionStyleNone;
    
    [customCellForDraft.deleteDraftButton addTarget:self action:@selector(handelCheckBoxButtonClk:event:) forControlEvents:UIControlEventTouchUpInside];
    customCellForDraft.deleteDraftButton.tag=indexPath.row;
    
    if(searching)
    {
        
        customCellForDraft.labelForDraftDate.text=[[draftDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"PostedDate"];
        customCellForDraft.labelForDraftTitle.text=[[draftDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"Title"];
        
        NSString *plainMessage = [Parameters decodeDataForEmogies:[[draftDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"PlainMessage"]];
        
            if(![plainMessage isEqual:[NSNull null]])
            {
                customCellForDraft.labelForMessage.text=plainMessage;
            }
        
        if([[[draftDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"Status"]isEqualToString:@"online"])
        {
            //statusImage.image=[UIImage imageNamed:@"online.png"];
            customCellForDraft.imageViewForDraftStatusImage.image=[UIImage imageNamed:@"online.png"];
        }
        else
        {
            //statusImage.image=[UIImage imageNamed:@"offline.png"];
            customCellForDraft.imageViewForDraftStatusImage.image=[UIImage imageNamed:@"offline.png"];
        }
        
        if([draftSelectedItemArray containsObject:[NSString stringWithFormat:@"%ld",(long)[[[draftDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"MessageId"] integerValue]]])
        {
            [customCellForDraft.deleteDraftButton setImage:[UIImage imageNamed:@"select_checkbox.png"] forState:UIControlStateNormal];
        }
        else
        {
            [customCellForDraft.deleteDraftButton setImage:[UIImage imageNamed:@"unselect_checkbox.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
//        userNameLabel=[[UILabel alloc]init];
//        userNameLabel.text=[[draftArray objectAtIndex:indexPath.row]valueForKey:@"UserName"];
//        //Get width of label
//        float widthIs =
//        [userNameLabel.text boundingRectWithSize:userNameLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:userNameLabel.font } context:nil].size.width;
//        userNameLabel.frame=CGRectMake(customCellForDraft.frame.origin.x+16, customCellForDraft.frame.origin.y+8, widthIs, 21);
//        userNameLabel.font=[UIFont fontWithName:@"" size:13];
//        [customCellForDraft.contentView addSubview:userNameLabel];
//        
//        //Status Image
//        statusImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"status.png"]];
//        statusImage.frame=CGRectMake(userNameLabel.frame.origin.x+widthIs+8, customCellForDraft.frame.origin.y+14, 9, 9);
//        [customCellForDraft.contentView addSubview:statusImage];
        
        customCellForDraft.labelForDraftDate.text=[[draftArray objectAtIndex:indexPath.row]valueForKey:@"PostedDate"];
        customCellForDraft.labelForDraftTitle.text=[[draftArray objectAtIndex:indexPath.row]valueForKey:@"Title"];
        
        NSString *plainMessage = [Parameters decodeDataForEmogies:[[draftArray objectAtIndex:indexPath.row]valueForKey:@"PlainMessage"]];
        
        if(![plainMessage isEqual:[NSNull null]])
        {
            customCellForDraft.labelForMessage.text=plainMessage;
        }
        
        
        if([[[draftArray objectAtIndex:indexPath.row]valueForKey:@"Status"]isEqualToString:@"online"])
        {
            //statusImage.image=[UIImage imageNamed:@"online.png"];
            customCellForDraft.imageViewForDraftStatusImage.image=[UIImage imageNamed:@"online.png"];
        }
        else
        {
            //statusImage.image=[UIImage imageNamed:@"offline.png"];
            customCellForDraft.imageViewForDraftStatusImage.image=[UIImage imageNamed:@"offline.png"];
        }
        
        if([draftSelectedItemArray containsObject:[NSString stringWithFormat:@"%ld",(long)[[[draftArray objectAtIndex:indexPath.row]valueForKey:@"MessageId"] integerValue]]])
        {
            [customCellForDraft.deleteDraftButton setImage:[UIImage imageNamed:@"select_checkbox.png"] forState:UIControlStateNormal];
        }
        else
        {
            [customCellForDraft.deleteDraftButton setImage:[UIImage imageNamed:@"unselect_checkbox.png"] forState:UIControlStateNormal];
        }
    }
  
    return customCellForDraft;
}

-(void)handelCheckBoxButtonClk: (UIButton *)sender event:(UIEvent *)event
{
    sender.selected = !sender.isSelected;
//    NSLog(@"sender.tag =%d",sender.tag);
    
    indexpath=[self.tableViewDraft indexPathForRowAtPoint:[[[event touchesForView:sender] anyObject] locationInView:self.tableViewDraft]];
    NSString *selectedMsgCellId;
    if(searching)
    {
        selectedMsgCellId = [NSString stringWithFormat:@"%ld",(long)[[[draftDataAfterSearch objectAtIndex:indexpath.row]valueForKey:@"MessageId"] integerValue]];
    }
    else
    {
        selectedMsgCellId = [NSString stringWithFormat:@"%ld",(long)[[[draftArray objectAtIndex:indexpath.row]valueForKey:@"MessageId"] integerValue]];
    }
    
    
    
    if(![draftSelectedItemArray containsObject:selectedMsgCellId])
    {
        [sender setImage:[UIImage imageNamed:@"select_checkbox.png"] forState:UIControlStateNormal];
        [draftSelectedItemArray addObject:selectedMsgCellId];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"unselect_checkbox.png"] forState:UIControlStateNormal];
        [draftSelectedItemArray removeObject:selectedMsgCellId];
    }
    if(allBtnClk)
    {
        allBtnClk=FALSE;
        if(draftSelectedItemArray.count != draftArray.count)
        {
            [btnAll setTitle:@"All" forState:UIControlStateNormal];
            btnAll.tintAdjustmentMode=YES;
        }
    }
    if(!allBtnClk)
    {
       
        if(draftSelectedItemArray.count == draftArray.count)
        {
             allBtnClk=TRUE;
            [btnAll setTitle:@"None" forState:UIControlStateNormal];
            btnAll.tintAdjustmentMode=YES;
        }
    }
    
}


//Did select row at index path
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    ComposeViewController *composeVC=[[ComposeViewController alloc]initWithNibName:@"ComposeViewController" bundle:[NSBundle mainBundle]];
    
    if (stringForTitle!=nil)
    {
        stringForTitle=nil;
    }
    stringForTitle=@"DraftMessage";
    
    composeVC.objDraftVc=self;
    if(searching)
    {
        composeVC.objDraftArray=[draftDataAfterSearch objectAtIndex:indexPath.row];
    }
    else
    {
        composeVC.objDraftArray=[draftArray objectAtIndex:indexPath.row];
    }
    searchBarforDraft.text=@"";
    [searchBarforDraft resignFirstResponder];
    [self.navigationController pushViewController:composeVC animated:YES];
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
    self.tableViewDraft.tableFooterView = view;
}

#pragma mark==Table view data
/*
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if(cell==nil)
 {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
 cell.showsReorderControl = YES;
 }
 
 //Status Image
 statusImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"status.png"]];
 statusImage.frame=CGRectMake(cell.frame.origin.x+280, cell.frame.origin.y+30, 15, 15);
 [cell.contentView addSubview:statusImage];
 
 //main Label
 userNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(cell.frame.origin.x+25, cell.frame.origin.y+3, 150, 20)];
 userNameLabel.text=@"Krishna";
 [cell.contentView addSubview:userNameLabel];
 
 //Detail Label
 messageLabel=[[UILabel alloc]initWithFrame:CGRectMake(cell.frame.origin.x+25, cell.frame.origin.y+30, 150, 20)];
 messageLabel.text=@"Met mi in bus";
 [cell.contentView addSubview:messageLabel];
 
 
 //Rplay Date  Label
 replayDateLabel=[[UILabel alloc]initWithFrame:CGRectMake(cell.frame.origin.x+220, cell.frame.origin.y+6, 150, 15)];
 replayDateLabel.text=@"28/10/2014";
 [cell.contentView addSubview:replayDateLabel];
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search Bar 

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    searchBarforDraft.autocapitalizationType= UITextAutocapitalizationTypeNone;
    searchBarforDraft.autocorrectionType= UITextAutocorrectionTypeNo;

    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    searchBar.showsCancelButton = NO;
    searchBarforDraft.text=@"";
    searching=FALSE;
    [self callDraftMessageListWebService];
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar*)searchBar1 textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        searching = FALSE;
        [self.tableViewDraft reloadData];
    }
    else
    {
        NSString *searchText = searchBar1.text;
        draftDataAfterSearch  = [[NSMutableArray alloc] init];
        for (NSMutableArray *item1 in draftArray)
        {
            NSString *string =[item1 valueForKey:@"Title"];
            NSRange range = [string rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound)
            {
                [self.draftDataAfterSearch addObject:item1];
            }
        }
        searching = true;
    }
    [self.tableViewDraft reloadData];
}
- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    searchBarforDraft.text=[NSString stringWithFormat:@"%@",[theSearchBar text]];
	[searchBarforDraft resignFirstResponder];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [searchBarforDraft resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}
@end

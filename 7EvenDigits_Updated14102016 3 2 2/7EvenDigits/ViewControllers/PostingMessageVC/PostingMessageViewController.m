//
//  PostingMessageViewController.m
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import "PostingMessageViewController.h"
#import "PostingDetailViewController.h"
#import "Constant.h"
#import "HomeViewController.h"
@interface PostingMessageViewController ()

@end

@implementation PostingMessageViewController
@synthesize statusImage,messageLabel,dateLabel;
@synthesize customCellForPostingMsg,postingDataAfterSearch,postingDataArray;
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
    searching=NO;
    self.navigationController.navigationBarHidden=NO;
    self.title=@"Posting Message";
    [self tableFooterAdjustment];
    
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"home_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(menuBtnClk)];
    self.navigationItem.leftBarButtonItem=rightBarBtn;

    
    //UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc]initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(handelHomeVC)];
    //self.navigationItem.rightBarButtonItem=rightBarButton;
}

-(void)callPostingMessageWebService
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
        
        [serviceIntegration PostingMessageListWebService:self UserId:CURRENT_USER_ID :@selector(receivedResponsePostingList:)];

    }
    
}
- (void)receivedResponsePostingList:(NSArray *)responseDict
{
     [SVProgressHUD dismiss];
   // NSLog(@"cont Resp%@",responseDict);
    postingDataArray=[[NSMutableArray alloc]initWithArray:responseDict];
    if([postingDataArray count]==0)
    {
         noRecordFoundLabel.hidden=NO;
    }
    else
    {
        noRecordFoundLabel.hidden=YES;
    }
    
    [self.tableViewPostingMesssage reloadData];

}

-(void)viewWillAppear:(BOOL)animated
{
    searching=FALSE;
    [self.postingMsgSearchBar resignFirstResponder];
    self.postingMsgSearchBar.text=@"";
    [self callPostingMessageWebService];
    [self.tableViewPostingMesssage reloadData];

}

#pragma mark==Navigate to home view
-(void)menuBtnClk
{
    [_postingMsgSearchBar resignFirstResponder];
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
        return [postingDataAfterSearch count];
    }
    else
    {
        return [postingDataArray count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    customCellForPostingMsg= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(customCellForPostingMsg==nil)
    {
        customCellForPostingMsg=[[[NSBundle mainBundle]loadNibNamed:@"PostingMessageCustomCell" owner:self options:nil]objectAtIndex:0];
        customCellForPostingMsg.showsReorderControl=YES;
    }
    
    customCellForPostingMsg.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (searching)
    {
        customCellForPostingMsg.labelForDate.text=[[postingDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"PostedDate"];
        customCellForPostingMsg.labelforMessage.text=[Parameters decodeDataForEmogies:[[postingDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"PlainMessage"]];
        customCellForPostingMsg.labelForTitle.text=[[postingDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"Title"];
        
        if([[[postingDataAfterSearch objectAtIndex:indexPath.row]valueForKey:@"Active"]isEqualToString:@"Active"])
        {
            customCellForPostingMsg.labelForStatus.textColor=[UIColor colorWithRed:151.0f/255.0f green:193.0f/255.0f blue:82.0f/255.0f alpha:1];
            customCellForPostingMsg.labelForStatus.text=@"Active";
        }
        else
        {
            customCellForPostingMsg.labelForStatus.textColor=[UIColor redColor];
            customCellForPostingMsg.labelForStatus.text=@"Expired";
        }
    }
    else
    {
        customCellForPostingMsg.labelForDate.text=[[postingDataArray objectAtIndex:indexPath.row]valueForKey:@"PostedDate"];
        customCellForPostingMsg.labelforMessage.text=[Parameters decodeDataForEmogies:[[postingDataArray objectAtIndex:indexPath.row]valueForKey:@"PlainMessage"]];
        customCellForPostingMsg.labelForTitle.text=[[postingDataArray objectAtIndex:indexPath.row]valueForKey:@"Title"];
        
        if([[[postingDataArray objectAtIndex:indexPath.row]valueForKey:@"Active"]isEqualToString:@"Active"])
        {
            customCellForPostingMsg.labelForStatus.textColor=[UIColor colorWithRed:103.0f/255.0f green:160.0f/255.0f blue:17.0f/255.0f alpha:1 ];
            customCellForPostingMsg.labelForStatus.text=@"Active";
        }
        else
        {
            customCellForPostingMsg.labelForStatus.textColor=[UIColor redColor];
            customCellForPostingMsg.labelForStatus.text=@"Expired";
        }
    }
    return customCellForPostingMsg;
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
    self.tableViewPostingMesssage.tableFooterView = view;
}


//Did select row at index path
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.postingMsgSearchBar resignFirstResponder];
    PostingDetailViewController *postDtlVC=[[PostingDetailViewController alloc]initWithNibName:@"PostingDetailViewController" bundle:[NSBundle mainBundle]];
    postDtlVC.postingMessageVC=self;
    
    if (searching)
    {
        postDtlVC.postingDetailArray=[postingDataAfterSearch objectAtIndex:indexPath.row];

    }
    else
    {
        postDtlVC.postingDetailArray=[postingDataArray objectAtIndex:indexPath.row];

    }
    [self.navigationController pushViewController:postDtlVC animated:YES];

}
#pragma mark==Table Data
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
 messageLabel=[[UILabel alloc]initWithFrame:CGRectMake(cell.frame.origin.x+35, cell.frame.origin.y+3, 150, 20)];
 messageLabel.text=@"Todays days";
 [cell.contentView addSubview:messageLabel];
 
 
 //Rplay Date  Label
 dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(cell.frame.origin.x+220, cell.frame.origin.y+6, 150, 15)];
 dateLabel.text=@"28/10/2014";
 [cell.contentView addSubview:dateLabel];
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    self.postingMsgSearchBar.autocapitalizationType= UITextAutocapitalizationTypeNone;
    self.postingMsgSearchBar.autocorrectionType= UITextAutocorrectionTypeNo;

    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searching = FALSE;
    self.postingMsgSearchBar.text=@"";
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    [self.tableViewPostingMesssage reloadData];
}


-(void)searchBar:(UISearchBar*)searchBar1 textDidChange:(NSString*)text
{
    self.postingMsgSearchBar.autocapitalizationType= UITextAutocapitalizationTypeNone;
    self.postingMsgSearchBar.autocorrectionType= UITextAutocorrectionTypeNo;
    
    if(text.length == 0)
    {
        searching = FALSE;
        [self callPostingMessageWebService];
        [self.tableViewPostingMesssage reloadData];
    }
    else
    {
        NSString *searchText = searchBar1.text;
        postingDataAfterSearch  = [[NSMutableArray alloc] init];
        for (NSMutableArray *item1 in postingDataArray)
        {
            NSString *string =[item1 valueForKey:@"Title"];
            NSRange range = [string rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound)
            {
                [self.postingDataAfterSearch addObject:item1];
            }
        }
        searching = true;
    }
    [self.tableViewPostingMesssage reloadData];
}
- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    self.postingMsgSearchBar.text=[NSString stringWithFormat:@"%@",[theSearchBar text]];
	[self.postingMsgSearchBar resignFirstResponder];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.postingMsgSearchBar resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}


@end
